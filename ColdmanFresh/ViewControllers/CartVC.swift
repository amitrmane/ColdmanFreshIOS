//
//  CartVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit
import CoreLocation

protocol BackRefresh {
    func updateData(_ data: Any)
}

class CartVC: SuperViewController {
    
    @IBOutlet weak var lblRestaurantTitle: UILabel!
    @IBOutlet weak var ivResto: UIImageView!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var lblCartTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblPromoDiscount: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var viewBaseTax: UIView!
    
    @IBOutlet weak var viewOffers: UIView!
    @IBOutlet weak var btnOffers: UIButton!
    @IBOutlet weak var lblOffers: UILabel!
    @IBOutlet weak var viewOffersHeight: NSLayoutConstraint!

    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var lblAddress: UILabel!

    @IBOutlet weak var btnProceedCheckout: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    var addedMenus = [Menu]()
//    var allTaxes = [Tax]()
    var user : UserProfile!
    var backDelegate : BackRefresh!
    var allAddress = [Address]()
    var currentAddress : Address!
    var selectedOffer : Offers!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getTaxes()
        DispatchQueue.main.async {
            self.refreshData()
        }
        if let addrs = self.currentAddress {
            self.lblAddress.text = addrs.address
        }else {
            getUserAdresses()
        }
        if let user = Utilities.getCurrentUser() {
            self.user = user
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        if let del = self.backDelegate {
            del.updateData(self.addedMenus)
        }
        if self.addedMenus.count > 0 {
            Menu.saveCartItems(self.addedMenus)
        }else {
            Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func addresschangeTapped(_ sender: UIButton) {
        if let user = self.user {
            let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "AddressListViewController") as! AddressListViewController
            addressvc.user = user
            addressvc.isFromHome = true
            addressvc.delegate = self
            addressvc.selectedAddr = self.currentAddress
            self.navigationController?.pushViewController(addressvc, animated: true)
        }
    }
    
    @IBAction func offersTapped(_ sender: UIButton) {
        let offersvc = mainStoryboard.instantiateViewController(withIdentifier: "OffersVC") as! OffersVC
        offersvc.addedMenus = self.addedMenus
        offersvc.backDelegate = self
        offersvc.currentAddress = self.currentAddress
        offersvc.user = self.user
        offersvc.selectedOffer = self.selectedOffer
        self.navigationController?.pushViewController(offersvc, animated: true)
    }
        
    @IBAction func checkOutTapped(_ sender: UIButton) {
        let summaryvc = mainStoryboard.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
        summaryvc.user = user
        summaryvc.addedMenus = self.addedMenus
        summaryvc.currentAddress = self.currentAddress
        summaryvc.selectedOffer = self.selectedOffer
        self.navigationController?.pushViewController(summaryvc, animated: true)
    }
    
    
}

extension CartVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.addedMenus.count == 0 {
            self.showNoRecordsView(tableView)
        }else {
            tableView.backgroundView = nil
        }
        return self.addedMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! MenuCell
        
        let menu = self.addedMenus[indexPath.row]
        cell.lblTitle.text = menu.menu_displayname
        if menu.selectedVariation != nil {
            cell.lblDesc.text = "Variation: " + menu.selectedVariation.name
        }else {
            cell.lblDesc.text = "Variation: NA"
        }
        cell.lblMenuCount.text = "\(menu.menuCount)"
        cell.lblOrderValue.text = "₹ \(menu.displayPrice)"

        if let urlstr = (menu.menu_logo).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlstr) {
            cell.ivMenu.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        
        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = 80
        let menu = self.addedMenus[indexPath.row]
        height += menu.menu_displayname.heightWithConstrainedWidth(ScreenSize.SCREEN_WIDTH - 230, font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular))
        return height
    }
    
    @objc func plusTapped(_ sender: UIButton) {
        let menu = self.addedMenus[sender.tag]
        menu.menuCount += 1
        menu.displayPrice = menu.price * Double(menu.menuCount)
        refreshData()
    }
    
    @objc func minusTapped(_ sender: UIButton) {
        let menu = self.addedMenus[sender.tag]
        if menu.menuCount > 1 {
            menu.menuCount -= 1
        }
        menu.displayPrice = menu.price * Double(menu.menuCount)
        refreshData()
    }
    
    @objc func deleteTapped(_ sender: UIButton) {
        self.addedMenus.remove(at: sender.tag)
        refreshData()
    }
    
    func showNoRecordsView(_ tableView: UITableView) {
        let v1 = UIView(frame: tableView.frame)
        let noDataIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        noDataIV.contentMode = .scaleAspectFit
        noDataIV.center = self.viewBaseTax.center
        noDataIV.image = UIImage(named: "no-food")
        v1.addSubview(noDataIV)
        tableView.backgroundView  = v1
        self.btnProceedCheckout.isHidden = true
        self.viewBaseTax.isHidden = true
    }
    
    func refreshData() {
        
        if let addrs = self.currentAddress {
            self.lblAddress.text = addrs.address
        }
        
        let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
        self.lblCartTotal.text = "₹ \(String(format: "%.2f", val))"
                
        var offerdiscount = 0.0
        if let offer = self.selectedOffer {
            offerdiscount = offer.userDiscount.toDouble() ?? 0
            self.lblPromoDiscount.text = "- ₹ \(offerdiscount)"
        }else {
            self.lblPromoDiscount.text = "- ₹ 0.00"
        }
        let total = (val) - (offerdiscount)
        
        self.lblSubTotal.text = "₹ \(String(format: "%.2f", total))"
        
        self.tblMenu.reloadData()
    }
    
}

extension CartVC : LoginSuccessProtocol, BackRefresh, AddressSelectionProtocol {
    
    func loginSuccess(profile: UserProfile) {
        print(profile)
        user = profile
//        let ordervc = mainStoryboard.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
//        ordervc.restaurent = self.restaurent
//        ordervc.user = self.user
//        ordervc.addedMenus = self.addedMenus
//        ordervc.allTaxes = self.allTaxes
//        self.navigationController?.pushViewController(ordervc, animated: true)
    }
    
    func selectedAddress(addr: Address) {
        self.currentAddress = addr
        self.lblAddress.text = addr.address
        self.refreshData()
    }
    
    func updateData(_ data: Any) {
        if let offer = data as? Offers {
            self.selectedOffer = offer
            self.lblOffers.text = "\(offer.discount_coupon) applied successfully! \nYou will get ₹ \(offer.userDiscount) off!"
            self.refreshData()
        }
    }
}

extension CartVC {
    
    func getAllTaxes() {
        /*guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
        self.tblMenu.reloadData()
        ApiManager.getAllTaxes() { (json, success, error) in
            self.hideActivityIndicator()
            if success {
                if let arr = json?.array {
                    self.allTaxes = Tax.getAllTaxes(array: arr)
                    self.refreshData()
                }
            }else {
                self.showAlert(error.rawValue)
            }
        }*/
    }
    
    func getTaxes() {
        /*guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
        self.tblMenu.reloadData()
        ApiManager.getTax() { (json, success, error) in
            self.hideActivityIndicator()
            if success {
                if let dict = json?.dictionary {
                    if dict["status"]?.number == 200 {
                        if let arr = dict["list"]?.array {
                            self.allTaxes = Tax.getAllTaxes(array: arr)
                        }
                    }
                }
                self.refreshData()
            }else {
                self.showAlert(error.rawValue)
            }
        }*/
    }
    
    func getUserAdresses() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getUserAddresses(userid: user.user_id) { (json) in
            self.hideActivityIndicator()
            
            if let dict = json?.dictionary,
               let array = dict["address"]?.array {
                self.allAddress = Address.getAllAddresses(array: array)
                if let addrs = self.allAddress.filter({ $0.primaryAddress == "1" }).first {
                    self.currentAddress = addrs
                    self.refreshData()
                }
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

}

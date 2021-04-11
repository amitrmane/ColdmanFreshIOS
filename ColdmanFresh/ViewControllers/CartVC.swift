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
    @IBOutlet weak var viewAddressHeight: NSLayoutConstraint!

    @IBOutlet weak var btnProceedCheckout: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    var addedMenus = [Menu]()
//    var allTaxes = [Tax]()
    var user : UserProfile!
    var backDelegate : BackRefresh!
    var allAddress = [Address]()
    var currentAddress : Address!
    var selectedOffer : Offers!
    var organizations = [Organization]()
    var selectedOrganization : Organization!
    var pincodes = [Pincode]()
    var selectedPincode : Pincode!
    var charges = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.refreshData()
        }
        if let user = Utilities.getCurrentUser() {
            self.user = user
            if user.customer_type == Constants.b2cHomeDelivery {
                if let pin = Utilities.getCurrentUserTypeDetails() as? Pincode {
                    self.selectedPincode = pin
                    self.lblAddress.text = "Please select address"
                }
                getUserAdresses()
                self.btnAddress.isHidden = false
            }else {
                self.btnAddress.isHidden = true
                if let org = Utilities.getCurrentUserTypeDetails() as? Organization {
                    self.selectedOrganization = org
                    self.lblAddress.text = org.address
                }else {
                    self.getOrganizationList()
                }
            }
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
        
        let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
        
        if val < 300 {
            self.showAlert("Minimum order value should be ₹ 300. \nPlease add more items to the cart.")
            return
        }
        if self.addedMenus.count > 0 {
            Menu.saveCartItems(self.addedMenus)
        }
        if self.user.customer_type == Constants.b2cHomeDelivery {
            guard let _ = self.currentAddress else {
                self.showAlert("Select address")
                return
            }
        }
        let summaryvc = mainStoryboard.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
        summaryvc.user = user
        summaryvc.addedMenus = self.addedMenus
        summaryvc.currentAddress = self.currentAddress
        summaryvc.selectedOffer = self.selectedOffer
        summaryvc.organizations = self.organizations
        summaryvc.selectedOrganization = self.selectedOrganization
        summaryvc.pincodes = self.pincodes
        summaryvc.selectedPincode = self.selectedPincode
        summaryvc.charges = self.charges
        self.navigationController?.pushViewController(summaryvc, animated: true)
    }
    
    
}

extension CartVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.addedMenus.count == 0 {
            self.showNoRecordsViewWithLabel(self.tblMenu, message: "Cart is Empty.")
            self.btnProceedCheckout.isHidden = true
            self.viewBaseTax.isHidden = true
        }else {
            tableView.backgroundView = nil
            self.btnProceedCheckout.isHidden = false
            self.viewBaseTax.isHidden = false
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
        if let vari = menu.selectedVariation, let rate = vari.rate.toDouble() {
            menu.displayPrice = rate * Double(menu.menuCount)
        }else {
            menu.displayPrice = menu.price * Double(menu.menuCount)
        }
        Menu.saveCartItems(self.addedMenus)
        refreshData()
    }
    
    @objc func minusTapped(_ sender: UIButton) {
        let menu = self.addedMenus[sender.tag]
        if menu.menuCount > 1 {
            menu.menuCount -= 1
            if let vari = menu.selectedVariation, let rate = vari.rate.toDouble() {
                menu.displayPrice = rate * Double(menu.menuCount)
            }else {
                menu.displayPrice = menu.price * Double(menu.menuCount)
            }
        }else {
            self.addedMenus.remove(at: sender.tag)
        }
        Menu.saveCartItems(self.addedMenus)
        refreshData()
    }
    
    @objc func deleteTapped(_ sender: UIButton) {
        self.addedMenus.remove(at: sender.tag)
        Menu.saveCartItems(self.addedMenus)
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
        
        var charge = 0.0
        if let u = self.user, u.customer_type == Constants.b2cHomeDelivery, let addrs = self.currentAddress {
            self.lblAddress.text = addrs.address
            if let pin = self.pincodes.filter({ $0.pincode == addrs.pincode }).first {
                self.selectedPincode = pin
                self.charges = pin.charges
                charge = self.charges.toDouble() ?? 0.0
                self.lblDelivery.text = "₹ \(String(format: "%.2f", charge))"
            }else if let pin = self.selectedPincode, pin.pincode == addrs.pincode {
                self.selectedPincode = pin
                self.charges = pin.charges
                charge = self.charges.toDouble() ?? 0.0
                self.lblDelivery.text = "₹ \(String(format: "%.2f", charge))"
            }else if let pin = self.selectedPincode {
                self.selectedPincode = pin
                self.charges = pin.charges
                charge = self.charges.toDouble() ?? 0.0
                self.lblDelivery.text = "₹ \(String(format: "%.2f", charge))"
            }
        }
        
        let total = (val + charge) - (offerdiscount)
        
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
    
    func getOrganizationList() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getOrganizationList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                self.organizations = Organization.getData(array: array)
                if let u = self.user, u.customer_type == Constants.b2cCorporate, let org = self.organizations.filter({ $0.organization_id == u.organization_id }).first {
                    self.selectedOrganization = org
                    
                    self.lblAddress.text = org.organization_name
                }
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
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
                if let pin = self.selectedPincode, let addrs = self.allAddress.filter({ $0.pincode == pin.pincode }).first {
                    self.currentAddress = addrs
                    self.refreshData()
                }else if let addrs = self.allAddress.filter({ $0.primaryAddress == "1" }).first {
                    self.currentAddress = addrs
                    self.refreshData()
                }else if let addrs = self.allAddress.first {
                    self.currentAddress = addrs
                    self.refreshData()
                }
                self.refreshData()
            }else {
//                self.showError(message: "Please ")
            }
            self.getPincodeList()
        }
        
    }
    
    func getPincodeList() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getPincodeList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                self.pincodes = Pincode.getData(array: array).filter({ $0.status == "1" })
                if let pin = self.selectedPincode, let addrs = self.allAddress.filter({ $0.pincode == pin.pincode }).first {
                    self.currentAddress = addrs
                    self.refreshData()
                }else if let addrs = self.allAddress.filter({ $0.primaryAddress == "1" }).first {
                    self.currentAddress = addrs
                    self.refreshData()
                }else if self.allAddress.count == 1, let addrs = self.allAddress.first {
                    self.currentAddress = addrs
                    self.refreshData()
                }
                self.refreshData()
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }


}

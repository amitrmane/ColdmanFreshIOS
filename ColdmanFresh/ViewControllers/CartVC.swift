//
//  CartVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit
import CoreLocation
import Razorpay

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
//    var currentAddress : Address!
//    var selectedOffer : Offers!
    var razorpay: RazorpayCheckout!
    var paymentId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        razorpay = RazorpayCheckout.initWithKey(Constants.Keys.razorPayKeyTest, andDelegate: self)
        self.getTaxes()
        DispatchQueue.main.async {
            self.refreshData()
        }
//        if let addrs = self.currentAddress {
//            self.lblAddress.text = addrs.addressDetails
//        }
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
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addresschangeTapped(_ sender: UIButton) {
//        if let user = self.user {
//            let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "AddressListViewController") as! AddressListViewController
//            addressvc.user = user
//            addressvc.isFromHome = true
//            addressvc.delegate = self
//            addressvc.selectedAddr = self.currentAddress
//            self.navigationController?.pushViewController(addressvc, animated: true)
//        }
    }
    
    @IBAction func offersTapped(_ sender: UIButton) {
//        let offersvc = mainStoryboard.instantiateViewController(withIdentifier: "OffersVC") as! OffersVC
//        offersvc.addedMenus = self.addedMenus
//        offersvc.allTaxes = self.allTaxes
//        offersvc.backDelegate = self
//        offersvc.currentAddress = self.currentAddress
//        offersvc.restaurent = self.restaurent
//        offersvc.user = self.user
//        offersvc.selectedOffer = self.selectedOffer
//        self.navigationController?.pushViewController(offersvc, animated: true)
    }
        
    @IBAction func checkOutTapped(_ sender: UIButton) {
        self.showPaymentForm()
        /*let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
        if let minval = self.restaurent.restaurant_food_min_price.toDouble(), val < minval {
            self.showAlert("Cart value should be greater than minimum order amount ₹ \(minval)")
            return
        }
        let defaults = UserDefaults.standard
        if let userData = defaults.object(forKey: "User") as? Data,
            let user = try? PropertyListDecoder().decode(UserProfile.self, from: userData) {
            let summaryvc = mainStoryboard.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
            summaryvc.user = user
            summaryvc.restaurent = self.restaurent
            summaryvc.allTaxes = self.allTaxes
            summaryvc.addedMenus = self.addedMenus
            summaryvc.selectedAddr = self.currentAddress
            summaryvc.selectedOffer = self.selectedOffer
            self.navigationController?.pushViewController(summaryvc, animated: true)
        } else {
            let loginvc = mainStoryboard.instantiateViewController(withIdentifier: "PhoneVerificationVC") as! PhoneVerificationVC
            loginvc.restaurent = self.restaurent
            loginvc.allTaxes = self.allTaxes
            loginvc.addedMenus = self.addedMenus
            loginvc.selectedAddr = self.currentAddress
            loginvc.selectedOffer = self.selectedOffer
            //        loginvc.delegate = self
            self.navigationController?.pushViewController(loginvc, animated: true)
        }*/
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
        let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
        self.lblCartTotal.text = "₹ \(String(format: "%.2f", val))"
        
//        var calculatedTax = 0.0
        
        /*for tax in self.allTaxes {
            if let res = self.restaurent, tax.restaurant_id == res.restaurant_id {
                if let cgst = tax.cgst.toDouble(), let sgst = tax.sgst.toDouble() {
                    calculatedTax = ((val/100) * cgst) + ((val/100) * sgst)
                }
            }
        }
        
        var distanceInKM = 7.1
        if let addr = self.currentAddress, let res = self.restaurent {
            let addr1lat = addr.lattitude
            let addr1long = addr.longitude
            if  let reslat = res.latitude.toDouble(), let reslong = res.longitude.toDouble() {
                let coordinate0 = CLLocation(latitude: addr1lat, longitude: addr1long)
                let coordinate1 = CLLocation(latitude: reslat, longitude: reslong)

                let distanceInMeters = coordinate0.distance(from: coordinate1) // result is in meters
                
                distanceInKM = distanceInMeters / 1000
            }
        }
        let charges = Utilities.getCharges(amount: val, distanceInKM: distanceInKM, planSelected: self.restaurent.resto_plan)
        self.lblDelivery.text = "\(charges)"
        
        self.lblTax.text = "₹ \(String(format: "%.2f", calculatedTax.roundTo(places: 2)))"*/
        
//        var offerdiscount = 0.0
//        if let offer = self.selectedOffer {
//            offerdiscount = offer.userDiscount.toDouble() ?? 0
//            self.lblPromoDiscount.text = "- ₹ \(offerdiscount)"
//        }else {
//            self.lblPromoDiscount.text = "- ₹ 0.00"
//        }
//        let total = (charges + val + calculatedTax.roundTo(places: 2)) - (offerdiscount)
        
        self.lblSubTotal.text = "₹ \(String(format: "%.2f", val))"
        
        self.tblMenu.reloadData()
    }
    
}

extension CartVC : LoginSuccessProtocol, BackRefresh {
    
    func loginSuccess(profile: UserProfile) {
        print(profile)
        user = profile
        self.callSaveOrderAPI(paymentId: paymentId)
//        let ordervc = mainStoryboard.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
//        ordervc.restaurent = self.restaurent
//        ordervc.user = self.user
//        ordervc.addedMenus = self.addedMenus
//        ordervc.allTaxes = self.allTaxes
//        self.navigationController?.pushViewController(ordervc, animated: true)
    }
    
//    func selectedAddress(addr: Address) {
//        self.currentAddress = addr
//        self.lblAddress.text = addr.addressDetails
//        self.refreshData()
//    }
    
    func updateData(_ data: Any) {
//        if let offer = data as? Offers {
//            self.selectedOffer = offer
//            self.lblOffers.text = "\(offer.discount_coupon) applied successfully! \nYou will get ₹ \(offer.userDiscount) off!"
//            self.refreshData()
//        }
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
}

// MARK: Razor Pay Payment
extension CartVC : RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol {
    func onPaymentError(_ code: Int32, description str: String) {
        print("Payment failed with code: \(code), msg: \(str)")
        self.showAlert("Payment failed with code: \(code), msg: \(str)")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("Payment Success payment id: \(payment_id)")
        self.paymentId = payment_id
        self.callSaveOrderAPI(paymentId: payment_id)
    }
    
    
    internal func showPaymentForm(){
        let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
//        let user = Utilities.getCurrentUser()
        let options: [String:Any] = [
            "amount": "\(val * 100)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "Coldman fresh order",
            //"order_id": "CFORDER\(UUID().uuidString)",
            "image": "",
            "name": "Coldman fresh",
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#4FB68D"
            ]
        ]
        razorpay.open(options, displayController: self)
    }
    
    public func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("Payment failed with code: \(code), msg: \(str)")
        self.showAlert("Payment failed with code: \(code) \nMessage: \(str)")
    }
    
    public func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("Payment Success payment id: \(payment_id), andData: \(String(describing: response))")
    }
    
    func callSaveOrderAPI(paymentId: String) {
        let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
        
//        var calculatedTax = 0.0
//        for tax in self.allTaxes {
//            if let res = self.restaurent, tax.restaurant_id == res.restaurant_id {
//                if let cgst = tax.cgst.toDouble(), let sgst = tax.sgst.toDouble() {
//                    calculatedTax = ((val/100) * cgst) + ((val/100) * sgst)
//                }
//            }
//        }
//
//        var offerdiscount = 0.0
//        var offercoupon = ""
//        if let offer = self.selectedOffer {
//            offerdiscount = offer.userDiscount.toDouble() ?? 0
//            offercoupon = offer.discount_coupon
//        }
//  pay_GR7AtlUIKkf3qM
//        let total = (charges + val + calculatedTax.roundTo(places: 2)) - (offerdiscount)

        guard ApiManager.checkuser_online() else {
            return
        }
                
        self.showActivityIndicator()
        
        var params = [String: Any]()
//        [{"restaurant_id":"3","menu_id":"7","menu_name":"snow_idli","menu_price":"100","qty":"2","cgst":"5","sgst":"5"}]
        var orderItemDetails = [[String: Any]]()
        
        for menu in self.addedMenus {
            var menuItem = [String: Any]()
            menuItem["menu_id"] = "\(menu.menu_id)"
            menuItem["menu_name"] = menu.menu_name
            menuItem["menu_price"] = menu.menu_price
            menuItem["qty"] = "\(menu.menuCount)"
            menuItem["menu_variation"] = "\(menu.selectedVariation != nil ? menu.selectedVariation.name : "")"
            orderItemDetails.append(menuItem)
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: orderItemDetails, options: [.prettyPrinted])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        params["order"] = "\(jsonString!)"
        params["user_id"] = "83"//self.user.user_id
        params["total"] = val
        params["transaction_id"] = paymentId
        params["discount_amount"] = ""
        params["coupon"] = ""

        print(params)
        
        ApiManager.saveOrderApi(params: params) { (json) in
            self.hideActivityIndicator()
            
            if let dict = json?.dictionary {
                if let status = dict["status"]?.number, status == 200, let orderId = dict["order_id"]?.number {
                    print(orderId)
                    self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "Order placed successfully!\n Order ID : \(orderId)", buttons: ["OK"]) { (i) in
                        Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
                        if let del = self.backDelegate {
                            del.updateData(self.addedMenus)
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                    }
//                    let placeOrdervc = mainStoryboard.instantiateViewController(withIdentifier: "OrderPlacedVC") as! OrderPlacedVC
//                    placeOrdervc.restaurent = self.restaurent
//                    placeOrdervc.user = self.user
//                    placeOrdervc.addedMenus = self.addedMenus
//                    placeOrdervc.allTaxes = self.allTaxes
//                    placeOrdervc.paymentDetails = self.paymentDetails
//                    placeOrdervc.isCOD = self.isCOD
//                    placeOrdervc.appOrderId = orderId.intValue
//                    placeOrdervc.selectedAddr = self.selectedAddr
//                    self.navigationController?.pushViewController(placeOrdervc, animated: true)
                }else {
                    self.showError(message: dict["message"]?.string ?? "Order placing failed, please try again")
                }
            }else {
                self.showError(message: "Order placing failed, please try again")
            }
        }
        
    }

    
}

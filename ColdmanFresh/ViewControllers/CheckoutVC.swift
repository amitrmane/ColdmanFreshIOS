//
//  CheckoutVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 30/01/21.
//

import UIKit
import Razorpay
import DropDown

class CheckoutVC: SuperViewController {

    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var lblCartTotal: UILabel!
    @IBOutlet weak var lblPromoDiscount: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var viewBaseTax: UIView!
    @IBOutlet weak var lblDelivery: UILabel!

    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewAddressHeight: NSLayoutConstraint!

    @IBOutlet weak var btnPayOnline: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var viewSelection: UIView!
    @IBOutlet weak var tfGate: UITextField!
    @IBOutlet weak var lblGate: UILabel!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfTimeslot: UITextField!
    @IBOutlet weak var constraintLblDateTop: NSLayoutConstraint!

    var addedMenus = [Menu]()
    var user : UserProfile!
    var allAddress = [Address]()
    var currentAddress : Address!
    var selectedOffer : Offers!
    var razorpay: RazorpayCheckout!
    var paymentId = ""
    var gates = [Gate]()
    var timeslots = [Timeslot]()
    var selectedGate : Gate!
    var selectedTimeslot : Timeslot!
    var selectedDate : Date!
    var organizations = [Organization]()
    var selectedOrganization : Organization!
    var pincodes = [Pincode]()
    var selectedPincode : Pincode!
    var charges = "0"
    var day = 1;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        razorpay = RazorpayCheckout.initWithKey(Constants.Keys.razorPayKeyLive, andDelegate: self)
        day = Date().hour >= 22 ? 2 : 1
        self.tfDate.text = Date().dateByAddingDays(day).stringFromDate(Date.DateFormat.yyyyMMdd)
        self.selectedDate = Date()
        self.getGateList()
        self.refreshData()
        if let u = self.user, u.customer_type == Constants.b2cHomeDelivery {
            self.constraintLblDateTop.constant = -50
            self.lblGate.isHidden = true
            self.tfGate.isHidden = true
        }else {
            self.constraintLblDateTop.constant = 15
            self.lblGate.isHidden = false
            self.tfGate.isHidden = false
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func payOnlineTapped(_ sender: UIButton) {
        if let u = self.user, u.customer_type != Constants.b2cHomeDelivery {
            guard let _ = self.selectedGate else {
                self.showAlert("Select gate")
                return
            }
        }
        guard let _ = self.selectedDate else {
            self.showAlert("Select date")
            return
        }
        guard let _ = self.selectedTimeslot else {
            self.showAlert("Select time slot")
            return
        }
        self.showPaymentForm()
    }

}

extension CheckoutVC : UITableViewDataSource, UITableViewDelegate {
    
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
        cell.lblTitle.text = menu.menu_displayname + " x (\(menu.menuCount))"
        cell.lblOrderValue.text = "??? \(menu.displayPrice)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func showNoRecordsView(_ tableView: UITableView) {
        let v1 = UIView(frame: tableView.frame)
        let noDataIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        noDataIV.contentMode = .scaleAspectFit
        noDataIV.center = self.viewBaseTax.center
        noDataIV.image = UIImage(named: "no-food")
        v1.addSubview(noDataIV)
        tableView.backgroundView  = v1
        self.btnPayOnline.isHidden = true
        self.viewBaseTax.isHidden = true
    }
    
    func refreshData() {
        
        if let u = self.user, u.customer_type == Constants.b2cHomeDelivery {
            if let _ = self.selectedPincode, let address = self.currentAddress {
                self.lblAddress.text = address.address
            }else if let address = self.currentAddress {
                self.lblAddress.text = address.address                
            }
        }else {
            if let org = self.selectedOrganization {
                self.lblAddress.text = org.address
            }
        }
        
        let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
        self.lblCartTotal.text = "??? \(String(format: "%.2f", val))"
        
        
        var offerdiscount = 0.0
        if let offer = self.selectedOffer {
            offerdiscount = offer.userDiscount.toDouble() ?? 0
            self.lblPromoDiscount.text = "- ??? \(offerdiscount)"
        }else {
            self.lblPromoDiscount.text = "- ??? 0.00"
        }
        
        let charge = self.charges.toDouble() ?? 0.0

        self.lblDelivery.text = "??? \(String(format: "%.2f", charge))"
        
        let total = (val + charge) - (offerdiscount)

        self.lblSubTotal.text = "??? \(String(format: "%.2f", total))"
        
        self.tblMenu.reloadData()
    }

    
}


extension CheckoutVC : LoginSuccessProtocol {
    
    func loginSuccess(profile: UserProfile) {
        print(profile)
        user = profile
//        self.callSaveOrderAPI(paymentId: paymentId)
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
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfDate {
            self.showDatePicker(textField)
        }
        if textField == self.tfGate {
            self.showGateDropDown(textField)
        }
        if textField == self.tfTimeslot {
            self.showTimeslotDropDown(textField)
        }
        return false
    }
    
    func showDatePicker(_ textField: UITextField) {
        day = Date().hour >= 22 ? 2 : 1
        DatePickerDialog().show(AlertMessages.ALERT_TITLE, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date().dateByAddingDays(day), minimumDate: Date().dateByAddingDays(day), maximumDate: nil, datePickerMode: UIDatePicker.Mode.date) { (date) in
            if let d = date {
                self.selectedDate = d
                textField.text = d.stringFromDate(Date.DateFormat.yyyyMMdd)
            }
        }
    }
    
    func showGateDropDown(_ textField: UITextField) {
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = textField // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = self.gates.map { $0.gate_name }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            let gate = self?.gates[index]
            self?.selectedGate = gate
            textField.text = gate?.gate_name
        }
        
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(textField.bounds.height))

        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        
        dropDown.show()
    }
    
    func showTimeslotDropDown(_ textField: UITextField) {
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = textField // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = self.timeslots.map { $0.timeslot_name }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.selectedTimeslot = self?.timeslots[index]
            let time = self?.timeslots[index]
            self?.selectedTimeslot = time
            textField.text = time?.timeslot_name
        }
        
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(textField.bounds.height))
        
        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        
        dropDown.show()
    }
}


// MARK: Razor Pay Payment
extension CheckoutVC : RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol {
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
        guard let user = Utilities.getCurrentUser() else {
            self.showAlert("Please login first!")
            return
        }
        var offerdiscount = 0.0
        if let offer = self.selectedOffer {
            offerdiscount = offer.userDiscount.toDouble() ?? 0
        }
        let charge = self.charges.toDouble() ?? 0.0
        let total = (val + charge) - (offerdiscount)

        let options: [String:Any] = [
            "amount": "\(total * 100)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "Coldman fresh order",
            //"order_id": "CFORDER\(UUID().uuidString)", // send when build is live only not for testing
            "image": "https://coldmanfresh.in/assets/images/logo/logo.jpg",
            "name": "Coldman fresh",
            "prefill": [
                "contact": "\(user.mobileno)",
                "email": "\(user.email)"
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
        
        guard ApiManager.checkuser_online() else {
            return
        }
                
        var offerdiscount = 0.0
        if let offer = self.selectedOffer {
            offerdiscount = offer.userDiscount.toDouble() ?? 0
        }
        
        let charge = self.charges.toDouble() ?? 0.0
        
        let total = (val + charge) - (offerdiscount)

        self.showActivityIndicator()
        
        var params = [String: Any]()
//        [{"restaurant_id":"3","menu_id":"7","menu_name":"snow_idli","menu_price":"100","qty":"2","cgst":"5","sgst":"5"}]
        var orderItemDetails = [[String: Any]]()
        
        for menu in self.addedMenus {
            var menuItem = [String: Any]()
            menuItem["menu_id"] = "\(menu.menu_id)"
            menuItem["menu_name"] = menu.menu_name
            menuItem["menu_price"] = "\(menu.price)"
            menuItem["qty"] = "\(menu.menuCount)"
            menuItem["variation_id"] = menu.variation.first.map { $0.variation_id }
            orderItemDetails.append(menuItem)
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: orderItemDetails, options: [.prettyPrinted])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        params["order"] = "\(jsonString!)"
        params["user_id"] = self.user.user_id
        params["total"] = total
        params["delivery_charges"] = charge
        params["transaction_id"] = paymentId
        params["coming_from"] = "3"
        params["discount_amount"] = offerdiscount
        params["coupon"] = self.selectedOffer == nil ? "" : self.selectedOffer.discount_coupon
        if self.selectedDate != nil {
            params["date"] = tfDate.text
        }else {
            params["date"] = ""
        }
        if self.selectedGate != nil {
            params["gate"] = self.selectedGate.gate_id
        }else {
            params["gate"] = ""
        }
        if self.selectedTimeslot != nil {
            params["timeslot"] = self.selectedTimeslot.timeslot_name
        }else {
            params["timeslot"] = ""
        }
        if self.user.customer_type == Constants.b2cHomeDelivery && self.currentAddress != nil {
            params["delivery_address"] = self.currentAddress.address
        }else if self.user.customer_type == Constants.b2cCorporate {
            params["delivery_address"] = self.selectedOrganization.address
        }

        print(params)
        
        ApiManager.saveOrderApi(params: params) { (json) in
            self.hideActivityIndicator()
            
            if let dict = json?.dictionary {
                if let status = dict["status"]?.number, status == 200, let orderId = dict["order_id"]?.number {
                    print(orderId)
                    self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "Order placed successfully!\n Order ID : \(orderId)", buttons: ["OK"]) { (i) in
                        Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
                        NotificationCenter.default.post(Notification(name: NSNotification.Name.init("orderSuccess")))
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }else {
                    self.showError(message: dict["message"]?.string ?? "Order placing failed, please try again")
                }
            }else {
                self.showError(message: "Order placing failed, please try again")
            }
        }
        
    }

    
}

extension CheckoutVC {
    
    func getGateList() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getGateList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                self.gates = Gate.getData(array: array)
                self.getTimeslotList()
            }else {
                self.getTimeslotList()
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

    func getTimeslotList() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getTimeslotList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                self.timeslots = Timeslot.getData(array: array)
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

}

extension Formatter {
    // create static date formatters for your date representations
    static let preciseLocalTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    static let preciseGMTTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}

extension Date {
    // you can create a read-only computed property to return just the nanoseconds from your date time
    var hour: Int { return Calendar.current.component(.hour,  from: self)   }
    // the same for your local time
    var preciseLocalTime: String {
        return Formatter.preciseLocalTime.string(for: self) ?? ""
    }
    // or GMT time
    var preciseGMTTime: String {
        return Formatter.preciseGMTTime.string(for: self) ?? ""
    }
}

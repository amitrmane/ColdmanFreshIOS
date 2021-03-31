//
//  SignUpVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit
import DropDown

class SignUpVC: SuperViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfBirthDate: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var tfPromoCode: UITextField!
    @IBOutlet weak var btnCorporate: UIButton!
    @IBOutlet weak var btnHomeDelivery: UIButton!

    var delegate : LoginSuccessProtocol!
    var mobileNo = ""
    var user : UserProfile!
    var organizations = [Organization]()
    var selectedOrganization : Organization!
    var selectedDate : Date!
    var pincodes = [Pincode]()
    var selectedPincode : Pincode!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if mobileNo != "" {
            self.tfMobile.text = mobileNo
            self.tfMobile.isUserInteractionEnabled = false
        }
        self.getOrganizationList()
        if let u = self.user {
            self.lblTitle.text = "Edit Profile"
            self.tfName.text = u.fname + " " + u.lname
            self.tfMobile.text = u.mobileno
            self.tfEmail.text = u.email
            self.tfBirthDate.text = u.birthdate
            if let date = Date().dateFromString(Date.DateFormat.yyyyMMdd.rawValue, dateString: u.birthdate) {
                self.selectedDate = date
            }else if let date = Date().dateFromString(Date.DateFormat.ddMMyyyy.rawValue, dateString: u.birthdate) {
                self.selectedDate = date
            }
            if u.customer_type == "2" {
                self.btnCorporate.isSelected = false
                self.btnHomeDelivery.isSelected = true
                if let pin = self.pincodes.filter({ $0.pincode == u.pincode }).first {
                    self.tfPromoCode.text = pin.pincode
                    self.selectedPincode = pin
                }else if let pin = self.pincodes.filter({ $0.pincodeId == u.organization_id }).first {
                    self.tfPromoCode.text = pin.pincode
                    self.selectedPincode = pin
                }else if let pin = self.pincodes.first {
                    self.selectedPincode = pin
                    self.tfPromoCode.text = pin.pincode
                }
            }else {
                self.btnCorporate.isSelected = true
                self.btnHomeDelivery.isSelected = false
                if let org = self.organizations.filter({ $0.organization_id == u.organization_id }).first {
                    self.tfPromoCode.text = org.organization_name
                    self.selectedOrganization = org
                }else if let org = self.organizations.first {
                    self.selectedOrganization = org
                    self.tfPromoCode.text = org.organization_name
                }
            }
            self.btnLogin.setTitle("Back to settings", for: .normal)
            self.btnSignUp.setTitle("Save", for: .normal)
        }else {
            self.btnCorporate.isSelected = true
            self.btnHomeDelivery.isSelected = false
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            
        })

    }
    
    @IBAction func corporateTapped(_ sender: UIButton) {
        updateRadioButtonSelection()
    }
    
    @IBAction func homeDeliveryTapped(_ sender: UIButton) {
        updateRadioButtonSelection()
    }
    
    func updateRadioButtonSelection() {
        self.btnCorporate.isSelected = !btnCorporate.isSelected
        self.btnHomeDelivery.isSelected = !btnHomeDelivery.isSelected
        
        if btnCorporate.isSelected {
            if let org = self.organizations.first {
                self.selectedOrganization = org
                self.tfPromoCode.text = org.organization_name
            }
        }else {
            if let pin = self.pincodes.first {
                self.selectedPincode = pin
                self.tfPromoCode.text = pin.pincode
            }
        }
    }
    
    @IBAction func termsTapped(_ sender: UIButton) {
        if let link = Constants.WebLinks.terms_and_conditions.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: link) {
            openWeb(contentLink: url, pageName: "Terms & Conditions")
        }
    }
    
    @IBAction func privacyTapped(_ sender: UIButton) {
        if let link = Constants.WebLinks.privacy_policy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: link) {
            openWeb(contentLink: url, pageName: "Privacy Policy")
        }
    }

    @IBAction func signUpTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard let name = self.tfName.text, name != "" else {
            self.showAlert("Enter name")
            return
        }

        guard let email = self.tfEmail.text, email.isValidEmail() else {
            self.showAlert("Enter valid email")
            return
        }

        guard let mob = self.tfMobile.text, mob != "", mob.isPhoneNumber else {
            self.showAlert("Enter valid mobile")
            return
        }


        
        
        if let u = self.user {
            // update user
            var params = [String: Any]()
            var fname = ""
            var lname = ""
            let separr = name.components(separatedBy: " ")
            if let first = separr.first {
                fname = first
                lname = separr.filter { $0 != first }.joined(separator: " ")
            }
            
            params["email"] = email
            params["user_id"] = "\(u.id)"
            params["fname"] = fname
            params["lname"] = lname
            params["birthdate"] = self.selectedDate == nil ? "" : self.selectedDate.stringFromDate(.ddMMyyyydash)
            params["mobileno"] = mob
            params["customer_type"] = self.btnCorporate.isSelected ? "1" : "2"
            params["organization_id"] = self.btnCorporate.isSelected ? self.selectedOrganization.organization_id : self.selectedPincode.pincodeId
            params["pincode"] = self.btnCorporate.isSelected ? "" : self.selectedPincode.pincode

            self.showActivityIndicator()
            
            ApiManager.updateProfile(params: params, imageData: nil, fileName: "", mimeType: "") { (json) in
                self.hideActivityIndicator()
                if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                    if let userdict = dict["userdetails"]?.dictionary, let user = UserProfile.getUserDetails(dict: userdict) {
                        let defaults = UserDefaults.standard
                        
                        // Use PropertyListEncoder to convert Player into Data / NSData
                        do {
                            if self.btnCorporate.isSelected, let org = self.selectedOrganization {
                                defaults.set(try PropertyListEncoder().encode(org), forKey: "UserTypeDetails")
                            }else if !self.btnCorporate.isSelected, let pin = self.selectedPincode {
                                defaults.set(try PropertyListEncoder().encode(pin), forKey: "UserTypeDetails")
                            }
                        }catch {
                            print(error.localizedDescription)
                        }

                        defaults.synchronize()
                        self.delegate.loginSuccess(profile: user)
                        self.dismiss(animated: true, completion: {
                            
                        })
                        
                    }else {
                        let user = UserProfile()
                        user.fname = fname
                        user.lname = lname
                        user.mobileno = mob
                        user.email = email
                        user.birthdate = self.tfBirthDate.text ?? ""
                        user.organization_id = self.btnCorporate.isSelected ? self.selectedOrganization.organization_id : self.selectedPincode.pincodeId
                        user.customer_type = self.btnCorporate.isSelected ? "1" : "2"
                        user.id = u.id
                        user.user_id = u.user_id
                        let defaults = UserDefaults.standard
                        
                        // Use PropertyListEncoder to convert Player into Data / NSData
                        do {
                            defaults.set(try PropertyListEncoder().encode(user), forKey: "User")
                            if self.btnCorporate.isSelected, let org = self.selectedOrganization {
                                defaults.set(try PropertyListEncoder().encode(org), forKey: "UserTypeDetails")
                            }else if !self.btnCorporate.isSelected, let pin = self.selectedPincode {
                                defaults.set(try PropertyListEncoder().encode(pin), forKey: "UserTypeDetails")
                            }
                        }catch {
                            print(error.localizedDescription)
                        }
                        defaults.synchronize()
                        self.delegate.loginSuccess(profile: user)
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                    self.showAlert(message)
                }
            }
        }else {
            
            var params = [String: Any]()
            var fname = ""
            var lname = ""
            let separr = name.components(separatedBy: " ")
            if let first = separr.first {
                fname = first
                lname = separr.filter { $0 != first }.joined(separator: " ")
            }
            
            params["email"] = email
            params["password"] = "12345"
            params["fname"] = fname
            params["lname"] = lname
            params["birthdate"] = self.selectedDate == nil ? "" : self.selectedDate.stringFromDate(.ddMMyyyydash)
            params["mobileno"] = mob
            params["customer_type"] = self.btnCorporate.isSelected ? "1" : "2"
            params["organization_id"] = self.btnCorporate.isSelected ? self.selectedOrganization.organization_id : self.selectedPincode.pincodeId
            params["pincode"] = self.btnCorporate.isSelected ? "" : self.selectedPincode.pincode

            self.showActivityIndicator()
            
            ApiManager.signUp(params: params) { (json) in
                self.hideActivityIndicator()
                if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                    self.showActivityIndicator()
                    
                    ApiManager.verifyOTP(mobNo: mob) { (json) in
                        self.hideActivityIndicator()
                        if let dict = json?.dictionary {
                            if let userdict = dict["userdetails"]?.dictionary, let user = UserProfile.getUserDetails(dict: userdict) {
                                let defaults = UserDefaults.standard
                                
                                // Use PropertyListEncoder to convert Player into Data / NSData
                                do {
                                    if self.btnCorporate.isSelected, let org = self.selectedOrganization {
                                        defaults.set(try PropertyListEncoder().encode(org), forKey: "UserTypeDetails")
                                    }else if !self.btnCorporate.isSelected, let pin = self.selectedPincode {
                                        defaults.set(try PropertyListEncoder().encode(pin), forKey: "UserTypeDetails")
                                    }
                                }catch {
                                    print(error.localizedDescription)
                                }

                                defaults.synchronize()
                                self.delegate.loginSuccess(profile: user)
                                self.dismiss(animated: true, completion: {
                                    
                                })
                                
                            }else {
                                let user = UserProfile()
                                user.fname = fname
                                user.lname = lname
                                user.mobileno = mob
                                user.email = email
                                user.birthdate = self.tfBirthDate.text ?? ""
                                user.organization_id = self.btnCorporate.isSelected ? self.selectedOrganization.organization_id : self.selectedPincode.pincodeId
                                user.customer_type = self.btnCorporate.isSelected ? "1" : "2"
                                let defaults = UserDefaults.standard
                                
                                // Use PropertyListEncoder to convert Player into Data / NSData
                                do {
                                    defaults.set(try PropertyListEncoder().encode(user), forKey: "User")
                                    if self.btnCorporate.isSelected, let org = self.selectedOrganization {
                                        defaults.set(try PropertyListEncoder().encode(org), forKey: "UserTypeDetails")
                                    }else if !self.btnCorporate.isSelected, let pin = self.selectedPincode {
                                        defaults.set(try PropertyListEncoder().encode(pin), forKey: "UserTypeDetails")
                                    }
                                }catch {
                                    print(error.localizedDescription)
                                }
                                defaults.synchronize()
                                self.delegate.loginSuccess(profile: user)
                                self.dismiss(animated: true, completion: {
                                    
                                })
                            }
                        }else {
                            self.showError(message: "User registration failed, please try again.")
                        }
                    }
                }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                    self.showAlert(message)
                }else {
                    self.showError(message: "User registration failed, please try again.")
                }
            }
            
        }
    }
    
    
    func openWeb(contentLink : URL, pageName: String) {
        let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        addressvc.webUrl = contentLink
        addressvc.pageTitle = pageName
        addressvc.isFromSignUp = true
        self.present(addressvc, animated: true, completion: nil)
    }
    
    func showOrganizationDropDown(_ textField: UITextField) {
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = textField // UIView or UIBarButtonItem

        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(textField.bounds.height))

        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        
        if self.btnCorporate.isSelected {
            // The list of items to display. Can be changed dynamically
            dropDown.dataSource = self.organizations.map { $0.organization_name }
            
            // Action triggered on selection
            dropDown.selectionAction = { [weak self] (index, item) in
                let org = self?.organizations[index]
                self?.selectedOrganization = org
                textField.text = org?.organization_name
            }
        }else {
            // The list of items to display. Can be changed dynamically
            dropDown.dataSource = self.pincodes.map { $0.pincode }
            
            // Action triggered on selection
            dropDown.selectionAction = { [weak self] (index, item) in
                let org = self?.pincodes[index]
                self?.selectedPincode = org
                textField.text = org?.pincode
            }

        }

        dropDown.show()
    }

    func showDatePicker(_ textField: UITextField) {
        
        DatePickerDialog().show(AlertMessages.ALERT_TITLE, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.selectedDate ?? Date(), minimumDate: nil, maximumDate: Date(), datePickerMode: UIDatePicker.Mode.date) { (date) in
            if let d = date {
                self.selectedDate = d
                textField.text = d.stringFromDate(Date.DateFormat.yyyyMMdd)
            }
        }
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfBirthDate {
            self.showDatePicker(textField)
            return false
        }
        if textField == self.tfPromoCode {
            self.showOrganizationDropDown(textField)
            return false
        }
        return true
    }

}

extension SignUpVC {
    
    func getOrganizationList() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getOrganizationList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                self.organizations = Organization.getData(array: array)
                if let u = self.user, u.customer_type == "1", let org = self.organizations.filter({ $0.organization_id == u.organization_id }).first {
                    self.selectedOrganization = org
                    self.tfPromoCode.text = org.organization_name
                }else if let org = self.organizations.first {
                    self.selectedOrganization = org
                    self.tfPromoCode.text = org.organization_name
                }
                self.getPincodeList()
            }else {
                self.showError(message: "Failed, please try again")
            }
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
                if let u = self.user,  u.customer_type == "2", let pin = self.pincodes.filter({ $0.pincode == u.pincode }).first {
                    self.selectedPincode = pin
                    self.tfPromoCode.text = pin.pincode
                }else if let u = self.user,  u.customer_type == "2", let pin = self.pincodes.filter({ $0.pincodeId == u.organization_id }).first {
                    self.tfPromoCode.text = pin.pincode
                    self.selectedPincode = pin
                }
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

}

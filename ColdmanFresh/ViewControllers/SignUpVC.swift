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

    var delegate : LoginSuccessProtocol!
    var mobileNo = ""
    var user : UserProfile!
    var organizations = [Organization]()
    var selectedOrganization : Organization!
    var selectedDate : Date!

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
            if let org = self.organizations.filter({ $0.organization_id == u.organization_id }).first {
                self.tfPromoCode.text = org.organization_name
            }
            self.btnLogin.setTitle("Back to settings", for: .normal)
            self.btnSignUp.setTitle("Save", for: .normal)
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            
        })

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
        guard let org = self.selectedOrganization else {
            self.showAlert("Select promo code")
            return
        }
        
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
            params["birthdate"] = self.tfBirthDate.text
            params["mobileno"] = mob
            params["organization_id"] = org.organization_id

            self.showActivityIndicator()
            
            ApiManager.updateProfile(params: params, imageData: nil, fileName: "", mimeType: "") { (json) in
                self.hideActivityIndicator()
                if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                    let user = UserProfile()
                    user.fname = fname
                    user.lname = lname
                    user.mobileno = mob
                    user.email = email
                    user.birthdate = self.tfBirthDate.text ?? ""
                    user.organization_id = org.organization_id
                    user.id = u.id
                    user.user_id = u.user_id
                    let defaults = UserDefaults.standard
                    
                    // Use PropertyListEncoder to convert Player into Data / NSData
                    do {
                        defaults.set(try PropertyListEncoder().encode(user), forKey: "User")
                    }catch {
                        print(error.localizedDescription)
                    }
                    self.delegate.loginSuccess(profile: user)
                    self.dismiss(animated: true, completion: {
                        
                    })
                }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                    self.showAlert(message)
                }
            }
        }else {
            
            var params = [String: Any]()
//            params["email"] = email
//            params["password"] = "12345"
//            params["name"] = name
//            params["role"] = "User"
//            params["mobileNumber"] = mob
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
            params["birthdate"] = self.tfBirthDate.text
            params["mobileno"] = mob
            params["organization_id"] = org.organization_id
            
            self.showActivityIndicator()
            
            ApiManager.signUp(params: params) { (json) in
                self.hideActivityIndicator()
                if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                    self.showActivityIndicator()
                    
                    ApiManager.verifyOTP(mobNo: mob) { (json) in
                        self.hideActivityIndicator()
                        if let dict = json?.dictionary {
                            if let user = UserProfile.getUserDetails(dict: dict) {
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
                                user.organization_id = org.organization_id
                                let defaults = UserDefaults.standard
                                
                                // Use PropertyListEncoder to convert Player into Data / NSData
                                do {
                                    defaults.set(try PropertyListEncoder().encode(user), forKey: "User")
                                }catch {
                                    print(error.localizedDescription)
                                }
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

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = self.organizations.map { $0.organization_name }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            let org = self?.organizations[index]
            self?.selectedOrganization = org
            textField.text = org?.organization_name
        }
        
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(textField.bounds.height))

        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        
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
                if let u = self.user, let org = self.organizations.filter({ $0.organization_id == u.organization_id }).first {
                    self.selectedOrganization = org
                    self.tfPromoCode.text = org.organization_name
                }
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

}

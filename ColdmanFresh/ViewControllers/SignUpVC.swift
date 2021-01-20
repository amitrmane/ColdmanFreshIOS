//
//  SignUpVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit

class SignUpVC: SuperViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var ivLogo: UIImageView!

    var delegate : LoginSuccessProtocol!
    var mobileNo = ""
    var user : UserProfile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tfMobile.text = mobileNo
        self.tfMobile.isUserInteractionEnabled = false
        if let u = self.user {
            self.lblTitle.text = "Edit Profile"
            self.tfName.text = u.fname + " " + u.lname
            self.tfMobile.text = u.mobileno
            self.tfEmail.text = u.email
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

//        guard let pwd = self.tfPassword.text, pwd != "" else {
//            self.showAlert("Enter password")
//            return
//        }
        
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
            params["birthdate"] = ""
            params["mobileno"] = mob
            
            self.showActivityIndicator()
            
            /*ApiManager.updateProfile(params: params, imageData: nil, fileName: "", mimeType: "") { (json, success, error) in
                self.hideActivityIndicator()
                if success {
                    if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                        let user = UserProfile()
                        user.fname = fname
                        user.lname = lname
                        user.mobile = mob
                        user.email = email
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
                }else {
                    self.showAlert(error.rawValue)
                }
            }*/
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
            params["birthdate"] = ""
            params["mobileno"] = mob
            params["organization_id"] = ""
            
            self.showActivityIndicator()
            
            ApiManager.signUp(params: params) { (json) in
                self.hideActivityIndicator()
//                if success {
                    if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                        self.showActivityIndicator()
                        
                        ApiManager.verifyOTP(mobNo: mob) { (json) in
                            self.hideActivityIndicator()
//                            if success {
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
//                            }else {
//                                self.showError(message: "User registration failed, please try again.")
//                            }
                        }
                    }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                        self.showAlert(message)
                    }
//                }else {
//                    self.showAlert(error.rawValue)
//                }
            }
            
            /*ApiManager.signUp(param: params) { (json, success, error) in
                self.hideActivityIndicator()
                if success {
                    if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                        if let userdict = dict["result"]?.dictionary, let user = UserProfile.getUserDetails(dict: userdict) {
                            self.delegate.loginSuccess(profile: user)
                            self.dismiss(animated: true, completion: {
                                
                            })
                        }
                    }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                        self.showAlert(message)
                    }
                }else {
                    self.showAlert(error.rawValue)
                }
            }*/
        }
    }
    
    
    func openWeb(contentLink : URL, pageName: String) {
        let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        addressvc.webUrl = contentLink
        addressvc.pageTitle = pageName
        self.navigationController?.pushViewController(addressvc, animated: true)
    }

}

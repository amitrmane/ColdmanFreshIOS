//
//  PhoneVerificationVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit

class PhoneVerificationVC: SuperViewController {
    
    @IBOutlet weak var lblInfo : UILabel!
    @IBOutlet weak var tfPhoneNumber : CustomTextField!
    @IBOutlet weak var btnSendCode : CustomButton!
    
    @IBOutlet weak var newRegistration: CustomButton!
    var addedMenus = [Menu]()
//    var allTaxes = [Tax]()
    var isFromSettings = false
    var isCartTap = false
    var params = [String: Any]()
    var mobileNumberString : String = ""
    
//    var selectedAddr : Address!
//    var selectedOffer : Offers!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfPhoneNumber.text = mobileNumberString
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        let signupvc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        signupvc.delegate = self
        self.navigationController?.pushViewController(signupvc, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let no = self.tfPhoneNumber.text, no.isPhoneNumber else {
            self.showError(message: "Please enter valid mobile number")
            return
        }
        callLoginAPI(no)
    }

    
    func callLoginAPI(_ no: String) {
        guard ApiManager.checkuser_online() else {
            self.showError(message: "Please check your internet connection")
            return
        }
        
        self.showActivityIndicator()
        
        var param = [String: Any]()
        param["mobileno"] = no
        
        ApiManager.sendOTP(params: param) { [self] (json) in
            self.hideActivityIndicator()
//            if success {
                if let dict = json?.dictionary, let otp = dict["otp"]?.number {
                    print(dict)
                    let verifyvc = mainStoryboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                    verifyvc.mobileNo = no
                    verifyvc.isCartTap = isCartTap
                    verifyvc.otp = otp.stringValue
//                    verifyvc.restaurent = self.restaurent
//                    verifyvc.allTaxes = self.allTaxes
                    verifyvc.addedMenus = self.addedMenus
                    verifyvc.isFromSettings = self.isFromSettings
//                    verifyvc.selectedOffer = self.selectedOffer
                    self.navigationController?.pushViewController(verifyvc, animated: true)
                }else {
                    self.showError(message: "Could not send OTP, please try again")
                }
//            }else {
//                //self.showError(message: error.rawValue)
//            }
        }
    }

    func openWeb(contentLink : URL, pageName: String) {
        let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        addressvc.webUrl = contentLink
        addressvc.pageTitle = pageName
        self.navigationController?.pushViewController(addressvc, animated: true)
    }
    
}

extension PhoneVerificationVC : LoginSuccessProtocol {
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        return range.location <= 10
    }
    
    func loginSuccess(profile: UserProfile) {
        if self.isFromSettings {
            if profile.user_id == "" && profile.id == 0 {
                print(profile.mobileno)
                self.verifyUserByNumber(mobNo: profile.mobileno)
            }else {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }else {
            if profile.user_id == "" && profile.id == 0 {
                print(profile.mobileno)
                self.verifyUserByNumber(mobNo: profile.mobileno)
            }else {
                let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                cartvc.addedMenus = self.addedMenus
                cartvc.user = profile
                self.navigationController?.pushViewController(cartvc, animated: true)
            }
        }
    }
    
    func verifyUserByNumber(mobNo: String) {
        guard ApiManager.checkuser_online() else {
            self.showError(message: "Please check your internet connection")
            return
        }
        
        self.showActivityIndicator()
        
        ApiManager.verifyOTP(mobNo: mobNo) { (json) in
            self.hideActivityIndicator()
//            if success {
                if let dict = json?.dictionary {
                    if let userdict = dict["userdetails"]?.dictionary, let user = UserProfile.getUserDetails(dict: userdict) {
                        if self.isFromSettings {
                            self.navigationController?.popToRootViewController(animated: false)
                        }else {
                            print(user.id)
                            let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                            cartvc.addedMenus = self.addedMenus
//                            cartvc.backDelegate = self
                            cartvc.user = user
                            self.navigationController?.pushViewController(cartvc, animated: true)

                        }
                    }else {
                        self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "User not found, do you want to register with this mobile number?", buttons: ["No", "Yes"]) { (i) in
                            if i == 0 {
                                self.navigationController?.popToRootViewController(animated: false)
                            }else {
                                let signupvc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                                signupvc.delegate = self
                                self.navigationController?.pushViewController(signupvc, animated: true)
                            }
                        }
                    }
                }else {
                    self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "User not found, do you want to register with this mobile number?", buttons: ["No", "Yes"]) { (i) in
                        if i == 0 {
                            self.navigationController?.popToRootViewController(animated: false)
                        }else {
                            let signupvc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                            signupvc.delegate = self
                            self.navigationController?.pushViewController(signupvc, animated: true)
                        }
                    }
                }
        }
    }

}

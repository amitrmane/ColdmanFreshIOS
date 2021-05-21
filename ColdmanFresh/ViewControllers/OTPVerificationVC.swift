//
//  OTPVerificationVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit

class OTPVerificationVC: SuperViewController {

    @IBOutlet weak var lblInfo : UILabel!
    @IBOutlet weak var tfOTP : CustomTextField!
    @IBOutlet weak var btnVerify : CustomButton!
    @IBOutlet weak var btnResend : CustomButton!

    var addedMenus = [Menu]()
//    var allTaxes = [Tax]()
    var mobileNo = ""
    var otp = ""
    var isFromSettings = false
    var isFromSignUp = false
    var params = [String: Any]()

    var timer : Timer!
    var seconds = 0
//    var selectedAddr : Address!
//    var selectedOffer : Offers!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lblInfo.text = "A verification code is sent to your number \(mobileNo)"
        self.btnResend.setTitle("Resend OTP in 60 secs", for: .normal)
        self.btnResend.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.setTimer()
        }
    }
    
    func setTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    @objc func timerTick() {
        self.seconds += 1
        if self.seconds == 60 {
            self.btnResend.setTitle("Resend OTP", for: .normal)
            self.btnResend.isUserInteractionEnabled = true
            self.timer.invalidate()
        }else {
            self.btnResend.setTitle("Resend OTP in \(60 - self.seconds) secs", for: .normal)
            self.btnResend.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let enteredOtp = self.tfOTP.text else {
            self.showError(message: "Please enter valid otp")
            return
        }
        
        guard ApiManager.checkuser_online() else {
            self.showError(message: "Please check your internet connection")
            return
        }
        
        guard enteredOtp == self.otp else {
            self.showError(message: "Please enter valid otp")
            return
        }
        
        self.verifyUserByNumber()
        
    }

    @IBAction func resendTapped(_ sender: UIButton) {
        guard ApiManager.checkuser_online() else {
            self.showError(message: "Please check your internet connection")
            return
        }
        
        self.showActivityIndicator()
        
        var param = [String: Any]()
        param["mobileno"] = self.mobileNo
        
        ApiManager.sendOTP(params: param) { (json) in
            self.hideActivityIndicator()
//            if success {
                if let dict = json?.dictionary, let otp = dict["otp"]?.number {
                    print(dict)
                    self.otp = otp.stringValue
                    self.showToast(message: "OTP sent successfully.")
                    self.seconds = 1
                    self.setTimer()
                }else {
                    self.showError(message: "Could not send OTP, please try again")
                }
//            }else {
//                //self.showError(message: error.rawValue)
//            }
        }

    }
    
    func verifyUserByNumber() {
        guard ApiManager.checkuser_online() else {
            self.showError(message: "Please check your internet connection")
            return
        }
        
        self.showActivityIndicator()
        ApiManager.verifyOTP(mobNo: self.mobileNo) { (json) in
//            if success {
                if let dict = json?.dictionary {
                    if let userdict = dict["userdetails"]?.dictionary, let user = UserProfile.getUserDetails(dict: userdict) {
                        if user.customer_type == Constants.b2cCorporate {
                            self.getOrganizationList(user: user) { (s) in
                                if s {
                                    if self.isFromSettings {
                                        self.hideActivityIndicator()
                                        self.navigationController?.popToRootViewController(animated: false)
                                    }else if self.isFromSignUp {
                                        print(user.id)
                                        ApiManager.signUp(params: self.params) { (json) in
                                                        self.hideActivityIndicator()
                                                        if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                                                            self.navigationController?.popToRootViewController(animated: false)
                                    }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                                        self.hideActivityIndicator()
                                                            self.showAlert(message)
                                                        }else {
                                                            self.hideActivityIndicator()
                                                            self.showError(message: "User registration failed, please try again.")
                                                        }
                                }
                                    }else {
                                        self.hideActivityIndicator()
                                        print(user.id)
                                        let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                                        cartvc.addedMenus = self.addedMenus
                                        cartvc.user = user
                                        self.navigationController?.pushViewController(cartvc, animated: true)
                                    }
                                }
                            }
                        }else if user.customer_type == Constants.b2cHomeDelivery {
                            self.hideActivityIndicator()
                            self.getPincodeList(user: user) { (s) in
                                if s {
                                    if self.isFromSettings {
                                        self.navigationController?.popToRootViewController(animated: false)
                                    }else if self.isFromSignUp {
                                        print(user.id)
                                        ApiManager.signUp(params: self.params) { (json) in
                                                        self.hideActivityIndicator()
                                                        if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                                                            self.navigationController?.popToRootViewController(animated: false)
                                    }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                                        self.hideActivityIndicator()
                                                            self.showAlert(message)
                                                        }else {
                                                            self.hideActivityIndicator()
                                                            self.showError(message: "User registration failed, please try again.")
                                                        }
                                }
                                    }else {
                                        self.hideActivityIndicator()
                                        print(user.id)
                                        let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                                        cartvc.addedMenus = self.addedMenus
                                        cartvc.user = user
                                        self.navigationController?.pushViewController(cartvc, animated: true)
                                    }
                                }
                            }
                        }else {
                            self.hideActivityIndicator()
                            if self.isFromSettings {
                                self.navigationController?.popToRootViewController(animated: false)
                            }else if self.isFromSignUp {
                                print(user.id)
                                ApiManager.signUp(params: self.params) { (json) in
                                                self.hideActivityIndicator()
                                                if let dict = json?.dictionary, let status = dict["status"]?.number, status == 200 {
                                                    self.navigationController?.popToRootViewController(animated: false)
                            }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                                self.hideActivityIndicator()
                                                    self.showAlert(message)
                                                }else {
                                                    self.hideActivityIndicator()
                                                    self.showError(message: "User registration failed, please try again.")
                                                }
                        }
                            }else {
                                self.hideActivityIndicator()
                                print(user.id)
                                let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                                cartvc.addedMenus = self.addedMenus
                                cartvc.user = user
                                self.navigationController?.pushViewController(cartvc, animated: true)
                            }
                        }
                    }else {
                        self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "User not found, do you want to register with this mobile number?", buttons: ["No", "Yes"]) { (i) in
                            if i == 0 {
                                self.navigationController?.popViewController(animated: true)
                            }else {
                                let signupvc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                                signupvc.delegate = self
                                signupvc.mobileNo = self.mobileNo
                                self.present(signupvc, animated: true, completion: nil)
                            }
                        }
                    }
                }else {
                    self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "User not found, do you want to register with this mobile number?", buttons: ["No", "Yes"]) { (i) in
                        if i == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }else {
                            let signupvc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                            signupvc.delegate = self
                            signupvc.mobileNo = self.mobileNo
                            self.present(signupvc, animated: true, completion: nil)
                        }
                    }
                }
//            }else {
//                self.showError(message: error.rawValue)
//            }
        }
    }
    
    func getOrganizationList(user: UserProfile, callback: @escaping ((_ result: Bool) -> Void)) {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getOrganizationList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                let organizations = Organization.getData(array: array)
                let defaults = UserDefaults.standard
                if let org = organizations.filter({ $0.organization_id == user.organization_id }).first {
                    do {
                        defaults.set(try PropertyListEncoder().encode(org), forKey: "UserTypeDetails")
                    }catch {
                        print(error.localizedDescription)
                    }
                }else if let org = organizations.first {
                    do {
                        defaults.set(try PropertyListEncoder().encode(org), forKey: "UserTypeDetails")
                    }catch {
                        print(error.localizedDescription)
                    }
                }
                defaults.synchronize()
                callback(true)
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

    func getPincodeList(user: UserProfile, callback: @escaping ((_ result: Bool) -> Void)) {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getPincodeList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                let pincodes = Pincode.getData(array: array).filter({ $0.status == "1" })
                let defaults = UserDefaults.standard
                if let pin = pincodes.filter({ $0.pincode == user.pincode }).first {
                    do {
                        defaults.set(try PropertyListEncoder().encode(pin), forKey: "UserTypeDetails")
                    }catch {
                        print(error.localizedDescription)
                    }
                }else if let pin = pincodes.filter({ $0.pincode == user.organization_id }).first {
                    do {
                        defaults.set(try PropertyListEncoder().encode(pin), forKey: "UserTypeDetails")
                    }catch {
                        print(error.localizedDescription)
                    }
                }
                defaults.synchronize()
                callback(true)
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

}

extension OTPVerificationVC : LoginSuccessProtocol {
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        return range.location <= 6
    }
    
    func loginSuccess(profile: UserProfile) {
        if self.isFromSettings {
            self.navigationController?.popToRootViewController(animated: false)
        }else {
            if profile.user_id == "" && profile.id == 0 {
                print(profile.mobileno)
                self.mobileNo = profile.mobileno
                self.verifyUserByNumber()
            }else {
                let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                cartvc.addedMenus = self.addedMenus
//                            cartvc.backDelegate = self
                cartvc.user = profile
                self.navigationController?.pushViewController(cartvc, animated: true)

//                let summaryvc = mainStoryboard.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
//                summaryvc.user = profile
//                summaryvc.restaurent = self.restaurent
//                summaryvc.allTaxes = self.allTaxes
//                summaryvc.addedMenus = self.addedMenus
//                summaryvc.selectedAddr = self.selectedAddr
//                summaryvc.selectedOffer = self.selectedOffer
//                self.navigationController?.pushViewController(summaryvc, animated: true)
            }
        }
    }
}

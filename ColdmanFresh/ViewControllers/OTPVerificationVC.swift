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
        /*guard ApiManager.checkuser_online() else {
            self.showError(message: "Please check your internet connection")
            return
        }
        
        self.showActivityIndicator()
        
        ApiManager.generateOTPFor(number: mobileNo) { (json, success, error) in
            self.hideActivityIndicator()
            if success {
                if let dict = json?.dictionary, let result = dict["success"]?.bool, result {
                    self.showToast(message: "OTP sent successfully.")
                    self.seconds = 1
                    self.setTimer()
                }else {
                    self.showError(message: "Could not send OTP, please try again")
                }
            }else {
                self.showError(message: error.rawValue)
            }
        }*/
    }
    
    func verifyUserByNumber() {
        guard ApiManager.checkuser_online() else {
            self.showError(message: "Please check your internet connection")
            return
        }
        
        self.showActivityIndicator()
        
        ApiManager.verifyOTP(mobNo: self.mobileNo) { (json) in
            self.hideActivityIndicator()
//            if success {
                if let dict = json?.dictionary {
                    if let userdict = dict["userdetails"]?.dictionary, let user = UserProfile.getUserDetails(dict: userdict) {
                        if self.isFromSettings {
                            self.navigationController?.popToRootViewController(animated: false)
                        }else {
                            print(user.id)
//                            let summaryvc = mainStoryboard.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
//                            summaryvc.user = user
//                            summaryvc.restaurent = self.restaurent
//                            summaryvc.allTaxes = self.allTaxes
//                            summaryvc.addedMenus = self.addedMenus
//                            summaryvc.selectedAddr = self.selectedAddr
//                            summaryvc.selectedOffer = self.selectedOffer
//                            self.navigationController?.pushViewController(summaryvc, animated: true)
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
    
}

extension OTPVerificationVC : LoginSuccessProtocol {
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        return range.location <= 6
    }
    
    func loginSuccess(profile: UserProfile) {
        if self.isFromSettings {
            self.navigationController?.popToRootViewController(animated: false)
        }else {
//            if profile.user_id == "" && profile.id == 0 {
//                print(profile.mobile)
//                self.mobileNo = profile.mobile
//                self.callLogin()
//            }else {
//                let summaryvc = mainStoryboard.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
//                summaryvc.user = profile
//                summaryvc.restaurent = self.restaurent
//                summaryvc.allTaxes = self.allTaxes
//                summaryvc.addedMenus = self.addedMenus
//                summaryvc.selectedAddr = self.selectedAddr
//                summaryvc.selectedOffer = self.selectedOffer
//                self.navigationController?.pushViewController(summaryvc, animated: true)
//            }
        }
    }
}

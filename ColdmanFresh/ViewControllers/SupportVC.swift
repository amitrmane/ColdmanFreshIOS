//
//  SupportVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit
import MessageUI

class SupportVC: SuperViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callTapped(_ sender: UIButton) {
        if let url = URL(string: "tel://+919881001119"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (s) in
                print(s)
            }
        }else if let url = URL(string: "telprompt://+919881001119"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (s) in
                print(s)
            }
        } else {
            // show failure alert
            self.showAlert("No call service found on device.")
        }
    }
    
    @IBAction func emailTapped(_ sender: UIButton) {
        sendEmail()
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@coldmanfresh.in"])
            mail.setMessageBody("Hello Team, ", isHTML: false)

            present(mail, animated: true)
        } else {
            // show failure alert
            self.showAlert("No email service found on device.")
        }
    }
}

extension SupportVC : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        print(error?.localizedDescription ?? "sent")
    }
}

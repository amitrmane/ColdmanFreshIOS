//
//  ContacUsViewController.swift
//  ColdmanFresh
//
//  Created by Amit R Mane on 4/23/21.
//

import Foundation

import UIKit
import MessageUI

class ContacUsViewController: UIViewController , MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var yourMessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        yourMessage.layer.borderColor = UIColor.gray.cgColor
        yourMessage.layer.borderWidth = 1
        yourMessage.layer.cornerRadius = 11
}
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith didFinishWithResult:MFMailComposeResult, error:Error?) {
          switch didFinishWithResult {
          case .cancelled:
              break
          case .saved:
              break
          case .sent:
              break
          case .failed:
              break
          @unknown default: break
          }
        controller.dismiss(animated: true, completion: nil)
      }

    @IBAction func sendFunctionClick(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let message:String  = yourMessage.text
            let mainMessage  = "\(nameTextField.text ?? "") \(message)"
        let composePicker = MFMailComposeViewController()
            composePicker.mailComposeDelegate = self
            composePicker.delegate = self
            composePicker.setToRecipients(["support@coldmanfresh.in"])
            composePicker.setSubject(subjectTextField.text ?? "")
            composePicker.setMessageBody(mainMessage, isHTML: false)
            self.present(composePicker, animated: true, completion: nil)
        }else {
                self .showerrorMessage()
        }
    }
      
    func showerrorMessage() {
        let alertMessage = UIAlertController(title: "could not sent email", message: "check if your device have email support!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertAction.Style.default, handler: nil)
            alertMessage.addAction(action)
         self.present(alertMessage, animated: true, completion: nil)
    }
}

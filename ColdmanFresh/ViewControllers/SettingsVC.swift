//
//  ProfileVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//

import UIKit
import SafariServices

class SettingsVC: SuperViewController {

    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnLogin: CustomButton!

    var settingsArray = ["Manage Addresses", "Terms & Conditions", "Privacy Policy", "Cancellation & Refund Policy", "FAQs", "Help & Support"]
    var profile : UserProfile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblSettings.tableFooterView = UIView(frame: CGRect.zero)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        guard let userData = defaults.object(forKey: "User") as? Data else {
            self.lblName.text = "Login to order food"
            self.lblMobile.text = "Mobile - NA"
            self.lblEmail.text = "Email - NA"
            self.btnLogin.setTitle("Login", for: UIControl.State.normal)
            self.settingsArray = ["Manage Addresses", "Terms & Conditions", "Privacy Policy", "Cancellation & Refund Policy", "FAQs", "Help & Support"]
            self.tblSettings.reloadData()
            return
        }
        
        // Use PropertyListDecoder to convert Data into User
        guard let user = try? PropertyListDecoder().decode(UserProfile.self, from: userData) else {
            self.lblName.text = "Login to order food"
            self.lblMobile.text = "Mobile - NA"
            self.lblEmail.text = "Email - NA"
            self.btnLogin.setTitle("Login", for: UIControl.State.normal)
            self.settingsArray = ["Manage Addresses", "Terms & Conditions", "Privacy Policy", "Cancellation & Refund Policy", "FAQs", "Help & Support"]
            self.tblSettings.reloadData()
            return
        }
        if user.id != 0 {
            self.profile = user
            if !self.settingsArray.contains("Logout") {
                self.settingsArray.append("Logout")
            }
            self.lblName.text = user.fname + " " + user.lname
            self.lblMobile.text = user.mobileno
            self.lblEmail.text = user.email
            self.btnLogin.setTitle("Edit", for: UIControl.State.normal)
        }else {
            self.lblName.text = "Login to order food"
            self.lblMobile.text = "Mobile - NA"
            self.lblEmail.text = "Email - NA"
            self.btnLogin.setTitle("Login", for: UIControl.State.normal)
        }
        self.tblSettings.reloadData()

    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if self.profile == nil {
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "PhoneVerificationVC") as! PhoneVerificationVC
            loginVC.isFromSettings = true
            self.navigationController?.pushViewController(loginVC, animated: true)
        }else {
            let signupvc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            signupvc.user = self.profile
            signupvc.delegate = self
            self.present(signupvc, animated: true, completion: nil)
        }
    }

}

extension SettingsVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let setting = settingsArray[indexPath.row]
        cell.lblTitle.text = setting
        cell.accessoryType = .disclosureIndicator
        switch setting {
        case "Manage Addresses":
            cell.ivMenu.image = UIImage(named: "address")
            break
        case "Terms & Conditions":
            cell.ivMenu.image = UIImage(named: "terms")
            break
        case "Privacy Policy":
            cell.ivMenu.image = UIImage(named: "terms")
            break
        case "Cancellation & Refund Policy":
            cell.ivMenu.image = UIImage(named: "terms")
            break
        case "FAQs":
            cell.ivMenu.image = UIImage(named: "faq")
            break
        case "Help & Support":
            cell.ivMenu.image = UIImage(named: "support")
            break
        case "Logout":
            cell.ivMenu.image = UIImage(named: "logout")
            cell.accessoryType = .none
            break
        default:
            cell.ivMenu.image = nil
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let setting = settingsArray[indexPath.row]
        switch setting {
        case "Manage Addresses":
            guard let user = self.profile else {
                self.showAlert("Please login first.")
                return
            }
            let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "AddressListViewController") as! AddressListViewController
            addressvc.user = user
            self.navigationController?.pushViewController(addressvc, animated: true)
            break
        case "Terms & Conditions":
            if let link = Constants.WebLinks.terms_and_conditions.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: link) {
                openWeb(contentLink: url, pageName: "Terms & Conditions")
            }
            break
        case "Privacy Policy":
            if let link = Constants.WebLinks.privacy_policy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: link) {
                openWeb(contentLink: url, pageName: "Privacy Policy")
            }
            break
        case "Cancellation & Refund Policy":
            if let link = Constants.WebLinks.cancellation_and_refund.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: link) {
                openWeb(contentLink: url, pageName: "Cancellation & Refund Policy")
            }
            break
        case "FAQs":
            if let link = Constants.WebLinks.faqs.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: link) {
                openWeb(contentLink: url, pageName: "FAQs")
            }
            break
        case "Help & Support":
            let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
            self.navigationController?.pushViewController(addressvc, animated: true)
            break
        case "Logout":
            Utilities.removeValueForKeyFromDefaults("User")
            self.profile = nil
            self.viewDidAppear(true)
            break
        default:
            break
        }
    }
    
    func openWeb(contentLink : URL, pageName: String) {
        let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        addressvc.webUrl = contentLink
        addressvc.pageTitle = pageName
        self.navigationController?.pushViewController(addressvc, animated: true)
    }

}


extension SettingsVC : LoginSuccessProtocol, SFSafariViewControllerDelegate {
    
    func loginSuccess(profile: UserProfile) {
        self.viewDidAppear(true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            
        }
    }
}


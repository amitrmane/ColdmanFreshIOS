//
//  AddAddressVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 27/01/21.
//  Copyright © 2021 Prasad Patil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import DropDown

class AddAddressVC: SuperViewController {

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var tfTitle: CustomTextField!
    @IBOutlet weak var tfAddress: CustomTextField!
    @IBOutlet weak var tfLandmark: CustomTextField!
    @IBOutlet weak var tfFlatno: CustomTextField!
    @IBOutlet weak var tfFirstName: CustomTextField!
    @IBOutlet weak var tfLastName: CustomTextField!
    @IBOutlet weak var tfEmail: CustomTextField!
    @IBOutlet weak var tfMobNo: CustomTextField!
    @IBOutlet weak var tfPincode: CustomTextField!
    @IBOutlet weak var tfCity: CustomTextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSave: UIButton!

    var user : UserProfile!
    var currentLoc : CLLocation!
    var selectedAddress : Address!
    var pincodes = [Pincode]()
    var selectedPincode : Pincode!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let addr = self.selectedAddress {
            self.tfTitle.text = addr.title
            self.tfAddress.text = addr.address
            self.tfFirstName.text = addr.fname
            self.tfLastName.text = addr.lname
            self.tfMobNo.text = addr.mobileno
            self.tfEmail.text = addr.email
            self.tfLandmark.text = addr.landmark
            self.tfFlatno.text = addr.door_flat_no
            self.tfPincode.text = addr.pincode
            self.tfCity.text = addr.city
        }
        self.getPincodeList()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let title = self.tfTitle.text, title.trimmed != "" else {
            self.showAlert("Enter title")
            return
        }
        
        guard let fname = self.tfFirstName.text, fname.trimmed != "" else {
            self.showAlert("Enter first name")
            return
        }
        
        guard let lname = self.tfLastName.text, lname.trimmed != "" else {
            self.showAlert("Enter last name")
            return
        }

        guard let email = self.tfEmail.text, email.isValidEmail() else {
            self.showAlert("Enter email")
            return
        }
        
        guard let mobno = self.tfMobNo.text, mobno.isPhoneNumber else {
            self.showAlert("Enter mobile number")
            return
        }
        
        guard let address = self.tfAddress.text, address.trimmed != "" else {
            self.showAlert("Enter address")
            return
        }

        guard let flatno = self.tfFlatno.text, flatno.trimmed != "" else {
            self.showAlert("Enter door/flat no")
            return
        }
        
        guard let landmark = self.tfLandmark.text, landmark.trimmed != "" else {
            self.showAlert("Enter landmark")
            return
        }

        guard let pin = self.tfPincode.text, pin.trimmed != "" else {
            self.showAlert("Enter pin code")
            return
        }

        guard let city = self.tfCity.text, city.trimmed != "" else {
            self.showAlert("Enter city")
            return
        }

        
        
//        let selectLoc = self.mapView.convert(self.mapView.center, toCoordinateFrom: self.mapView)
        
        var params = [String: Any]()
        params["address"] = address
        params["title"] = title
        params["latitude"] = ""
        params["longitude"] = ""
        params["user_id"] = self.user.user_id
        params["door_flat_no"] = flatno
        params["landmark"] = landmark
        params["fname"] = fname
        params["lname"] = lname
        params["mobileno"] = mobno
        params["email"] = email
        params["pincode"] = pin
        params["city"] = city

        if self.selectedAddress == nil {
            self.showActivityIndicator()
            
            ApiManager.addNewAddress(params: params) { (json) in
                self.hideActivityIndicator()
                if let dict = json?.dictionary, let status = dict["status"]?.number, (status == 200) {
                    self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "Address saved successfully", buttons: ["OK"]) { (i) in
                        if i == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                    self.showAlert(message)
                }
            }
        }else if let addr = self.selectedAddress {
            
            params["id"] = addr.id
            
            self.showActivityIndicator()
            
            ApiManager.updateAddress(params: params) { (json) in
                self.hideActivityIndicator()
                    if let dict = json?.dictionary, let status = dict["status"]?.number, (status == 200) {
                        self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "Address updated successfully", buttons: ["OK"]) { (i) in
                            if i == 0 {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                        self.showAlert(message)
                    }
            }

        }
    }
   
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfPincode {
            self.showPincodeDropDown(textField)
            return false
        }
        return true
    }

    func showPincodeDropDown(_ textField: UITextField) {
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = textField // UIView or UIBarButtonItem

        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(textField.bounds.height))

        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = self.pincodes.map { $0.pincode }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            let org = self?.pincodes[index]
            self?.selectedPincode = org
            textField.text = org?.pincode
        }
        
        dropDown.show()
    }

}

extension AddAddressVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        self.currentLoc = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension AddAddressVC {
    
    func getPincodeList() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getPincodeList() { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                self.pincodes = Pincode.getData(array: array).filter({ $0.status == "1" })
                if let addrs = self.selectedAddress,  let pin = self.pincodes.filter({ $0.pincode == addrs.pincode }).first {
                    self.selectedPincode = pin
                    self.tfPincode.text = pin.pincode
                }else if let u = self.user,  u.customer_type == "2", let pin = self.pincodes.filter({ $0.pincode == u.pincode }).first {
                    self.selectedPincode = pin
                    self.tfPincode.text = pin.pincode
                }else if let u = self.user,  u.customer_type == "2", let pin = self.pincodes.filter({ $0.pincodeId == u.organization_id }).first {
                    self.tfPincode.text = pin.pincode
                    self.selectedPincode = pin
                }
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }

}

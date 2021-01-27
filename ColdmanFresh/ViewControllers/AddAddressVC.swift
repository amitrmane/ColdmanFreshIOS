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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*Constants.locationManager.delegate = self
        if let noLocation = Constants.locationManager.location {
            let viewRegion = MKCoordinateRegion(center: noLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }else {
            Constants.locationManager.requestLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let noLocation = Constants.locationManager.location {
                    let viewRegion = MKCoordinateRegion(center: noLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
                    self.mapView.setRegion(viewRegion, animated: false)
                }else if let loc = self.currentLoc {
                    let viewRegion = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
                    self.mapView.setRegion(viewRegion, animated: false)
                }
            }
        }
        self.mapView.showsUserLocation = true*/
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

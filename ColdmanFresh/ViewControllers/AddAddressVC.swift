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

public typealias successClosure = (CLLocationCoordinate2D) -> Void
public typealias failureClosure = (NSError) -> Void

class AddAddressVC: SuperViewController{

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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var alternateMobileNumber: CustomTextField!
    
    var user : UserProfile!
    var currentLoc : CLLocation!
    var selectedAddress : Address!
    var pincodes = [Pincode]()
    var cities = [City]()
    var selectedPincode : Pincode!
    
    
    fileprivate var pointAnnotation: MKPointAnnotation!
    fileprivate var userTrackingButton: MKUserTrackingBarButtonItem!

    fileprivate let locationManager: CLLocationManager = CLLocationManager()

    fileprivate var success: successClosure?
    fileprivate var failure: failureClosure?

    fileprivate var isInitialized = false

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    convenience public init(success: @escaping successClosure, failure: failureClosure? = nil) {
        self.init()
        self.success = success
        self.failure = failure
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self

        success: do { }
//        self.mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(self.mapView)

        if let addr = self.selectedAddress {
            self.tfTitle.text = addr.title
            self.tfAddress.text = addr.address
            self.tfFirstName.text = addr.fname
            self.tfLastName.text = addr.lname
            self.tfMobNo.text = addr.mobileno
            self.alternateMobileNumber.text = addr.alternateMobileNumber
            self.tfEmail.text = addr.email
            self.tfLandmark.text = addr.landmark
            self.tfFlatno.text = addr.door_flat_no
            self.tfPincode.text = addr.pincode
            self.tfCity.text = addr.city
        }
        self.getPincodeList()
        
        self.userTrackingButton = MKUserTrackingBarButtonItem(mapView: self.mapView)
//        self.toolbarItems = [self.userTrackingButton, flexibleButton]
        self.navigationController?.isToolbarHidden = false

        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
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
        params["alternate_mobileno"] = self.alternateMobileNumber.text
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
        if textField == self.tfCity {
            self.showCityList(textField)
            return false
        }
        return true
    }
    
    
    func showCityList(_ textField: UITextField) {
        let dropDown = DropDown()
        dropDown.anchorView = textField // UIView or UIBarButtonItem

        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(textField.bounds.height))

        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = self.cities.map { $0.city_name }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            let org = self?.cities[index]
//            self?.selectedPincode = org
            textField.text = org?.city_name
        }
        
        dropDown.show()

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
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//            let lat: Double = Double("\(pdblLatitude)")!
//            //21.228124
//            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = pdblLatitude
            center.longitude = pdblLongitude

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                    
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }

                        self.tfAddress.text = addressString

                        print(addressString)
                  }
            })

        }
}

//extension AddAddressVC : CLLocationManagerDelegate {
//    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
//        self.currentLoc = locations.first
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//}

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
                }else if let u = self.user,  u.customer_type == Constants.b2cHomeDelivery, let pin = self.pincodes.filter({ $0.pincode == u.pincode }).first {
                    self.selectedPincode = pin
                    self.tfPincode.text = pin.pincode
                }else if let u = self.user,  u.customer_type == Constants.b2cHomeDelivery, let pin = self.pincodes.filter({ $0.pincode == u.organization_id }).first {
                    self.tfPincode.text = pin.pincode
                    self.selectedPincode = pin
                }
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
        self.showActivityIndicator()
        ApiManager.getUserCity(userid: user.user_id) { (json) in
            self.hideActivityIndicator()
            if let array = json?.array {
                self.cities = City.getData(array: array).filter({ $0.status == "1" })
                if let addrs = self.selectedAddress,  let city = self.cities.filter({ $0.city_name == addrs.pincode }).first {
                    self.tfCity.text = city.city_name
//                    self.selectedPincode = pin
//                    self.tfPincode.text = pin.pincode
                }else  {
//                    self.tfCity.text = city.city_name
//                    self.selectedPincode = pin
//                    self.tfPincode.text = pin.pincode
                }
            }else {
                self.showError(message: "Failed, please try again")
            }
    }
    }
}

// MARK: - Internal methods

internal extension AddAddressVC {

    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didTapDoneButton() {
        guard CLLocationCoordinate2DIsValid(self.mapView.centerCoordinate) else {
            self.failure?(NSError(domain: "LocationPickerControllerErrorDomain",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid coordinate"]))
            return
        }

        self.success?(self.mapView.centerCoordinate)

        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MKMapView delegate

extension AddAddressVC: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard self.isInitialized else {
            return
        }
        self.pointAnnotation.coordinate = mapView.region.center
        
        getAddressFromLatLon(pdblLatitude: self.pointAnnotation.coordinate.latitude, withLongitude: self.pointAnnotation.coordinate.longitude)
    }
}


// MARK: - CLLocationManager delegate

extension AddAddressVC: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, !self.isInitialized else {
            return
        }

        self.locationManager.stopUpdatingLocation()

        let centerCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)

        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.coordinate = newLocation.coordinate
        self.mapView.addAnnotation(self.pointAnnotation)

        self.isInitialized = true
    }
}

//
//  OffersVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 27/01/21.
//  Copyright © 2021 Prasad Patil. All rights reserved.
//

import UIKit
import CoreLocation

class OffersVC: SuperViewController {

    @IBOutlet weak var tblOffers: UITableView!
    
    var offers = [Offers]()
    var addedMenus = [Menu]()
//    var allTaxes = [Tax]()
    var user : UserProfile!
    var backDelegate : BackRefresh!
    var currentAddress : Address!
    var selectedOffer : Offers!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getOffers()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getOffers() {
        
        guard ApiManager.checkuser_online() else {
            self.showNoRecordsViewWithLabel(self.tblOffers, message: "No internet connection.")
            return
        }
        
        
        self.showActivityIndicator()
        
        ApiManager.getOffers() { (json) in
            self.hideActivityIndicator()
            
            if let dict = json?.dictionary,
               let array = dict["coupons"]?.array {
                self.offers = Offers.getAllOffers(array: array)
                self.tblOffers.reloadData()
            }else {
                self.showNoRecordsViewWithLabel(self.tblOffers, message: "No offers found.")
                self.tblOffers.reloadData()
            }
        }
        
    }

}


extension OffersVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let offer = self.offers[indexPath.row]
        
        if offer.discount_type == "percentage" {
            cell.lblOrderValue.text = "\(offer.discount_amount) % OFF"
        }else if offer.discount_type == "fixed" {
            cell.lblOrderValue.text = "\(offer.discount_amount) RS OFF"
        }
        cell.lblTitle.text = "UP TO RS.\(offer.discount_max) | MIN ORDER RS.\(offer.applicable_amount_greater_than)"
        
        cell.lblMenuCount.text = "USE CODE \(offer.discount_coupon)"
        
        cell.lblDeliveryTime.text = "Offer Ends on \(offer.discount_to)"
        
        if let off = self.selectedOffer, off.discount_id == offer.discount_id {
            cell.lblStarRating.text = "◉"
        }else {
            cell.lblStarRating.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var height : CGFloat = 150
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let offer = self.offers[indexPath.row]
        
        self.applyOffer(offer: offer)

    }
        
}

extension OffersVC {
    
    func applyOffer(offer: Offers) {
        
        let cartValues = self.addedMenus.map({ $0.displayPrice })
        let val = cartValues.reduce(0, +)
        
        
        
        /*var calculatedTax = 0.0
        
        for tax in self.allTaxes {
            if let res = self.restaurent, tax.restaurant_id == res.restaurant_id {
                if let cgst = tax.cgst.toDouble(), let sgst = tax.sgst.toDouble() {
                    calculatedTax = ((val/100) * cgst) + ((val/100) * sgst)
                }
            }
        }
        
        var distanceInKM = 7.1
        if let addr = self.currentAddress, let res = self.restaurent {
            let addr1lat = addr.lattitude
            let addr1long = addr.longitude
            if  let reslat = res.latitude.toDouble(), let reslong = res.longitude.toDouble() {
                let coordinate0 = CLLocation(latitude: addr1lat, longitude: addr1long)
                let coordinate1 = CLLocation(latitude: reslat, longitude: reslong)

                let distanceInMeters = coordinate0.distance(from: coordinate1) // result is in meters
                
                distanceInKM = distanceInMeters / 1000
            }
        }
        let charges = Utilities.getCharges(amount: val, distanceInKM: distanceInKM, planSelected: self.restaurent.resto_plan)
        
        let total = charges + val + calculatedTax.roundTo(places: 2)
        
        var params = [String: Any]()
        var orderItemDetails = [[String: Any]]()
        
        for menu in self.addedMenus {
            var menuItem = [String: Any]()
            menuItem["menu_id"] = "\(menu.menu_id)"
            menuItem["qty"] = "\(menu.menuCount)"
            orderItemDetails.append(menuItem)
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: orderItemDetails, options: [.prettyPrinted])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        params["menus"] = "\(jsonString!)"
        var categoryDetails = [[String: Any]]()
        
        for menu in self.addedMenus {
            var menuItem = [String: Any]()
            menuItem["menu_categoryid"] = "\(menu.menu_categoryid)"
            categoryDetails.append(menuItem)
        }
        
        let categoryDetailsjsonData = try? JSONSerialization.data(withJSONObject: categoryDetails, options: [.prettyPrinted])
        let categoryDetailsjsonString = String(data: categoryDetailsjsonData!, encoding: .utf8)
        params["categories"] = "\(categoryDetailsjsonString!)"
        
        params["coupon"] = offer.discount_coupon
        params["restaurant_id"] = self.restaurent.restaurant_id
        params["ordertype"] = "delivery"
        params["subtotal"] = val
        params["totalall"] = total

        print(params)
        
        ApiManager.applyDiscountCouponApi(params: params) { (json, b, error) in
            self.hideActivityIndicator()
            
            if b, let dict = json?.dictionary {
                if let status = dict["status"]?.string, status == "200" {
                    self.selectedOffer = offer
                    if let amount = dict["discount_amount"]?.string {
                        self.selectedOffer.userDiscount = amount
                    }
                    self.showAlert(dict["message"]?.string ?? "Offer applied successfully!", title: AlertMessages.ALERT_TITLE, dismissButtonTitle: "OK") { (action) in
                        if let del = self.backDelegate {
                            del.updateData(offer)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    self.showError(message: dict["message"]?.string ?? "Offer not valid, please try different offer.")
                }
            }else {
                self.showError(message: "Offer not valid, please try different offer.")
            }
        }
         */
    }
}

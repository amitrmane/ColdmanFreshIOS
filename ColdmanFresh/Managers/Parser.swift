//
//  Parser.swift
//  MSDCA
//
//  Created by WSLT82 on 08/02/19.
//  Copyright © 2019 WSLT82. All rights reserved.
//

import UIKit
//import SwiftyJSON
import CoreLocation
/*
class Restaurents {
    
    var id : Int64 = 0
    var name = ""
    var displayName = ""
    var foodType: FoodType!
    var fileName = ""
    var categories = [Category]()
    
    // For Pet Pooja
    var restaurantid = ""
    var active = ""
    var images = [String]()
    var country = ""
    var address = ""
    var deliverycharge = ""
    var longitude = ""
    var calculatetaxondelivery : Int64 = 0
    var restaurantname = ""
    var contact = ""
    var deliveryhoursto2 = ""
    var minimumorderamount = ""
    var packaging_charge_type = ""
    var state = ""
    var minimumdeliverytime = ""
    var packaging_applicable_on = ""
    var landmark = ""
    var deliveryhoursfrom2 = ""
    var deliveryhoursfrom1 = ""
    var packaging_charge = ""
    var latitude = ""
    var deliveryhoursto1 = ""
    var calculatetaxonpacking : Int64 = 0
    var city = ""
    var menusharingcode = ""
    
    //new php API
    var restaurant_id = ""
    var restaurant_logo = ""
    var restaurant_banner = ""
    var restaurant_foodtype = ""
    var restaurant_cuisine = ""
    var restaurant_name = ""
    var restaurant_email = ""
    var restaurant_status = ""
    var restaurant_contact = ""
    var restaurant_details = ""
    var restaurant_address = ""
    var restaurant_food_min_price = ""
    var restauran_delivery_min_time = ""
    var types_of_food = ""
    var cgst = ""
    var sgst = ""
    var resto_timing = ""
    var restaurant_on_off = ""
    var is_parent = ""
    var parent_id = ""
    var resto_type = ""
    var resto_plan = ""
    var restaurant_password = ""
    var resto_offer = ""
    var pincode = ""
    var resto_payment_label = ""
    var fssai = ""
    var created_at = ""
    var rating = ""

    class func getRestaurents(array: [JSON]) -> [Restaurents] {
        var resArr = [Restaurents]()
        for dict in array {
            let res = Restaurents()
            if let value = dict["id"].number {
                res.id = value.int64Value
            }
            if let value = dict["name"].string {
                res.name = value
            }
            if let value = dict["fileName"].string {
                res.fileName = value
            }
            if let value = dict["displayName"].string {
                res.displayName = value
            }
            if let value = dict["foodType"].dictionary {
                res.foodType = FoodType.getFoodTypes(dict: value)
            }
            if let value = dict["openClose"].array {
                res.openClose = Timing.getAllTimings(array: value)
            }
            if let value = dict["cateogry"].array {
                res.categories = Category.getAllCategories(array: value)
            }
            if let value = dict["latitude"].string {
                res.latitude = value
            }
            if let value = dict["longitude"].string {
                res.longitude = value
            }
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse, let lat = res.latitude.toDouble(), let long = res.longitude.toDouble() {
                let location = CLLocation(latitude: lat, longitude: long)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                    {(placemarks, error) in
                        if error != nil {
                            print("reverse geodcode fail: \(error!.localizedDescription)")
                        }else {
                            if let pm = placemarks?.first {
                                var addressString : String = ""
                                if let subThoroughfare = pm.subThoroughfare {
                                    addressString = subThoroughfare + " "
                                }
                                if let thoroughfare = pm.thoroughfare {
                                    addressString = addressString + thoroughfare + ", "
                                }
                                if let postalCode = pm.postalCode {
                                    addressString = addressString + postalCode + " "
                                }
                                if let locality = pm.locality {
                                    addressString = addressString + locality + ", "
                                }
                                if let administrativeArea = pm.administrativeArea {
                                    addressString = addressString + administrativeArea + " "
                                }
                                if let country = pm.country {
                                    addressString = addressString + country
                                }
                                res.address = addressString
                                print(res.name, " - ", res.address)
                            }
                        }
                })
            }
            resArr.append(res)
        }
        return resArr
    }
    
    class func getPetPoojaRestaurents(array: [JSON]) -> [Restaurents] {
        var resArr = [Restaurents]()
        for dict in array {
            let res = Restaurents()
            if let value = dict["restaurantid"].string {
                res.restaurantid = value
            }
            if let value = dict["active"].string {
                res.active = value
            }
            if let details = dict["details"].dictionary {
                if let value = details["images"]?.array {
                    res.images = value.map { $0.stringValue }
                }
                if let value = details["country"]?.string {
                    res.country = value
                }
                if let value = details["address"]?.string {
                    res.address = value
                }
                if let value = details["deliverycharge"]?.string {
                    res.deliverycharge = value
                }
                if let value = details["longitude"]?.string {
                    res.longitude = value
                }
                if let value = dict["calculatetaxondelivery"].number {
                    res.calculatetaxondelivery = value.int64Value
                }
                if let value = details["restaurantname"]?.string {
                    res.restaurantname = value
                }
                if let value = details["contact"]?.string {
                    res.contact = value
                }
                if let value = details["deliveryhoursto2"]?.string {
                    res.deliveryhoursto2 = value
                }
                if let value = details["minimumorderamount"]?.string {
                    res.minimumorderamount = value
                }
                if let value = details["packaging_charge_type"]?.string {
                    res.packaging_charge_type = value
                }
                if let value = details["state"]?.string {
                    res.state = value
                }
                if let value = details["minimumdeliverytime"]?.string {
                    res.minimumdeliverytime = value
                }
                if let value = details["packaging_applicable_on"]?.string {
                    res.packaging_applicable_on = value
                }
                if let value = dict["calculatetaxonpacking"].number {
                    res.calculatetaxonpacking = value.int64Value
                }
                if let value = details["landmark"]?.string {
                    res.landmark = value
                }
                if let value = details["deliveryhoursfrom2"]?.string {
                    res.deliveryhoursfrom2 = value
                }
                if let value = details["deliveryhoursfrom1"]?.string {
                    res.deliveryhoursfrom1 = value
                }
                if let value = details["packaging_charge"]?.string {
                    res.packaging_charge = value
                }
                if let value = details["latitude"]?.string {
                    res.latitude = value
                }
                if let value = details["deliveryhoursto1"]?.string {
                    res.deliveryhoursto1 = value
                }
                if let value = details["city"]?.string {
                    res.city = value
                }
                if let value = details["menusharingcode"]?.string {
                    res.menusharingcode = value
                }
            }
            resArr.append(res)
        }
        return resArr
    }

    class func getAllRestaurents(array: [JSON]) -> [Restaurents] {
        var resArr = [Restaurents]()
        for dict in array {
            let res = Restaurents()
            if let value = dict["restaurant_id"].string {
                res.restaurant_id = value
            }
            if let value = dict["restaurant_logo"].string {
                res.restaurant_logo = value
            }
            if let value = dict["restaurant_banner"].string {
                res.restaurant_banner = value
            }
            if let value = dict["restaurant_foodtype"].string {
                res.restaurant_foodtype = value
            }
            if let value = dict["restaurant_cuisine"].string {
                res.restaurant_cuisine = value
            }
            if let value = dict["restaurant_name"].string {
                res.restaurant_name = value
            }
            if let value = dict["restaurant_email"].string {
                res.restaurant_email = value
            }
            if let value = dict["restaurant_status"].string {
                res.restaurant_status = value
            }
            if let value = dict["restaurant_contact"].string {
                res.restaurant_contact = value
            }
            if let value = dict["restaurant_details"].string {
                res.restaurant_details = value
            }
            if let value = dict["restaurant_address"].string {
                res.restaurant_address = value
            }
            if let value = dict["restauran_delivery_min_time"].string {
                res.restauran_delivery_min_time = value
            }
            if let value = dict["restaurant_food_min_price"].string {
                res.restaurant_food_min_price = value
            }
            if let value = dict["restauran_delivery_min_time"].string {
                res.restauran_delivery_min_time = value
            }
            if let value = dict["restaurant_food_min_price"].string {
                res.restaurant_food_min_price = value
            }
            if let value = dict["types_of_food"].string {
                res.types_of_food = value
            }
            if let value = dict["cgst"].string {
                res.cgst = value
            }
            if let value = dict["sgst"].string {
                res.sgst = value
            }
            if let value = dict["longitude"].string {
                res.longitude = value
            }
            if let value = dict["city"].string {
                res.city = value
            }
            if let value = dict["restaurant_on_off"].string {
                res.restaurant_on_off = value
            }
            if let value = dict["is_parent"].string {
                res.is_parent = value
            }
            if let value = dict["fssai"].string {
                res.fssai = value
            }
            if let value = dict["created_at"].string {
                res.created_at = value
            }
            if let value = dict["resto_payment_label"].string {
                res.resto_payment_label = value
            }
            if let value = dict["pincode"].string {
                res.pincode = value
            }
            if let value = dict["latitude"].string {
                res.latitude = value
            }
            if let value = dict["resto_offer"].string {
                res.resto_offer = value
            }
            if let value = dict["restaurant_password"].string {
                res.restaurant_password = value
            }
            if let value = dict["resto_plan"].string {
                res.resto_plan = value
            }
            if let value = dict["resto_type"].string {
                res.resto_type = value
            }
            if let value = dict["parent_id"].string {
                res.parent_id = value
            }
            if let value = dict["resto_timing"].string {
                res.resto_timing = value
            }
            if let value = dict["rating"].number {
                res.rating = value.stringValue
            }
            resArr.append(res)
        }
        return resArr
    }

}

class FoodType {
    var id = 0
    var name = ""
    
    // For Pet Pooja - Attributes
    var attributeid = ""
    var active = ""
    var attribute = ""
    
    class func getFoodTypes(dict: [String: JSON]) -> FoodType {
        let type = FoodType()
        if let value = dict["id"]?.number {
            type.id = value.intValue
        }
        if let value = dict["name"]?.string {
            type.name = value
        }
        return type
    }
    
    class func getPetPoojaAttributes(array: [JSON]) -> [FoodType] {
        var resArr = [FoodType]()
        for dict in array {
            let type = FoodType()
            if let value = dict["attributeid"].string {
                type.attributeid = value
            }
            if let value = dict["active"].string {
                type.active = value
            }
            if let value = dict["attribute"].string {
                type.attribute = value
            }
            resArr.append(type)
        }
        return resArr
    }
}

*/

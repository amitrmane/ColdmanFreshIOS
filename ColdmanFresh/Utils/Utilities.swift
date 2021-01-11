//
//  Utilities.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//

import UIKit
import UserNotifications
import MapKit
import AVFoundation

class Utilities: NSObject {
    
    
    class func addValueForKeyToUserDefauls(_ key:String,value:AnyObject)
    {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func removeValueForKeyFromDefaults(_ key:String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getValueForKeyFromUserDefaults(_ key:String)->AnyObject?
    {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    class func setBorderAndCornerRadius(object: CALayer, width: CGFloat, radius: CGFloat,color : UIColor ) {
        
        object.borderColor = color.cgColor
        object.borderWidth = width
        object.cornerRadius = radius
        object.masksToBounds = true
    }
    
//    class func openAppleMapsForCoordinates(_ latitude:Double,longitude:Double,name:String)
//    {
//        
//        
//        
//        
//        let _latitute:CLLocationDegrees =  latitude
//        let _longitute:CLLocationDegrees =  longitude
//        
//        let regionDistance:CLLocationDistance = 1000
//        let coordinates = CLLocationCoordinate2DMake(_latitute,_longitute )
//        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
//        let options = [
//            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
//            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
//            MKLaunchOptionsShowsTrafficKey: true
//            ] as [String : Any]
//        
//        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = name
//        mapItem.openInMaps(launchOptions: options)
//        
//        
//        
//    }
//    
    
//    class func openGoogleMapsForCoordinates(_ latitude:Double,longitude:Double,name:String)
//    {
//        
//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
//        {
//            
//            let urlStr =  "comgooglemaps://?q=\(name.replacingOccurrences(of: " ", with: "+"))&center=\(latitude),\(longitude)&zoom=14&views=traffic"
//            UIApplication.shared.openURL(URL(string:urlStr)!)
//        }else
//        {
//            Utilities.openAppleMapsForCoordinates(latitude, longitude: longitude, name: name)
//        }
//        
//    }
    
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8, allowLossyConversion: true) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func convertToArray(text: String) -> [Any]? {
        if let data = text.data(using: .utf8)?.base64EncodedData() {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    class func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        var time = asset.duration
        time.value = min(asset.duration.value, 1)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            time.value = max(asset.duration.value, 1)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                return thumbnail
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }

    
    class func getThumbnailImageWithSize(forUrl url: URL, forSize size: CGSize) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        var time = asset.duration
        time.value = min(asset.duration.value, 2)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    class func getAddressFromLatLong(latitude: CLLocationDegrees, withLongitude longitude: CLLocationDegrees, callback: @escaping (_ address: String) -> Void) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = latitude
            center.longitude = longitude

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
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        callback(addressString)
                  }
            })

        }

    /*class func getCurrentUser() -> UserProfile? {
        let defaults = UserDefaults.standard
        guard let userData = defaults.object(forKey: "User") as? Data else {
            return nil
        }
        guard let user = try? PropertyListDecoder().decode(UserProfile.self, from: userData) else {
            return nil
        }
        if user.id != 0 {
            return user
        }
        return nil
    }*/
    
    class func getCharges(amount: Double, distanceInKM: Double, planSelected: String) -> Double {
        
        var deliveryCharges = 0.0
        var distanceCharges = 0.0

        switch planSelected {
        case PartnerPlan.H21.rawValue:
            if amount <= 99 {
                deliveryCharges = 25
            }else if amount >= 100 && amount <= 399 {
                deliveryCharges = 15
            }else if amount >= 400 {
                deliveryCharges = 0
            }
            if distanceInKM > 7 {
                distanceCharges = 20
            }else if distanceInKM >= 5 && distanceInKM <= 7 {
                distanceCharges = 10
            }else {
                distanceCharges = 0
            }
            break
        case PartnerPlan.H26.rawValue:
            deliveryCharges = 0
            if distanceInKM > 7 {
                distanceCharges = 20
            }else if distanceInKM >= 5 && distanceInKM <= 7 {
                distanceCharges = 10
            }else {
                distanceCharges = 0
            }
            break
        case PartnerPlan.H16.rawValue:
            if amount <= 99 {
                deliveryCharges = 50
            }else if amount >= 100 && amount <= 399 {
                deliveryCharges = 25
            }else if amount >= 400 {
                deliveryCharges = 0
            }
            if distanceInKM > 7 {
                distanceCharges = 20
            }else if distanceInKM >= 5 && distanceInKM <= 7 {
                distanceCharges = 10
            }else {
                distanceCharges = 0
            }

            break
        case PartnerPlan.H4.rawValue:
            if amount <= 99 {
                deliveryCharges = 25
            }else if amount >= 100 && amount <= 399 {
                deliveryCharges = 15
            }else if amount >= 400 {
                deliveryCharges = 0
            }
            if distanceInKM > 7 {
                distanceCharges = 20
            }else if distanceInKM >= 5 && distanceInKM <= 7 {
                distanceCharges = 10
            }else {
                distanceCharges = 0
            }
            break
        case PartnerPlan.H5.rawValue:
            deliveryCharges = 0
            distanceCharges = 0
            break
        default:
            deliveryCharges = 0
            distanceCharges = 0
            break
        }
        return deliveryCharges + distanceCharges
    }
    
    /*class func getDiscount(amount: Double, offer: Offers, menus : [Menu]) -> Double {
        if offer.discount_type == "percentage" {
            if let discount = offer.discount_amount.toDouble() {
                if offer.discount_applicable_on.lowercased() == "all" {
                    let maxamnt = offer.applicable_amount_less_than.toDouble() ?? 0
                    let minamnt = offer.applicable_amount_greater_than.toDouble() ?? 0
                    if minamnt > 0 && maxamnt > 0 && minamnt <= amount && amount <= maxamnt {
                        return (amount * discount) / 100
                    }else if maxamnt > 0 && amount > maxamnt, let maxamount = offer.discount_max.toDouble() {
                        return maxamount
                    }
                }else if offer.discount_applicable_on.lowercased() == "categories" {
                    for menu in menus {
                        if offer.discount_category.contains(menu.menu_categoryid) {
                            
                        }
                    }
                }else if offer.discount_applicable_on.lowercased() == "menus" {
                    
                }
            }
        }else if offer.discount_type == "fixed" {
            if let discount = offer.discount_amount.toDouble() {
                if offer.discount_applicable_on.lowercased() == "all" {
                    let maxamnt = offer.applicable_amount_less_than.toDouble() ?? 0
                    let minamnt = offer.applicable_amount_greater_than.toDouble() ?? 0
                    if minamnt > 0 && maxamnt > 0 && minamnt <= amount && amount <= maxamnt {
                        return amount - discount
                    }else if maxamnt > 0 && amount > maxamnt, let maxamount = offer.discount_max.toDouble() {
                        return maxamount
                    }
                }else if offer.discount_applicable_on.lowercased() == "categories" {
                    for menu in menus {
                        if offer.discount_category.contains(menu.menu_categoryid) {
                            
                        }
                    }
                }else if offer.discount_applicable_on.lowercased() == "menus" {
                    
                }
            }
        }
        return 0.0
    }*/

}

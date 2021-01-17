//
//  Parser.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//

import UIKit
import SwiftyJSON
import CoreLocation

class SliderData {
    var slider_id = ""
    var slider_name = ""
    var slider_image = ""
    var slider_created_at = ""
    
    class func getSliderData(array: [JSON]) -> [SliderData] {
        var dataArr = [SliderData]()
        
        for dict in array {
            let data = SliderData()
            if let value = dict["slider_id"].string {
                data.slider_id = value
            }
            if let value = dict["slider_name"].string {
                data.slider_name = value
            }
            if let value = dict["slider_image"].string {
                data.slider_image = value
            }
            if let value = dict["slider_created_at"].string {
                data.slider_created_at = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}


class Menu : Codable {
    var menu_id = ""
    var restaurant_id = ""
    var menu_logo = ""
    var menu_status = ""
    var menu_foodtype = ""
    var menu_name = ""
    var menu_displayname = ""
    var menu_price = ""
    var price = 0.0
    var displayPrice = 0.0
    var menu_categoryid = ""
    var menu_shortcode = ""
    var menu_description = ""
    var variation = [Variation]()
    var addedToCart = false
    var menuCount = 1

    class func getMenuData(array: [JSON]) -> [Menu] {
        var dataArr = [Menu]()
        
        for dict in array {
            let data = Menu()
            if let value = dict["menu_id"].string {
                data.menu_id = value
            }
            if let value = dict["restaurant_id"].string {
                data.restaurant_id = value
            }
            if let value = dict["menu_logo"].string {
                data.menu_logo = value
            }
            if let value = dict["menu_status"].string {
                data.menu_status = value
            }
            if let value = dict["menu_foodtype"].string {
                data.menu_foodtype = value
            }
            if let value = dict["menu_name"].string {
                data.menu_name = value
            }
            if let value = dict["menu_displayname"].string {
                data.menu_displayname = value
            }
            if let value = dict["menu_categoryid"].string {
                data.menu_categoryid = value
            }
            if let value = dict["menu_shortcode"].string {
                data.menu_shortcode = value
            }
            if let value = dict["menu_description"].string {
                data.menu_description = value
            }
            if let value = dict["menu_price"].string {
                data.menu_price = value
                data.price = value.toDouble() ?? 0
            }
            if let value = dict["variation"].array {
                data.variation = Variation.getVariationData(array: value)
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
    class func saveCartItems(_ cartArray: [Menu]) {
        do {
            let data = try PropertyListEncoder().encode(cartArray)
            Utilities.addValueForKeyToUserDefauls(Constants.Keys.cart, value: data as AnyObject)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func getSavedCartItems() -> [Menu] {
        let defaults = UserDefaults.standard
        guard let cart = defaults.object(forKey: Constants.Keys.cart) as? Data else {
            return []
        }
        
        guard let cartArray = try? PropertyListDecoder().decode([Menu].self, from: cart)  else {
            return []
        }
        
        return cartArray
    }
}

class Variation : Codable {
    var variation_id = ""
    var name = ""
    var group_name = ""
    var rate = ""
    var variation_status = ""

    class func getVariationData(array: [JSON]) -> [Variation] {
        var dataArr = [Variation]()
        
        for dict in array {
            let data = Variation()
            if let value = dict["variation_id"].string {
                data.variation_id = value
            }
            if let value = dict["name"].string {
                data.name = value
            }
            if let value = dict["group_name"].string {
                data.group_name = value
            }
            if let value = dict["rate"].string {
                data.rate = value
            }
            if let value = dict["variation_status"].string {
                data.variation_status = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

class Categories : Codable {
    var id = ""
    var category_name = ""
    var category_olname = ""
    var category_img = ""
    var category_on_off = ""
    var category_created_at = ""

    class func getCategoriesData(array: [JSON]) -> [Categories] {
        var dataArr = [Categories]()
        
        for dict in array {
            let data = Categories()
            if let value = dict["id"].string {
                data.id = value
            }
            if let value = dict["category_name"].string {
                data.category_name = value
            }
            if let value = dict["category_olname"].string {
                data.category_olname = value
            }
            if let value = dict["category_img"].string {
                data.category_img = value
            }
            if let value = dict["category_on_off"].string {
                data.category_on_off = value
            }
            if let value = dict["category_created_at"].string {
                data.category_created_at = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

class UserProfile : Codable {
    
    var id = 0
    var name = ""
    var email = ""
    var mobileno = ""
    var password = ""
    var address = ""
    var role = ""
    var profileImage = ""
    
    var user_id = ""
    var fname = ""
    var birthdate = ""
    var lname = ""
    var created_at = ""
    var oauth_provider = ""
    var oauth_uid = ""
    var user_device_id = ""
    var organization_id = ""

    class func getUserDetails(dict: [String: JSON]) -> UserProfile? {
        let user = UserProfile()
        
        if let id = dict["user_id"]?.string, let userid = id.toInt() {
            user.id = userid
            user.user_id = id
        }else {
            return nil
        }
        if let value = dict["name"]?.string {
            user.name = value
        }
        if let value = dict["fname"]?.string {
            user.fname = value
        }
        if let value = dict["lname"]?.string {
            user.lname = value
        }
        if let value = dict["email"]?.string {
            user.email = value
        }
        if let value = dict["mobileno"]?.string {
            user.mobileno = value
        }
        if let value = dict["password"]?.string {
            user.password = value
        }
        if let value = dict["address"]?.string {
            user.address = value
        }
        if let value = dict["profileImage"]?.string {
            user.profileImage = value
        }
        if let value = dict["profileImage"]?.string {
            user.profileImage = value
        }
        if let value = dict["role"]?.string {
            user.role = value
        }
        if let value = dict["birthdate"]?.string {
            user.birthdate = value
        }
        if let value = dict["created_at"]?.string {
            user.created_at = value
        }
        let defaults = UserDefaults.standard
        
        // Use PropertyListEncoder to convert UserProfile into Data / NSData
        do {
            defaults.set(try PropertyListEncoder().encode(user), forKey: "User")
        }catch {
            print(error.localizedDescription)
        }
        return user
    }
}

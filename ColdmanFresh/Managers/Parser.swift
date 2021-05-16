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
    var order_menu_id = ""
    var menu_logo = ""
    var menu_status = ""
    var menu_foodtype = ""
    var menu_name = ""
    var qty = ""
    var menu_displayname = ""
    var menu_price = ""
    var price = 0.0
    var displayPrice = 0.0
    var menu_categoryid = ""
    var menu_shortcode = ""
    var menu_description = ""
    var menu_variation = ""
    var variation = [Variation]()
    var selectedVariation : Variation!
    var addedToCart = false
    var menuCount = 1

    class func getMenuData(array: [JSON]) -> [Menu] {
        var dataArr = [Menu]()
        
        for dict in array {
            let data = Menu()
            if let value = dict["menu_id"].string {
                data.menu_id = value
            }
            if let value = dict["order_menu_id"].string {
                data.order_menu_id = value
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
            if let value = dict["qty"].string {
                data.qty = value
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
                let listItems = value.components(separatedBy: "/")
                data.price = listItems.first!.toDouble() ?? 0
            }
            if let value = dict["variation"].array {
                data.variation = Variation.getVariationData(array: value)
            }
            if let value = dict["menu_variation"].string {
                data.menu_variation = value
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
    var selected = false

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
            if let value = dict["maincategory_name"].string {
                data.category_name = value
            }
            if let value = dict["maincategory_olname"].string {
                data.category_olname = value
            }
            if let value = dict["maincategory_img"].string {
                data.category_img = value
            }
            if let value = dict["maincategory_on_off"].string {
                data.category_on_off = value
            }
            if let value = dict["maincategory_created_at"].string {
                data.category_created_at = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

class SubCategories : Codable {
    var id = ""
    var category_name = ""
    var category_olname = ""
    var category_img = ""
    var category_on_off = ""
    var category_created_at = ""
    var maincategory = ""
    var isExpanded = false

    class func getCategoriesData(array: [JSON]) -> [SubCategories] {
        var dataArr = [SubCategories]()
        
        for dict in array {
            let data = SubCategories()
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
            if let value = dict["maincategory"].string {
                data.maincategory = value
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
    var customer_type = ""
    var pincode = ""

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
        if let value = dict["pincode"]?.string {
            user.pincode = value
        }
        if let value = dict["organization_id"]?.string {
            user.organization_id = value
        }
        if let value = dict["customer_type"]?.string {
            user.customer_type = value
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

class OrderDetails {
    
    var order_id = ""
    var discount_amount = ""
    var coupon = ""
    var gate = ""
    var totalall = ""
    var payment_type = ""
    var transaction_id = ""
    var transaction_date = ""
    var created_at = ""
    var to_delivery_address = ""
    var to_latitude = ""
    var to_longitude = ""
    var from_address = ""
    var from_latitude = ""
    var from_longitude = ""
    var order_status = ""
    var timeslot = ""
    var pickup_date = ""
    var date_time = ""
    var payment_mode = ""
    var cost = ""
    var currency = ""
    var ordered_user_address = ""
    var menus = [Menu]()

    class func getOrderDetails(dict: [String: JSON]) -> OrderDetails? {
        let response = OrderDetails()
        
        if let value = dict["order_id"]?.string {
            response.order_id = value
        }else {
            return nil
        }
        if let value = dict["coupon"]?.string {
            response.coupon = value
        }
        if let value = dict["discount_amount"]?.string {
            response.discount_amount = value
        }
        if let value = dict["gate"]?.string {
            response.gate = value
        }
        if let value = dict["totalall"]?.string {
            response.totalall = value
        }
        if let value = dict["payment_type"]?.string {
            response.payment_type = value
        }
        if let value = dict["transaction_id"]?.string {
            response.transaction_id = value
        }
        if let value = dict["transaction_date"]?.string {
            response.transaction_date = value
        }
        if let value = dict["created_at"]?.string {
            response.created_at = value
        }
        if let value = dict["to_delivery_address"]?.string {
            response.to_delivery_address = value
        }
        if let value = dict["to_latitude"]?.string {
            response.to_latitude = value
        }
        if let value = dict["to_longitude"]?.string {
            response.to_longitude = value
        }
        if let value = dict["from_address"]?.string {
            response.from_address = value
        }
        if let value = dict["from_latitude"]?.string {
            response.from_latitude = value
        }
        if let value = dict["from_longitude"]?.string {
            response.from_longitude = value
        }
        if let value = dict["order_status"]?.string {
            response.order_status = value
        }
        if let value = dict["timeslot"]?.string {
            response.timeslot = value
        }
        if let value = dict["pickup_date"]?.string {
            response.pickup_date = value
        }
        if let value = dict["date_time"]?.string {
            response.date_time = value
        }
        if let value = dict["payment_mode"]?.string {
            response.payment_mode = value
        }
        if let value = dict["currency"]?.string {
            response.currency = value
        }
        if let value = dict["cost"]?.string {
            response.cost = value
        }
        if let value = dict["ordered_user_address"]?.string {
            response.ordered_user_address = value
        }
        if let value = dict["menus"]?.array {
            response.menus = Menu.getMenuData(array: value)
        }
        return response
        
    }
    
    class func getAllOrders(array: [JSON]) -> [OrderDetails] {
        var resArr = [OrderDetails]()
        for dict in array {
            if let value = dict.dictionary, let order = OrderDetails.getOrderDetails(dict: value) {
                resArr.append(order)
            }
        }
        return resArr
    }
}

class Address {
    var id = ""
    var user_id = ""
    var address = ""
    var lattitude : Double = 0
    var longitude : Double = 0
    var title = ""
    var primaryAddress = ""
    var created_at = ""
    var landmark = ""
    var door_flat_no = ""
    var myaddress = ""
    var fname = ""
    var lname = ""
    var email = ""
    var mobileno = ""
    var city = ""
    var pincode = ""

    class func getAllAddresses(array: [JSON]) -> [Address] {
        var resArr = [Address]()
        for dict in array {
            let res = Address()
            if let value = dict["id"].number {
                res.id = "\(value.intValue)"
            }
            if let value = dict["id"].string {
                res.id = value
            }
            if let value = dict["user_id"].string {
                res.user_id = value
            }
            if let value = dict["address"].string {
                res.address = value
            }
            if let value = dict["myaddress"].string {
                res.myaddress = value
            }
            if let value = dict["primary_address"].string {
                res.primaryAddress = value
            }
            if let value = dict["created_at"].string {
                res.created_at = value
            }
            if let value = dict["door_flat_no"].string {
                res.door_flat_no = value
            }
            if let value = dict["landmark"].string {
                res.landmark = value
            }
            if let value = dict["lattitude"].number {
                res.lattitude = value.doubleValue
            }
            if let value = dict["longitude"].number {
                res.longitude = value.doubleValue
            }
            if let value = dict["latitude"].string, let val = value.toDouble() {
                res.lattitude = val
            }
            if let value = dict["longitude"].string, let val = value.toDouble()  {
                res.longitude = val
            }
            if let value = dict["title"].string {
                res.title = value
            }
            if let value = dict["fname"].string {
                res.fname = value
            }
            if let value = dict["lname"].string {
                res.lname = value
            }
            if let value = dict["email"].string {
                res.email = value
            }
            if let value = dict["mobileno"].string {
                res.mobileno = value
            }
            if let value = dict["city"].string {
                res.city = value
            }
            if let value = dict["pincode"].string {
                res.pincode = value
            }

            resArr.append(res)
        }
        return resArr
    }

}

class Offers {
    
    var discount_id = ""
    var restaurant_id = ""
    var discount_title = ""
    var discount_coupon = ""
    var discount_category = ""
    var discount_menu = ""
    var discount_ordertype = ""
    var discount_type = ""
    var discount_applicable_on = ""
    var discount_from = ""
    var discount_from_date : Date!
    var discount_to_date : Date!
    var discount_to = ""
    var discount_amount = ""
    var discount_max = ""
    var applicable_amount_greater_than = ""
    var applicable_amount_less_than = ""
    var discount_all_days = ""
    var discount_days = ""
    var discount_status = ""
    var discount_created_at = ""
    var userDiscount = ""

    class func getAllOffers(array: [JSON]) -> [Offers] {
        var resArr = [Offers]()
        for dict in array {
            let res = Offers()
            if let value = dict["discount_id"].string {
                res.discount_id = value
            }
            if let value = dict["restaurant_id"].string {
                res.restaurant_id = value
            }
            if let value = dict["discount_title"].string {
                res.discount_title = value
            }
            if let value = dict["discount_coupon"].string {
                res.discount_coupon = value
            }
            if let value = dict["discount_category"].string {
                res.discount_category = value
            }
            if let value = dict["discount_menu"].string {
                res.discount_menu = value
            }
            if let value = dict["discount_ordertype"].string {
                res.discount_ordertype = value
            }
            if let value = dict["discount_type"].string {
                res.discount_type = value
            }
            if let value = dict["discount_applicable_on"].string {
                res.discount_applicable_on = value
            }
            if let value = dict["discount_max"].string {
                res.discount_max = value
            }
            if let value = dict["discount_from"].string {
                res.discount_from = value
                if let date = Date().dateFromString(Date.DateFormat.yyyyMMddHHmmss.rawValue, dateString: value) {
                    res.discount_from_date = date
                }
            }
            if let value = dict["discount_to"].string {
                res.discount_to = value
                if let date = Date().dateFromString(Date.DateFormat.yyyyMMddHHmmss.rawValue, dateString: value) {
                    res.discount_to_date = date
                    res.discount_to = date.stringFromDate(Date.DateFormat.dateMonth)
                }
            }
            if let value = dict["discount_amount"].string {
                res.discount_amount = value
            }
            if let value = dict["applicable_amount_greater_than"].string {
                res.applicable_amount_greater_than = value
            }
            if let value = dict["applicable_amount_less_than"].string {
                res.applicable_amount_less_than = value
            }
            if let value = dict["discount_all_days"].string {
                res.discount_all_days = value
            }
            if let value = dict["discount_days"].string {
                res.discount_days = value
            }
            if let value = dict["discount_status"].string {
                res.discount_status = value
            }
            if let value = dict["discount_all_days"].string {
                res.discount_created_at = value
            }
            resArr.append(res)
        }
        return resArr
    }

}

class Gate {
    var gate_id = ""
    var gate_name = ""
    var gate_created_at = ""

    class func getData(array: [JSON]) -> [Gate] {
        var dataArr = [Gate]()
        
        for dict in array {
            let data = Gate()
            if let value = dict["gate_id"].string {
                data.gate_id = value
            }
            if let value = dict["gate_name"].string {
                data.gate_name = value
            }
            if let value = dict["gate_created_at"].string {
                data.gate_created_at = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

class Timeslot {
    var timeslot_id = ""
    var timeslot_name = ""
    var timeslot_created_at = ""

    class func getData(array: [JSON]) -> [Timeslot] {
        var dataArr = [Timeslot]()
        
        for dict in array {
            let data = Timeslot()
            if let value = dict["timeslot_id"].string {
                data.timeslot_id = value
            }
            if let value = dict["timeslot_name"].string {
                data.timeslot_name = value
            }
            if let value = dict["timeslot_created_at"].string {
                data.timeslot_created_at = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

class Organization : Codable {
    var organization_id = ""
    var organization_name = ""
    var organization_created_at = ""
    var address = ""

    class func getData(array: [JSON]) -> [Organization] {
        var dataArr = [Organization]()
        
        for dict in array {
            let data = Organization()
            if let value = dict["organization_id"].string {
                data.organization_id = value
            }
            if let value = dict["organization_name"].string {
                data.organization_name = value
            }
            if let value = dict["organization_created_at"].string {
                data.organization_created_at = value
            }
            if let value = dict["address"].string {
                data.address = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

class Pincode : Codable {
    var pincodeId = ""
    var pincode = ""
    var area = ""
    var status = ""
    var charges = ""

    class func getData(array: [JSON]) -> [Pincode] {
        var dataArr = [Pincode]()
        
        for dict in array {
            let data = Pincode()
            if let value = dict["pincodeId"].string {
                data.pincodeId = value
            }
            if let value = dict["pincode"].string {
                data.pincode = value
            }
            if let value = dict["area"].string {
                data.area = value
            }
            if let value = dict["status"].string {
                data.status = value
            }
            if let value = dict["charges"].string {
                data.charges = value
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

//
//  Constants.swift
//  Football09
//
//  Created by Prasad Patil on 29/11/19.
//  Copyright © 2019 Prasad Patil. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

class Constants {
   
    static let baseURL:String = "http://apicmf.edigito.in/"
    static let baseDownloadURL:String = "http://13.233.0.160:8080/menukart/downloadFile/"
    static let appBarColour = UIColor.red//(hexString: "4884ED")//UIColor(red: 24.0/255.0, green: 153.0/255.0, blue: 203.0/255.0, alpha: 1)
    
    static let APP_REGULAR_FONT =  "HelveticaNeue"
    static let APP_LIGHT_FONT =  "HelveticaNeue-Light"
    static let APP_BOLD_FONT =  "HelveticaNeue-Bold"
    static let APP_BOLD_ITALIC_FONT =  "HelveticaNeue-BoldItalic"
    static let APP_MEDIUM_FONT =  "HelveticaNeue-Medium"

    
 //   static let APP_USER_COLOR = UIColor.init(hexString: Userdata.user_color)
    

    static let locationManager = CLLocationManager()

    struct ApiEndPoint {
        static let resturant = "Resturant/resturant"
        static let category = "Category/cateogry"
        static let findAllDiscount = "Discount/findAllDiscount"
        static let findAllMenu = "Menu/findAllMenu"
        static let findAllTax = "Tax/findAllTax"
        static let resturantById = "Resturant/resturantById/"
        static let addUser = "User/addUser"
        static let login = "User/login"
        static let generateOtp = "Otp/generateOtp/"
        static let verfiyOtp = "Otp/verify"
        static let findUserFromMobile = "User/findByMobileNumber/"
        static let findAddresByUserid = "User/findAddresByUserid/"
        static let addAddress = "User/addUserAddresByUserId"
        static let updateAddress = "User/address"
        static let saveOrder = "Order/saveOrder"
        static let updateOrder = "Order/updateOrderStatus"
        static let orderHistory = "Order/getOrderDetailsByUserId/"
        static let orderDetailsById = "Order/findOrderDetailsByOrderId/"
    }
  
    struct WebLinks {
        static var cancellation_and_refund = "http://landing.menukart.online/public/docs/Cancellations and Refunds.docx"
        static var privacy_policy = "http://landing.menukart.online/public/docs/Menukart Privacy Policy.docx"
        static var terms_and_conditions = "http://landing.menukart.online/public/docs/Menukart (Terms & Conditions).docx"
    }
    
    struct Keys {
        static let cart = "Cart"
    }
}



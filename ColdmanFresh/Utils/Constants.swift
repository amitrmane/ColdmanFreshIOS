//
//  Constants.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//

import Foundation
import UIKit
import CoreLocation

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

class Constants {
   
    static let baseURL:String = "http://apicmf.edigito.in/"
    static let baseDownloadURL:String = "http://coldmanfresh.edigito.in/uploads/category/"
    static let appBarColour = UIColor.red//(hexString: "4884ED")//UIColor(red: 24.0/255.0, green: 153.0/255.0, blue: 203.0/255.0, alpha: 1)
    
    static let APP_REGULAR_FONT =  "HelveticaNeue"
    static let APP_LIGHT_FONT =  "HelveticaNeue-Light"
    static let APP_BOLD_FONT =  "HelveticaNeue-Bold"
    static let APP_BOLD_ITALIC_FONT =  "HelveticaNeue-BoldItalic"
    static let APP_MEDIUM_FONT =  "HelveticaNeue-Medium"

    
 //   static let APP_USER_COLOR = UIColor.init(hexString: Userdata.user_color)
    

    static let locationManager = CLLocationManager()

    struct ApiEndPoint {
        static let slider = "slider"
        static let organization = "organization"
        static let gate = "gate"
        static let timeslot = "timeslot"
        static let order_details = "order_details"
        static let update_profile = "update_profile"
        static let orders = "orders"
        static let send_otp = "send_otp"
        static let resend_otp = "resend_otp"
        static let address = "address"
        static let check_order_status = "check-order-status"
        static let discount_coupon = "discount_coupon"
        static let verify_otp = "verify_otp"
        static let sign_up = "sign-up"
        static let update_address = "update-address"
        static let add_address = "add-address"
        static let save_order = "save-order"
        static let menus = "menus"
        static let coupons = "coupons"
    }
  
    struct WebLinks {
        static var cancellation_and_refund = "http://coldmanfresh.edigito.in/cancellation-policy"
        static var privacy_policy = "http://coldmanfresh.edigito.in/privacy-policy"
        static var terms_and_conditions = "http://coldmanfresh.edigito.in/privacy-policy"
    }
    
    struct Keys {
        static let cart = "Cart"
        static let razorPayKeyTest = "rzp_test_sY4RuQtxewxAOq"
    }
    
    struct AppColors {
        static let bgRed = UIColor(hexString: "CF292B")
        static let bgGreen = UIColor(hexString: "4fb68d")
    }
}



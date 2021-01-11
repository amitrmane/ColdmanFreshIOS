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


class Menu {
    var menu_id = ""
    var restaurant_id = ""
    var menu_logo = ""
    var menu_status = ""
    var menu_foodtype = ""
    var menu_name = ""
    var menu_displayname = ""
    var menu_price = ""
    var menu_categoryid = ""
    var menu_shortcode = ""
    var menu_description = ""
    var variation = [Variation]()
    var addedToCart = false

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
            }
            if let value = dict["variation"].array {
                data.variation = Variation.getVariationData(array: array)
            }
            dataArr.append(data)
        }
        
        return dataArr
    }
    
}

class Variation {
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

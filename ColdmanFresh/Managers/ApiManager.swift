//
//  ApiManager.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiManager: NSObject {
    static var alamoFireManager : Session = { () -> Session in
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 15000
        manager.session.configuration.timeoutIntervalForResource = 15000

        return manager
    }()
   // var net = Reachability()?.currentReachabilityStatus
    class func checkuser_online() -> Bool{

        print("", Reachability()?.currentReachabilityStatus as Any)
        print("",Reachability()!.isReachable)
        return Reachability()!.isReachable
        //return  NetworkReachabilityManager()!.isReachable
    }
    
    class func parseResponse(json : JSON?, completion: @escaping (_ data: JSON?) -> Void) {
        DispatchQueue.main.async {
            if let dict = json?.dictionary {
                if let status = dict["status"]?.number, status == 200 {
                    if let dict = dict["data"]?.dictionary {
                        let newjson = JSON(dict)
                        completion(newjson)
                    }else if let array = dict["data"]?.array {
                        let newjson = JSON(array)
                        completion(newjson)
                    }else {
                        completion(json)
                    }
                }else if let status = dict["status"]?.string, status == "200" {
                    if let dict = dict["data"]?.dictionary {
                        let newjson = JSON(dict)
                        completion(newjson)
                    }else if let array = dict["data"]?.array {
                        let newjson = JSON(array)
                        completion(newjson)
                    }else {
                        completion(json)
                    }
                }else {
                    completion(nil)
                    // show alert
                }
            }
        }
    }
    
    // MARK:- APIs
    class func getSliderData( completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.slider)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }
    
    class func getMenusData( completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.menus)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }


    class func sendOTP(params: [String: Any], completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.send_otp)!
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    
    class func verifyOTP(mobNo: String, completion: @escaping (_ data: JSON?) -> Void) {
        
        let urlstring = Constants.baseURL + Constants.ApiEndPoint.verify_otp + "?mobileno=\(mobNo)"
        
        let url1 = URL(string: urlstring)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    class func signUp(params: [String: Any], completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.sign_up)!
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        if let d = response.data {
                            print(String(data: d, encoding: .utf8) ?? "")
                        }
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }
    
    class func updateProfile(params: [String : Any], imageData: Data?, fileName: String, mimeType: String, completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.update_profile)!
        
        self.alamoFireManager.upload(multipartFormData: { (multiData) in
            if let d = imageData {
                multiData.append(d, withName: "profileImage", fileName: fileName, mimeType: mimeType)
            }
            for (key, val) in params {
                multiData.append("\(val)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url1).responseJSON { response in
            
            guard response.error == nil
            else
            {
                DispatchQueue.main.async(execute: {
                    print("--------error-------------\n")
                    // show alert
                    completion(nil)
                })
                return
            }
            if let value: Any = response.value as Any? {
                
                let json = JSON.init(value)
                
                //print("json",json)
                
                ApiManager.parseResponse(json: json) { (parsedjson) in
                    completion(parsedjson)
                }
            }
            else
            {
                print("error fetching response")
                DispatchQueue.main.async {
                    // show alert
                    completion(nil)
                }
            }
        }
    }


    class func saveOrderApi(params: [String: Any], completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.save_order)!
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    // MARK:- get All Orders API
    class func getAllOrders(userid: String, completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.orders + "?user_id=\(userid)")!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    // MARK:- get All addresses API
    class func getUserAddresses(userid: String, completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.address + "?user_id=\(userid)")!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    class func addNewAddress(params: [String: Any], completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.add_address)!
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }
    
    class func updateAddress(params: [String: Any], completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.add_address)!
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }


    // MARK:- get All offers API
    class func getOffers(completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.coupons)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    class func applyOffer(params: [String: Any], completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.discount_coupon)!
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    class func getOrganizationList( completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.organization)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }
    
    class func getGateList( completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.gate)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    class func getTimeslotList( completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.timeslot)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    // MARK:- get Orders details API
    class func getOrderDetails(order_id: String, completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.order_details + "?order_id=\(order_id)")!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

    class func getPincodeList( completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.pincode)!
        
        self.alamoFireManager.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                guard response.error == nil
                else
                {
                    DispatchQueue.main.async(execute: {
                        print("--------error-------------\n")
                        // show alert
                        completion(nil)
                    })
                    return
                }
                if let value: Any = response.value as Any? {
                    
                    let json = JSON.init(value)
                    
                    //print("json",json)
                    
                    ApiManager.parseResponse(json: json) { (parsedjson) in
                        completion(parsedjson)
                    }
                }
                else
                {
                    print("error fetching response")
                    DispatchQueue.main.async {
                        // show alert
                        completion(nil)
                    }
                }
            }
    }

}

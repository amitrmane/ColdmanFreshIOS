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
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
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
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
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

    class func saveOrderApi(params: [String: Any], completion: @escaping (_ data: JSON?) -> Void) {
        
        let url1 = URL(string: Constants.baseURL + Constants.ApiEndPoint.save_order)!
        
        self.alamoFireManager.request(url1, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
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

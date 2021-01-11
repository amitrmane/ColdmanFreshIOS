//
//  Structs.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2021 Prasad Patil. All rights reserved.
//

import Foundation
import UIKit
import Security


struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    
    static func topEdge()->CGFloat
    {
        if #available(iOS 11.0, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            return (insets?.top)! + 20
        }
        return 20
    }
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
     static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && (ScreenSize.SCREEN_MAX_LENGTH == 1024 )
    static let IS_IPAD_10_INCH              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1112
    static let IS_IPAD_12_INCH              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366
    
}

struct StoryBoards
{
    
    static let main = "Main"

}
struct AlertMessages
{
    static let ALERT_TITLE = "COLDMAN FRESH"
    static let ALERT_INCOMPLETE = "Incomplete form"
    
    //Log in
    static let EMPTY_EMAIL = "Enter Email"
    static let EMPTY_USER_NAME = "Enter user name"
    static let EMPTY_PASSWORD = "Enter password"
    static let EMPTY_Domain = "Enter domain"
    static let WRONG_CREDENTIALS = "Wrong credentials"
    static let WRONG_PASSWORD = "Wrong password"
    static let ENTER_VALID_EMAIL = "Enter Valid Email Id"
    static let ENTER_NEW_PASSWORD = "Enter New Password"
    static let ENTER_CONFIRM_PASSWORD = "Enter Confirm Password"
    static let EMPTY_NAME = "Enter Name"
    static let EMPTY_ZIP_CODE = "Enter Zip Code"
    static let EMPTY_CONTACT = "Enter Contact Details"
    static let EMPTY_ADDRESS = "Enter Address Details"
    static let Network = "Network not reachable, please check your internet connection."
}


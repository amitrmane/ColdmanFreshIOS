//
//  Enums.swift
//  Football09
//
//  Created by Prasad Patil on 29/11/19.
//  Copyright © 2019 Prasad Patil. All rights reserved.
//

import Foundation

enum ErrorTypes:String
{
    
    case GENERIC_ERROR = "Oops. Service Unavailable, please try again later.." // when api failed due to any network error
    case EMAIL_NOT_AVAILABLE = "Email Not Available"
    case NONE = "Successfull"
    case PULL_QUERY_ERROR = "Failed to fetch data."
    case SERVER_ISSUE = "Server was unable to process request, please try again" // when json parsing failed
    case INSERT_FAILED = "There was a problem for inserting data to server."
    case IMAGEUPLOAD_FAILED = "There was a problem uploading the image."
    case NOINTERNET = "No internet available"
    case INVALID_OLD_PASS = "Invalid Old Password"
    case TRY_SOMETIME = "There was a problem. Please try after some time"// when api failed due to any network error
    case FAIL_CANCEL_LEAVE = "Fail to Cancel Leave"
    case CANCELLED_LEAVE = "Successfully cancelled"
    case CAN_NOT_CANCELLED = "You can not cancel leave after actual leave date "
    case ALREADY_CANCEL = " You have Already applied for Resignation"
    case WRONG_PASS_ID = "Invalid Credentails"
    case INVALID_DOMAIN = "Invalid Domain"
    case INVALID_DATA = "Invalid Data"
    case CONTACT_TO_ADMINISTRATOR = "Contact to administrator"
    case TRY_AGAIN = "Something went wrong, please try again" // When unexpected data received
    case NO_RECORD = "No record found"
    
}

enum PartnerPlan : String {
    
    case H21 = "H21"
    case H26 = "H26"
    case H16 = "H16"
    case H4 = "H4"
    case H5 = "H5"

}




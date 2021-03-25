//
//  Extensions.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2021 Prasad Patil. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

extension Bundle {
    
    class func bundleID() -> String? {
        return Bundle.main.bundleIdentifier
    }
    
    func currentInstalledVersion() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}


extension String {
    
    func toInt() -> Int? {
        enum F {
            static let formatter = NumberFormatter()
        }
        if let number = F.formatter.number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    func toInt64() -> Int64? {
        enum F {
            static let formatter = NumberFormatter()
        }
        if let number = F.formatter.number(from: self) {
            return number.int64Value
        }
        return nil
    }
    
    func toDouble() -> Double? {
        enum F {
            static let formatter = NumberFormatter()
        }
        if let number = F.formatter.number(from: self) {
            return number.doubleValue
        }
        return nil
    }
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return "\(self[range.lowerBound])".trailingTrim(characterSet)
        }
        return self
    }
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    
    func isValidEmail() -> Bool {
        
        //   let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let email = "^[A-Z0-9a-z\\._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", email)
        return emailTest.evaluate(with: self)
    }
    
    func validatePhone() -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    func isValidatePhone() -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
}



extension String {
    
    var camelCasedString: String {
        let source = self
        if source.contains(" ") {
            let first = "\(source[source.index(source.startIndex, offsetBy: 1)...])"
            let cammel = NSString(format: "%@", (source as NSString).capitalized.replacingOccurrences(of: " ", with: " ", options: [], range: nil)) as String
            let rest = String(cammel.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = "\(source.lowercased()[source.index(source.startIndex, offsetBy: 1)...])"
            let rest = String(source.dropFirst())
            return "\(first)\(rest)"
        }
    }
    var length : Int {
        return self.count
    }
    
    var trimmed : String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var afterStrippingCurrency : Float {
        
        
        
        let currencySymbol =  (Locale.current as NSLocale).object(forKey: NSLocale.Key.currencySymbol) as? String
        let strippedString = self.replacingOccurrences(of: currencySymbol!, with: "")
        if(strippedString.length == 0)
        {
            return 0
        }
        
        if(strippedString == ".")
        {
            return 0
        }
        
        return Float(strippedString)!
    }
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension NSAttributedString {
    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}


extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var month : Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    
    var year : Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }

    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) year"   }
        if months(from: date)  > 0 { return "\(months(from: date)) month"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) week"   }
        if days(from: date)    > 0 { return "\(days(from: date)) day"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hrs"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) secs" }
        return ""
    }
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        var dateIsAdvanced = false
        
        if now.compare(date as Date) == .orderedAscending
        {
            dateIsAdvanced = true
        }
        
        
        if (components.year! >= 2) {
            if dateIsAdvanced
            {
                return "\(components.year!) years to go"
            }
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                if dateIsAdvanced
                {
                    return "after a year"
                }
                return "1 year ago"
            } else {
                if dateIsAdvanced
                {
                    return "next year"
                }
                return "Last year"
            }
        } else if (components.month! >= 2) {
            if dateIsAdvanced
            {
                return "\(components.month!) months to go"
            }
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                
                if dateIsAdvanced
                {
                    return "after a month"
                }
                return "1 month ago"
            } else {
                if dateIsAdvanced
                {
                    return "next month"
                }
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            if dateIsAdvanced
            {
                return "\(components.weekOfYear!) weeks ago"
            }
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                if dateIsAdvanced
                {
                    return "a week to go"
                }
                return "1 week ago"
            } else {
                if dateIsAdvanced
                {
                    return "next week"
                }
                return "Last week"
            }
        } else if (components.day! >= 2) {
            if dateIsAdvanced
            {
                return "\(components.day!) days to go"
            }
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                if dateIsAdvanced
                {
                    return "a day to go"
                }
                return "1 day ago"
            } else {
                if dateIsAdvanced
                {
                    return "tomorrow"
                }
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            
            if dateIsAdvanced
            {
                return "\(components.hour!) hours to go"
            }
            
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                if dateIsAdvanced
                {
                    return "an hour to go"
                }
                return "1 hour ago"
            } else {
                if dateIsAdvanced
                {
                    return "an hour to go"
                }
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            if dateIsAdvanced
            {
                return "\(components.minute!) minutes to go"
            }
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                
                if dateIsAdvanced
                {
                    return "a minute to go"
                }
                return "1 minute ago"
            } else {
                if dateIsAdvanced
                {
                    return "a minute to go"
                }
                return "a minute ago"
            }
        } else if (components.second! >= 3) {
            
            if dateIsAdvanced
            {
                return "\(components.second!) seconds to go"
            }
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
    
    var tillLastMinuteOfDay: Date {
        return Calendar.current.date(bySettingHour: 11, minute: 59, second: 59, of: self)!
    }

    func createDate(with  hour: Int)->Date{
        
        var components = DateComponents()
        
        components.hour = hour
        components.minute = 0
        
        
        let cal = Calendar.current
        
        
        return cal.date(from: components)!
    }
    
    
    func currentDayOfMonth() -> Int {
        
        let calendar = Calendar.current
        let currentDateComponents = (calendar as NSCalendar).components([.day,.year,.month], from: self)
        
        
        return currentDateComponents.day!
    }
    
    func formatedDate(_ format:String)-> String
    {
        let formatter = DateFormatter()
        //Now check whether your phone is in 12 hour or 24 hour format
        let locale = Locale.current
        let formatter1 : String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale) ?? ""
        
        //we have to change our dateFormatter as per the hour format
        var newformat = format
        
        if formatter1.contains("a") {
            //            print("phone is in 12 Hour Format")
            newformat = format.replacingOccurrences(of: "a", with: "a")
        } else {
            //            print("phone is in 24 Hour Format")
            newformat = format.replacingOccurrences(of: "a", with: "")
            newformat = newformat.replacingOccurrences(of: "hh", with: "HH")
        }
        
        formatter.dateFormat = newformat
        
        return formatter.string(from: self)
    }
    
    func dateFromString(_ format:String,dateString:String) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        //Now check whether your phone is in 12 hour or 24 hour format
        let locale = Locale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale) ?? ""
        
        //we have to change our dateFormatter as per the hour format
        var newformat = format
        var newDateString = dateString
        
        if formatter.contains("a") {
//            print("phone is in 12 Hour Format")
            newformat = format.replacingOccurrences(of: "a", with: "a")
        } else {
//            print("phone is in 24 Hour Format")
            newformat = format.replacingOccurrences(of: "a", with: "")
            newformat = newformat.replacingOccurrences(of: "hh", with: "HH")
            newDateString = dateString.replacingOccurrences(of: "AM", with: "")
            newDateString = newDateString.replacingOccurrences(of: "PM", with: "")
        }
        
        dateFormatter.dateFormat = newformat
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        
        return  dateFormatter.date( from: newDateString )
        
    }
    
   
    
    func currentDay() -> Int {
        
        let calendar = Calendar.current
        let currentDateComponents = (calendar as NSCalendar).components([.weekday,.year,.month], from: self)
        
        
        return currentDateComponents.weekday!
    }
    
    func isDateInGivenRange(_ startDate:Date,endDate:Date)->Bool
    {
        if(self.compare(startDate) == .orderedSame && self.compare(endDate) == .orderedSame )
        {
            return true
        }
        if(self.compare(startDate) == .orderedAscending && self.compare(endDate) == .orderedDescending )
        {
            return false
        }
        
        return true
        
    }
    
    
    func dateByAddingSeconds(_ secondsToAdd: Int) -> Date? {
        
        let calendar = Calendar.current
        var seconds = DateComponents()
        seconds.second = secondsToAdd
        
        return (calendar as NSCalendar).date(byAdding: seconds, to: self, options: [])
    }
    
    func dateByAddingDays(_ days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func dateBySubstractingDays(_ days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func datesBetweenTwoDates(_ startDate:Date, endDate:Date)->[Date]
    {
        var date = startDate
        var dates:[Date] = [startDate]
        
        while date.compare(endDate) != .orderedDescending {
            // Advance by one day:
            dates.append(date.dateByAddingDays(1))
            date = date.dateByAddingDays(1)
            
        }
        
        return dates
    }
    
    
    func isToday() -> Bool {
        let cal = Calendar.current
        let unitFlags: Set<Calendar.Component> = [ .day, .weekOfYear, .month, .year, .era]
        var components = cal.dateComponents(unitFlags, from: Date())
        let today = cal.date(from: components)
        
        components = cal.dateComponents(unitFlags, from: self)
        let otherDate = cal.date(from: components)
        
        if otherDate!.compare(today!) == .orderedSame
        {
            return true
        }
        return false
    }
    
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
    public enum DateFormat : String{
        case ddMMyyhhmma = "dd/MM/yyyy hh:mm a"
        case ddMMyyhhmmssa = "dd/MM/yyyy hh:mm:ss a"
        case ddMMyyyy = "dd/MM/yyyy"
        case ddMMMyyyy = "dd-MMM-yyyy"
        case MMddyyyy = "MM/dd/yyyy"
        case EEEddMMMyyyy = "EEEE, dd MMM, yyyy"
        case date1 = "EE dd, MMM, yyyy"
        case EEEddMMMyyyyhhMMa = "EEEE dd-MMM-yyyy hh:mm a"
        case AppFormat = "EEEE, MMMM, dd, yyyy' at 'h:mm a"
        case listView = "EEEE, MMMM dd, yyyy "
        case dateMonth = "dd MMM"
        case hhmma = "hh:mm a"
        case hhmm = "hh:mm"
        case ddMMMyyyyhhmma = "dd-MMM-yyyy hh:mm a"
        case createEvent = "EEEE, dd MMM, yyyy hh:mm a"
        case currentDay = "EEEE"
        case yyyyMMdd = "yyyy-MM-dd"
        case ddMMyyyydash = "dd-MM-yyyy"
        case HHmmss = "HH:mm:ss"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
        case yyyyMMddTHHmmssSSS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    }
    
    static func getUTCDate(_ date: Date) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.DateFormat.createEvent.rawValue
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        return formatter.date(from: formatter.string(from: date))
    }
    static func getCurrentTimeZoneDate(_ date: Date) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.DateFormat.createEvent.rawValue
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier:"en_US_POSIX")

        return formatter.date(from: formatter.string(from: date))
    }

    static func StringFromEPOC(_ timeStamp:Double, dateFormat:DateFormat) ->String{
        
        let tStamp = timeStamp
        let timeInterval:TimeInterval = TimeInterval(tStamp)
        let date:Date = Date(timeIntervalSince1970: timeInterval)
        return date.stringFromDate(dateFormat)
    }
    
    static func StringFromMilliSeconds(_ timeStamp:Double, dateFormat:DateFormat) ->String{
        
        let tStamp = timeStamp/1000
        let timeInterval:TimeInterval = TimeInterval(tStamp)
        let date:Date = Date(timeIntervalSince1970: timeInterval)
        return date.stringFromDate(dateFormat)
    }
    
    func stringFromDate(_ dateFormat:DateFormat) ->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.timeZone = NSTimeZone.local
        
        return dateFormatter.string(from: self)
    }
    
    static func DateFromEPOC(_ timeStamp:Double) ->Date{
        
        let tStamp = timeStamp
        let timeInterval:TimeInterval = TimeInterval(tStamp)
        let date:Date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
    
    static func DateFromMilliSeconds(_ timeStamp:Double) ->Date{
        let tStamp = timeStamp/1000
        let timeInterval:TimeInterval = TimeInterval(tStamp)
        let date:Date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
    
    func milliSeconds() ->Double {
        return self.timeIntervalSince1970 * 1000
    }
    
    func epoc() ->Double {
        return self.timeIntervalSince1970
    }
    
    
    func datesInWeek(date:Date) -> [Date] {
        // create calendar
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // today's date
        let today = date
        
        let weekday = calendar.component(.weekday, from: today )
        let beginningOfWeek : Date
        if weekday != 2 { // if today is not Monday, get back
            beginningOfWeek = calendar.nextDate(after: today, matching: .weekday, value: 2, options: [.matchNextTime, .searchBackwards])!
        } else { // today is Monday
            beginningOfWeek = calendar.startOfDay(for: today)
        }
        var dates:[Date] = []
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: beginningOfWeek, options: [])!
            dates.append(date)
        }
        return dates
    }
    
    
    mutating func addDays(n: Int)
    {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
            Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getAllDaysIMonth() -> [Date]
    {
        var days = [Date]()
        
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        var day = firstDayOfTheMonth()
        
        for _ in 1...range.count
        {
            days.append(day)
            day.addDays(n: 1)
        }
        
        return days
    }
    
    func isGreaterThanDate(_ dateToCompare : Date) -> Bool{
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare : Date) -> Bool{
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func iSEqualToDate(_ dateToCompare : Date) -> Bool{
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }

    
}

extension Float {
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value:self))!
    }
}

extension UIImage {
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        let _: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(Double.pi))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0,y: size.height - lineWidth, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }
}






extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
}

extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self ) == self.compare(date2 )
    }
    
    /*func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
     return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
     }*/
    
}

class TextPadding : UITextField
{
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 10)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}


extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}


extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
        layer.borderWidth = 0.5
        layer.borderColor = color.cgColor
    }
    
    func removeShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0
        
        layer.shadowPath = nil
        layer.shouldRasterize = false
        layer.rasterizationScale = 0
        
    }

}

extension UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.tag == 1111 {
            return action != #selector(UIResponderStandardEditActions.paste(_:))
        }
        if action == "_insertDrawing:" {
            return false
        }
        if action == "_accessibilitySpeakLanguageSelection:" {
            return false
        }
        if action == "_accessibilitySpeak:" {
            return false
        }
        if action == "_accessibilityPauseSpeaking:" {
            return false
        }
        return true
    }
    
    override open func delete(_ sender: Any?) {
        
    }
    
    private func getKeyboardLanguage() -> String? {
        return "en" // here you can choose keyboard any way you need
    }
    
    override open var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for tim in UITextInputMode.activeInputModes {
                if tim.primaryLanguage!.contains(language) {
                    return tim
                }
            }
        }
        return super.textInputMode
    }
    
}


extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .transitionFlipFromLeft, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UISearchBar {
    
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                textField.font = textFont
            }
            if let label = view as? UILabel {
                label.font = textFont
            }
        }
    }
}

extension UILabel{
    
    func animation(typing value:String,duration: Double){
        let characters = value.map { $0 }
        var index = 0
        Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] timer in
            if index < value.count {
                let char = characters[index]
                self?.text! += "\(char)"
                index += 1
            } else {
                timer.invalidate()
            }
        })
    }
    
    
    func textWithAnimation(text:String,duration:CFTimeInterval){
        fadeTransition(duration)
        self.text = text
    }
    
    //followed from @Chris and @winnie-ru
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
}



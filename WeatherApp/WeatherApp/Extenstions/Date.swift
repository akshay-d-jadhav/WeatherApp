//
//  Date.swift
//  WeatherApp
//
//  Created by Akshay on 21/02/21.
//

import Foundation
import UIKit

struct DateFormats {
    static let standard: String = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
}

extension Date {
    var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
    }
    
    var isToday: Bool {
        get {
            return Calendar.current.isDateInToday(self)
        }
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    // Date from string with format
    init(dateString: String, format: String, utc: Bool = false) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = format
        // set utc = true to auto convert date to utc
        if utc {
            dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let timeZone = TimeZone(abbreviation: "UTC") {
                dateStringFormatter.timeZone = timeZone
            }
        }
        if let d = dateStringFormatter.date(from: dateString) {
            self.init(timeInterval:0, since:d)
        }
        else {
            self.init()
        }
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    init(milliseconds: Int32) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    // Additions
    func addYears(_ years: Int) -> Date? {
        var yearComponent:DateComponents = DateComponents()
        yearComponent.year = years
        let calendar:Calendar = Calendar.current
        return (calendar as NSCalendar).date(byAdding: yearComponent, to: self, options: NSCalendar.Options.matchStrictly)
    }
    
    func addDays(_ days: Int) -> Date? {
        var dayComponent:DateComponents = DateComponents()
        dayComponent.day = days
        let calendar:Calendar = Calendar.current
        return (calendar as NSCalendar).date(byAdding: dayComponent, to: self, options: NSCalendar.Options.matchStrictly)
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}


// MARK: - Conversion
extension Date {
    var utc: Date {
        if let val = self.string(with: DateFormats.standard, true) {
            return Date(dateString: val, format: DateFormats.standard)
        }
        return self
    }
    
    func string(with format:String, _ utc: Bool = false) -> String? {
        let dateFormatter = DateFormatter()
        // set utc = true to auto convert date to utc
        if utc {
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        }
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getTimeString(_ timeFormat: String = "hh:mm a", monthFormat: String = "MMMM dd", dateFormat: String = "dd MMMM yyyy") -> String {
        switch true {
        case (Date().minutes(from: self) <= 59):
            return "\(Date().minutes(from: self)) mins ago"
        case self.isToday:
            return "Today, \(self.string(with: timeFormat) ?? "")"
        case self.isYesterday:
            return "Yesterday, \(self.string(with: timeFormat) ?? "")"
        case self.yearsDifferenceTo(Date()) == 0:
            return self.string(with: monthFormat) ?? ""
        default:
            return self.string(with: dateFormat) ?? ""
        }
    }
    
    func getDateString(_ monthFormat: String = "MMM dd", dateFormat: String = "MMM dd yyyy") -> String {
        switch true {
        case self.isToday:
            return "Today"
        case self.isYesterday:
            return "Yesterday"
        case self.yearsDifferenceTo(Date()) == 0:
            return self.string(with: monthFormat) ?? ""
        default:
            return self.string(with: dateFormat) ?? ""
        }
    }
}

// MARK: - Comparison
extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func daysDifferenceTo(_ toDate: Date) -> Int {
        let cal = Calendar.current
        let unit: NSCalendar.Unit = NSCalendar.Unit.day
        
        return (cal as NSCalendar).components(unit, from: self, to: toDate, options: NSCalendar.Options.matchStrictly).day!
    }
    
    func yearsDifferenceTo(_ toDate: Date) -> Int {
        let cal = Calendar.current
        let unit: NSCalendar.Unit = NSCalendar.Unit.year
        
        return (cal as NSCalendar).components(unit, from: self, to: toDate, options: NSCalendar.Options.matchStrictly).year!
    }
    
    func isSameDate(_ date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
}

// MARK: -  Calendar based operations
extension Date {
    // Returns no of days passed in current month
    var days: Int {
//        return Calendar.current.dateComponents([.day], from: self).day ?? 0
        // Calculate start and end of the current month
        if let interval = Calendar.current.dateInterval(of: .month, for: self) {
            return Calendar.current.dateComponents([.day], from: interval.start, to: self).day ?? 0
        }
        return 0
    }
    
    // Returns total no of days in current month
    var totalDays: Int {
        let range = Calendar.current.range(of: .day, in: .month, for: self)
        return range?.count ?? 0
    }
    
    // Returns no of days passed in current year
    var daysOfYear: Int {
        // Calculate start and end of the current year
        if let interval = Calendar.current.dateInterval(of: .year, for: self) {
            return Calendar.current.dateComponents([.day], from: interval.start, to: self).day ?? 0
        }
        return 0
    }
    
    // Returns total no of days in current year
    var totalDaysInYear: Int {
        let range = Calendar.current.range(of: .day, in: .year, for: self)
        return range?.count ?? 0
    }
}


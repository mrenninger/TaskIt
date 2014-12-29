//
//  Date.swift
//  TaskIt
//
//  Created by Michael Renninger on 12/9/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import Foundation

class Date {
    class func from (#year:Int, month:Int, day:Int) -> NSDate {
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)!
        var date = gregorianCalendar.dateFromComponents(components)
        
        return date!
    }
    
    class func toString (#date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.stringFromDate(date)
        
        return str
    }
    
}

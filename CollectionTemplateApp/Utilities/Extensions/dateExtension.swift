//
//  dateExtension.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/12/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation


extension NSNumber{
    
    var convertTimeStampToDate:String?{
        
        let dateTimeStamp = Date(timeIntervalSince1970: Double(truncating: self)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat =  "MMM dd ',' yyyy"
        let result = dateFormatter.string(from: dateTimeStamp)
        return result
    }
    
    var convertTimeStampToTime:String?{
        let dateTimeStamp = NSDate(timeIntervalSince1970:Double(truncating: self)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat =  "hh:mm a"
        let result = dateFormatter.string(from: dateTimeStamp as Date)
        return result
    }
    
    var convertToDate:Date?{
        
        let dateTimeStamp = Date(timeIntervalSince1970: Double(truncating: self)/1000)
        
        return dateTimeStamp
    }
}



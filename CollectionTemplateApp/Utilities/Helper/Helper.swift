//
//  Helper.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype
import DTCoreText
import DTFoundation

class Helper{
    static func getAttributtedString(`for` html:String?,textOption:[String:Any]) -> NSAttributedString? {
        // Load HTML data
        guard let unwrappedHtml = html , unwrappedHtml.count > 0 else {
            
            return nil
        }
        
        let originalHtml = unwrappedHtml
        //        originalHtml = originalHtml.replacingOccurrences(of: "\n", with: "")
        //        originalHtml = originalHtml.replacingOccurrences(of: "<br>", with: "\n")
        
        let data = originalHtml.data(using: String.Encoding.utf8)
        
        let attrString = NSAttributedString(htmlData: data, options: textOption, documentAttributes: nil)
        let mutableString = attrString?.mutableCopy() as? NSMutableAttributedString
        
        //Checking if the html string has list tags to avoid first indendation issue caused by DTCoreText with `ios6 attributte` configuration
        
        if unwrappedHtml.contains("<li>") || unwrappedHtml.contains("<ul>"){
            mutableString?.trimWhiteSpaces()
            //Please read the link to understand Why we are removing kCTForegroundColorFromContextAttributeName -> https://github.com/TTTAttributedLabel/TTTAttributedLabel/pull/122
            mutableString?.removeAttribute(kCTForegroundColorFromContextAttributeName as NSAttributedStringKey, range: NSRange.init(location: 0, length: mutableString?.length ?? 0))
            return mutableString
        }
        
        let charSet = CharacterSet.whitespacesAndNewlines
        var someString = (mutableString?.string)! as NSString
        var range  = someString.rangeOfCharacter(from: charSet)
        
        while (range.length != 0 && range.location == 0)
        {
            mutableString?.replaceCharacters(in: range, with: "")
            someString = (mutableString?.string)! as NSString
            range = someString.rangeOfCharacter(from: charSet)
            
        }
        
        range = someString.rangeOfCharacter(from: charSet, options: .backwards)
        
        while (range.length != 0 && NSMaxRange(range) == someString.length)
        {
            
            mutableString?.replaceCharacters(in: range, with: "")
            someString = (mutableString?.string)! as NSString
            range = someString.rangeOfCharacter(from: charSet, options: .backwards)
        }
        
        mutableString?.trimWhiteSpaces()
        
        //Please read the link to understand Why we are removing kCTForegroundColorFromContextAttributeName -> https://github.com/TTTAttributedLabel/TTTAttributedLabel/pull/122
        
        mutableString?.removeAttribute(kCTForegroundColorFromContextAttributeName as NSAttributedStringKey, range: NSRange.init(location: 0, length: mutableString?.length ?? 0))
        
        return mutableString
    }
    
    
    class func combineAttributedStrings(str1:NSAttributedString?,str2:NSAttributedString?,seperator:String = "<br>",alignment:NSTextAlignment = .natural) -> NSAttributedString{
        
        var combinedAttributtedString = NSMutableAttributedString()
        
        var seperatorAttribuutedString = NSAttributedString(string: "\n")
        if seperator == "\n"{
            seperatorAttribuutedString = NSAttributedString(string: "\n")
        }else{
            let data = seperator.data(using: String.Encoding.utf8)
            seperatorAttribuutedString = NSAttributedString(htmlData: data, options: textOption.textElement(color: .black).textAttributtes, documentAttributes: nil)
        }
        
        
        if let unwrappedStr1 = str1{
            combinedAttributtedString.append(unwrappedStr1)
            combinedAttributtedString.append(seperatorAttribuutedString)
        }
        
        if let unwrappedStr2 = str2{
            
            combinedAttributtedString.append(unwrappedStr2)
        }
        
        if let unwrappedStr1 = str1{
            
            combinedAttributtedString = getSeperatorAttributes(combinedAttributtedString: combinedAttributtedString,alignment: alignment,seperatorAttr:unwrappedStr1)
        }
        
        return combinedAttributtedString
    }
    
    class func getPlainAttributtedString(string:String,font:UIFont? = FontService.shared.primaryBoldFont,textColor:UIColor? = ThemeService.shared.theme.primaryTextColor) -> NSMutableAttributedString {
        let separatorAttributtes = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor: textColor ?? ThemeService.shared.theme.primaryTextColor])
        return separatorAttributtes
    }
    
    class func getSeperatorAttributes(combinedAttributtedString:NSAttributedString,alignment:NSTextAlignment = .natural,seperatorAttr:NSAttributedString)->NSMutableAttributedString{
        
        let combinedMutableAttributtedString = NSMutableAttributedString(attributedString: combinedAttributtedString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        //        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.maximumLineHeight = 1
        paragraphStyle.lineHeightMultiple = 0.5
        
        paragraphStyle.alignment = alignment
        
        
        //Remove paragraph
        let overAllParagraphStyle = NSMutableParagraphStyle()
        overAllParagraphStyle.paragraphSpacing = 5
        overAllParagraphStyle.alignment = alignment
        
        combinedMutableAttributtedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:overAllParagraphStyle, range:NSMakeRange(0, combinedMutableAttributtedString.length))
        
        if seperatorAttr.length+1 <= combinedMutableAttributtedString.length{
            combinedMutableAttributtedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(seperatorAttr.length, 1))
        }
        
        return  combinedMutableAttributtedString
    }
    
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) YEARS AGO"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 YEAR AGO"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) MONTHS AGO"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 MONTH AGO"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) WEEKS AGO"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 WEEK AGO"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) DAYS AGO"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 DAY AGO"
            } else {
                return "Yesterday"
            }
        }else{
            return "\(components.hour!)H \(components.minute!)M AGO"
        }
        
    }
    
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    class func openApplicationWithURl(urlString:String) -> Bool{
        
        if let url = URL(string:urlString){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
                return true
            }
        }
        return false
    }
    
    class func getParentSectionName(sectionId:Int?) -> String? {
        guard let subSectionId =  sectionId else{
            return nil
        }
        
        guard let config = Quintype.publisherConfig ,config.sections.count > 0 else{
            return nil
        }
        
        let parentSections = config.sections.filter({$0.parent_id?.intValue == nil})
        let sectionFromId = config.sections.first(where: {$0.id?.intValue == subSectionId})
        let parentSectionName = parentSections.first(where: {$0.id?.intValue == sectionFromId?.parent_id?.intValue})?.name?.lowercased()
        
        return parentSectionName
    }
}



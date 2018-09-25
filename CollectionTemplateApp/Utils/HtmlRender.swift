//
//  HtmlRender.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/2/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit
import DTCoreText
import DTFoundation
import Quintype

extension UITextView{
    
//    func convert(toHtml html:String,textOption:textOption){
//        
//        let options = textOption.value
//        let data: Data? = html.data(using: String.Encoding.utf8)
//        let attrString:NSAttributedString = NSAttributedString.init(htmlData: data!, options: options, documentAttributes: nil)
//        
//        
//        let mutableString = attrString.mutableCopy() as? NSMutableAttributedString
//        
//        let charSet = CharacterSet.whitespacesAndNewlines
//        
//        var someString = (mutableString?.string)! as NSString
//        
//        var range  = someString.rangeOfCharacter(from: charSet)
//        
//        while (range.length != 0 && range.location == 0)
//        {
//            // [attString replaceCharactersInRange:range
//            //   withString:@""];
//            mutableString?.replaceCharacters(in: range, with: "")
//            someString = (mutableString?.string)! as NSString
//            range = someString.rangeOfCharacter(from: charSet)
//            
//        }
//        
//        range = someString.rangeOfCharacter(from: charSet, options: .backwards)
//        
//        while (range.length != 0 && NSMaxRange(range) == someString.length)
//        {
//            
//            mutableString?.replaceCharacters(in: range, with: "")
//            someString = (mutableString?.string)! as NSString
//            range = someString.rangeOfCharacter(from: charSet, options: .backwards)
//        }
//        
//        mutableString?.trimWhiteSpaces()
//        self.attributedText = mutableString
//        
//    }
    
}

extension NSMutableAttributedString{
    public func trimWhiteSpaces() {
        // Trim leading whitespace and newlines.
        self.beginEditing()
        self.enumerateAttribute(NSAttributedStringKey.font, in: NSMakeRange(0, self.length), options: EnumerationOptions()) { (value, range, pointer) in
            let font = value as! UIFont
            self.removeAttribute(NSAttributedStringKey.underlineStyle, range: range)
            
        }
        self.endEditing()
        
    }
}

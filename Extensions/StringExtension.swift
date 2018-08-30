//
//  StringExtension.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 2/9/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func decodeBase64() -> String? {
        guard let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    var localizedString: String{
        get{
            return LocalizationHelper.sharedHelper.localizedStringForKey(self)
        }
    }
    
}




extension NSAttributedString{
    
    func heightOfAttributedString(widthOfView:CGFloat) -> CGFloat{
        
        var mutableAttributedString = NSMutableAttributedString(attributedString: self)
        
        
        let placeholderTextView = UITextView(frame: CGRect(x: 0, y: 0, width: widthOfView, height: 10))
        
        placeholderTextView.attributedText = mutableAttributedString
        let size: CGSize = placeholderTextView.sizeThatFits(CGSize(width: widthOfView, height: CGFloat.greatestFiniteMagnitude))
        
        return size.height
        
    }
    
}

extension UITextView{
    
    func setLineHeight(lineHeight: CGFloat, labelWidth: CGFloat) -> CGFloat {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(attributedString: self.attributedText)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, text.characters.count))
        
            return self.sizeThatFits(CGSize(width: labelWidth, height: 20)).height
        }
        return 0
    }
    
}

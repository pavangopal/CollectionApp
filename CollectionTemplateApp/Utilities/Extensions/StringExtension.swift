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
   
    func getWidthOfString(with font: UIFont) -> CGFloat {
        let attributes = [NSAttributedStringKey.font : font]
        
        return NSAttributedString(string: self.capitalized, attributes: attributes).size().width
    }
    
    func getHeightOfString(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
 
    var url : URL{
        get{
            return URL(string:self)!
        }
    }
    
    func wordsCount() -> Int {
        let startIndex = self.startIndex
        let endIndex = self.endIndex
        var words = [String]()
        
        if endIndex > startIndex{
            
            let range = startIndex..<endIndex
            self.enumerateSubstrings(in: range, options: .byWords) { (substring, _, _, _) in
                if let substringD = substring{
                    words.append(substringD)
                }
            }
        }
        
        return words.count
    }
    
    func width(font:UIFont,maximumNumberOfLines:Int = 0) -> CGFloat{
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes = [NSAttributedStringKey.font: font]
        let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        let size1 = snap(rect).size
        return size1.width
    }
    
    func height(fits width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat{
        
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes = [NSAttributedStringKey.font: font]
        let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        var size1 = snap(rect).size
        if maximumNumberOfLines > 0 {
            size1.height = min(size1.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
        }
        
        return size1.height
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
func snap(_ x: CGFloat) -> CGFloat {
    let scale = UIScreen.main.scale
    return ceil(x * scale) / scale
}

func snap(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: snap(point.x), y: snap(point.y))
}

func snap(_ size: CGSize) -> CGSize {
    return CGSize(width: snap(size.width), height: snap(size.height))
}

func snap(_ rect: CGRect) -> CGRect {
    return CGRect(origin: snap(rect.origin), size: snap(rect.size))
}

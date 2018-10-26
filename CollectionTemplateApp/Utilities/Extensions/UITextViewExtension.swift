//
//  UITextViewExtension.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

extension UITextView{
    
    func setColor(color:UIColor,_for elementType:String){
        //add switch with differant element Types
        
        self.textColor = color
    }
    
    func setBasicProperties(){
        
        self.isEditable = false
        self.dataDetectorTypes = .all
        self.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        self.isScrollEnabled = false
        self.textContainer.lineFragmentPadding = 0
        self.textContainer.lineBreakMode = .byWordWrapping
        
        //        self.layoutManager.hyphenationFactor = 1 //for text to look justified and not leave extra spacing between characters
        
    }
}

extension UITextField{
    func wordSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.placeholder!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: self.placeholder!.characters.count))
        self.attributedPlaceholder = attributedString
    }
}

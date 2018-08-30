//
//  UILabelExtension.swift
//  CoreApp-iOS
//
//  Created by Albin CR on 2/20/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class InsetLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        
        return adjSize
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
    
}


extension UIButton{
    func wordSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


extension UILabel{
    func wordSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: self.text!.characters.count))
        self.attributedText = attributedString
    }
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false){
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel){
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else{
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    public func addTextSpacingForAttributtedText(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: self.text!.characters.count))
        self.attributedText = attributedString
        
    }
    
    func setBasicProperties(){
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        
    }
    
}


extension UINavigationItem{
    func wordSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.title!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: self.title!.characters.count))
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.attributedText = attributedString
        label.sizeToFit()
        self.titleView = label
    }
}



extension TTTAttributedLabel{
    
    func setProperties(){
        self.backgroundColor = .white
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.lineHeightMultiple = 0
        
        self.isUserInteractionEnabled = true
        
//        self.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        
        self.linkAttributes = [
            NSAttributedStringKey.foregroundColor:UIColor.blue
        ]
        self.activeLinkAttributes =  [
            NSAttributedStringKey.foregroundColor:UIColor.blue
        ]
        
    }
}

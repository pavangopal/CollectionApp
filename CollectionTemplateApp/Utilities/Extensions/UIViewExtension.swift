//
//  UIViewExtension.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    func applyGradient(colors:[UIColor],locations:[NSNumber]?,startPoint:CGPoint,endPoint:CGPoint,frame:CGRect? = nil){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = frame ?? self.bounds
        
        gradient.colors = colors.map({$0.cgColor})
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = locations
        
        self.layer.sublayers = self.layer.sublayers?.filter({!$0.isKind(of: CAGradientLayer.self)})
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func adjustAnchorPoint(_ anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x, y: bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position    = position
        layer.anchorPoint = anchorPoint
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        //x=>(self.frame.height) + 5
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
    
    
    func addTopBorderWithGradientColors(colors: [UIColor], width: CGFloat) {
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)//CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colors.map({$0.cgColor})
        
        self.layer.addSublayer(gradient)
        
    }
    
    func addRightBorderWithGradientColor(colors: [UIColor], width: CGFloat,height:CGFloat?) {
        
        
        let gradient = CAGradientLayer()
        let height = height ?? self.frame.size.height
        gradient.frame =  CGRect(x: self.frame.size.width - width, y: 0, width: width, height: height)//CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colors.map({$0.cgColor})
        
        self.layer.addSublayer(gradient)
    }
    
    func addBottomBorderWithGradientColor(colors: [UIColor], width: CGFloat) {
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width, height: width)//CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colors.map({$0.cgColor})
        
        
        self.layer.addSublayer(gradient)
        
    }
    
    func addLeftBorderWithGradientColor(colors: [UIColor], width: CGFloat,height:CGFloat?) {
        
        let gradient = CAGradientLayer()
        let height = height ?? self.frame.size.height
        gradient.frame =  CGRect(x: 0, y: 0, width: width, height: height)//CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colors.map({$0.cgColor})
        
        self.layer.addSublayer(gradient)
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.layer.add(animation, forKey: nil)
    }
}

protocol Bluring {
    func addBlur(style:UIBlurEffectStyle)
}

extension Bluring where Self: UIView {
    func addBlur(style:UIBlurEffectStyle) {
        
        let blurEffect = UIBlurEffect(style: style)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
    }
    
    static func getBlurView(style:UIBlurEffectStyle) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }
    
    
}

// Conformance
extension UIView: Bluring {}



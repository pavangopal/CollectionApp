//
//  BorderExtension.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/12/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import  UIKit

extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,byRoundingCorners: corners,cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

extension String {
    func getWidthOfString(with font: UIFont) -> CGFloat {
        let attributes = [NSAttributedStringKey.font : font]
        
        return NSAttributedString(string: self.capitalized, attributes: attributes).size().width
    }
    
        func getHeightOfString(width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            
            let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
            
            return boundingBox.height
        }
}



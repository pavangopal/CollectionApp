//
//  PrimitiveType+Extension.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

extension CGSize {
    static func +(lhs:CGSize,rhs:CGSize) -> CGSize{
        let width = lhs.width + rhs.width
        let height = lhs.height + rhs.height
        return CGSize(width: width, height: height)
    }
    
    mutating func increamentHeightBy(value:CGFloat){
        self.height = self.height + value
    }
}

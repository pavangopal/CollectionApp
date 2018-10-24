//
//  UIButtonExtension.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/2/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//


import UIKit

class TagButton: UIButton {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.layer.cornerRadius = 15
        self.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

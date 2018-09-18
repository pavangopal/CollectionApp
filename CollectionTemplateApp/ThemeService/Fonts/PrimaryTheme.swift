//
//  PrimaryTheme.swift
//  PodcastPlayer
//
//  Created by Pavan Gopal on 5/3/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation

public struct PrimaryTheme:Theme{

    public var backgroundColor: UIColor = UIColor(hexString: "#ffffff")
    public var tintColor: UIColor = UIColor(hexString: "#FFCF00")
    public var navigationBarTintColor: UIColor? = UIColor(hexString: "#404040")
    public var navigationBarTranslucent: Bool = false
    
    public var navigationTitleColor: UIColor = UIColor.white
    
    public var primaryTextColor:UIColor{return UIColor(hexString:"#555555")}
    public var secondaryTextColor:UIColor{return UIColor(hexString:"#000000")}
    
    public var liveblogSectionColor:UIColor{return UIColor(hexString:"#35e7bd")}
    
    public var darkPurpleColor:UIColor{return UIColor(hexString:"#36154f")}
    
    
    //MARK:- Initializers
    public init() {}
    
}


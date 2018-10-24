//
//  PrimaryTheme.swift
//  PodcastPlayer
//
//  Created by Pavan Gopal on 5/3/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation

public struct DarkTheme:Theme{
    
    public var backgroundColor: UIColor = UIColor(hexString: "#303030")
    public var tintColor: UIColor = UIColor(hexString: "#FFCF00")
    public var navigationBarTintColor: UIColor? = UIColor(hexString: "#404040")
    public var navigationBarTranslucent: Bool = false
    
    public var navigationTitleColor: UIColor = UIColor.white
    
    public var primaryTextColor:UIColor{return UIColor(hexString:"#ffffff")}
    public var secondaryTextColor:UIColor{return UIColor(hexString:"#ffffff")}//same for now
    
    public var liveblogSectionColor:UIColor{return UIColor(hexString:"#35e7bd")}
    
    //MARK:- Initializers
    public init() {}
    
    
}


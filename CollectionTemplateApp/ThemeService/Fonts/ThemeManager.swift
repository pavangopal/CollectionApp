//
//  ThemeManager.swift
//  PodcastPlayer
//
//  Created by Pavan Gopal on 5/3/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation
import UIKit

public protocol Theme {
    
     var primaryColor:UIColor {get}

    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
    
    var navigationBarTintColor: UIColor? { get }
    var navigationBarTranslucent: Bool { get }
    
    var navigationTitleFont: UIFont { get }
    var navigationTitleColor: UIColor { get }
    
    var primaryTextColor:UIColor{get}
    
    var primaryLinkColor:UIColor{get}
    var primaryLinkHighlightColor:UIColor{get}
    
    var liveblogSectionColor:UIColor{get}
    
    var primarySectionColor:UIColor{get}
    var primaryQuintColor:UIColor{get}
    
    
    var listCellTextColor:UIColor{get}
    
    var defaultDarkBackGroundColor:UIColor{get}
    var darkPurpleColor:UIColor{get}
     var defaultLightGreyColor:UIColor{get}
    
}

extension Theme{
    public var primaryColor:UIColor { return UIColor(hexString: "#2F73E4") }

    public var backgroundColor: UIColor { return UIColor(hexString: "#ffffff") }
    public var tintColor: UIColor { return UIColor(hexString : "#007aff") }
    
    public var navigationBarTintColor: UIColor? { return nil }
    public var navigationBarTranslucent: Bool { return true }
    
    public var navigationTitleFont: UIFont { return UIFont.boldSystemFont(ofSize: 17.0) }
    public var navigationTitleColor: UIColor { return UIColor.black }
    
    public var primaryTextColor:UIColor{return UIColor(hexString:"#555555")}
    public var secondaryTextColor:UIColor{return UIColor(hexString:"#000000")}
    
    public var primaryLinkColor:UIColor{return UIColor(hexString:"#0093C6")}
    
    public var primaryLinkHighlightColor:UIColor{return UIColor(hexString:"#222222")}
    
    public var primarySectionColor:UIColor{return UIColor(hexString: "#2F73E4")}
    
    public var primaryQuintColor:UIColor{return UIColor(hexString: "#ffcf00")}
    
    
    public var listCellTextColor:UIColor{return UIColor(hexString: "#333333")}
    public var defaultDarkBackGroundColor:UIColor{return UIColor(hexString: "#333333")}
    public var darkPurpleColor:UIColor{return UIColor(hexString:"#36154f")}
    
    public var defaultLightGreyColor:UIColor{return UIColor(hexString: "#D4D4D4")}
}

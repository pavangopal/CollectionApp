//
//  AssetExtension.swift
//  MediaOne
//
//  Created by Pavan Gopal on 8/7/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

extension AssetImage {
    var image:UIImage {
        
        if let imageD = UIImage(named: self.rawValue){
            return imageD
        }else{
            print("ERROR: Asset with string '\(self.rawValue)' not found! [showing default image instead, Please verify asset string]")
            return UIImage(named: "errorImage")!
        }
        
    }
}

public enum AssetImage : String{
    case BackgroundImage = "card background"
    case EmptyStarRating = "emptyStarRating"
    case FullStarRating = "fullStarRating"
    
    case DashedLine = "dashedLine"
    case BigFact = "ic_quote_fact"
    case QuoteMark = "ic_quote_mark"
    case PlayCircle = "ic_play_circle_outline_white_48pt"
    case ImagePlaceHolder = "placeholder"
    case BackArrow = "backArrow"
    case ForwardArrow = "forwardArrow"
    
    case CameraIcon = "camera-icon"
    
    case FitTurquoise = "fit_turquoise"
    case Hamberger = "hambergerMenu"
    case NeonColor = "neon-color"
    case neon = "neon"
    case photoQ = "photoQ"
    case videoQ = "videoQ"
    case Arrow = "arrow"
    
    case quintLogoOLD = "quintLogo"
    
    case settingIcon = "settingIcon"
    case shareAStoryIcon = "shareAStoryIcon"
    case homeIcon = "Home"
    case exploreIcon = "exploreIcon"
    case videoIcon = "videoIcon"
    
    case LeftArrowIcon = "leftArrow"
    case RightArrowIcon = "rightArrow"
    
    case BrandLogo = "logo"
    case AuthorIcon = "defaultAuthor"
    
    case InfoIcon = "info"
    
    case PhotoWhite = "photoWhite"
    case PhotoBlack = "photoBlack"
    case KeyEventCircle = "circle"
    case FitColor = "fitColor"
    case FitWhite = "fitWhite"
    
    case splashScreenImage = "splashScreenImage"
    
    case crossIcon = "summaryIcon"
    
    case Trending = "trending"
    case MyReportBanner = "myreport"
    
    case upArrow = "arrowup"
    case downArrow = "arrowdown"
    case ErrorImage = "errorImage"
    
    
}

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
    
    
}

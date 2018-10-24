//
//  UIViewControllerExtension.swift
//  MediaOne
//
//  Created by Pavan Gopal on 8/7/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIViewController{
    
    public func clearUnusedImagesfromCache(){
        
        ImageCache.default.clearMemoryCache()
        ImageCache.default.cleanExpiredDiskCache()
        
    }
}

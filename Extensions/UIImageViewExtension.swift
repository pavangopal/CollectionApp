//
//  UIImageViewExtension.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/19/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
//import KingfisherWebP
import Quintype

enum imageType:String{
    
    case webp = "webp"
    case gif = "gif"
    
}

extension UIImageView {
    
    public func loadImage(imageMetaData:ImageMetaData? = nil,imageS3Key:String,targetSize:CGSize? = nil ,placeholder:UIImage? = nil,animation:ImageTransition = ImageTransition.fade(0.2)){
        
        self.image = nil//reset Before setting
        
        
        self.kf.indicatorType = .none
        
        DispatchQueue.global(qos: .background).async {
            
            let convertedUrl = ImageManager.imageUrlFor(metaData: imageMetaData, imageS3Key: imageS3Key, size: targetSize, imageQuality: ImageQuality.Medium)
            
            var componetns:URLComponents = URLComponents.init(url: convertedUrl, resolvingAgainstBaseURL: false)!
            componetns.fragment = nil
            componetns.query = nil
            
            if let mineType = componetns.url?.pathExtension.lowercased(){
                
                switch mineType{
                    
                case imageType.gif.rawValue :
                    DispatchQueue.main.async {
                        self.kf.setImage(with: convertedUrl, options: [.transition(animation)], completionHandler: { (image, error, cache, url) in
                            
                            
                            
                        })
                    }
                    
                    break
                    
                case imageType.webp.rawValue :
                    //                self.kf.setImage(with: convertedUrl, options: [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)], completionHandler: { (image, error, cache, url) in
                    //                })
                    
                    break
                    
                default:
                    DispatchQueue.main.async {
                        
                        self.kf.setImage(with: convertedUrl, placeholder: placeholder, options: [.transition(animation)], completionHandler: { (image, error, cache, url) in })
                        
                        self.kf.indicatorType = .none
                    }
                    break
                }
            }
        }
    }
    
}




extension CGFloat{
    var intValue:Int{
        get{
            return Int(self)
        }
    }
}


//
//  ImageManager.swift
//  MediaOne
//
//  Created by Pavan Gopal on 8/7/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import  Quintype

enum ImageQuality:Int{
    case Low = 40
    case Medium = 70
    case High  = 90
}

class ImageManager{
    
    static func imageUrlFor(metaData:ImageMetaData?,imageS3Key:String?, size:CGSize? = nil,imageQuality:ImageQuality) -> URL {
        
        var str = "https://" + (Quintype.publisherConfig?.cdn_image)! + "/" + (imageS3Key?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed))!
        
        //if size is nil then width is used as screenwidth and height is w.r.t server
        guard let targetSize = size else{
            
            if !(imageS3Key?.hasSuffix(".gif"))!{
                
                str = str.appendingFormat("?fmt=pjpeg&w=\(UIScreen.main.bounds.width.intValue)&q=\((imageQuality.rawValue))")
                
            }else{
                
                str = str.appendingFormat("?w=\(UIScreen.main.bounds.width.intValue)&q=\((imageQuality.rawValue) )")
                
            }
            
            return URL(string: str)!
        }
        
        
        if !(imageS3Key?.hasSuffix(".gif"))!{
            
            str = str.appendingFormat("?fmt=pjpeg&w=\(targetSize.width.intValue)&h=\(targetSize.height.intValue)&q=\((imageQuality.rawValue))")
            
        }else{
            
            str = str.appendingFormat("?w=\(targetSize.width.intValue)&q=\((imageQuality.rawValue))")
            
        }
        
        // if metadata is not present or focus point is not present; height passed is used
        guard let unwrappedMetaData = metaData, (unwrappedMetaData.focus_point != nil) else{
            //            str = str.appendingFormat("&h=\(targetSize.height.intValue)")
            return URL(string: str)!
        }
        
        let aspectRatio:[CGFloat] = [targetSize.width,targetSize.height]
        
        let path = self.path(metaData: unwrappedMetaData, aspectRatio: aspectRatio, conainerWidth: targetSize.width)
        str = str.appendingFormat(path)
        
        
        return URL(string: str)!
        
    }
    
    
    private static func path(metaData:ImageMetaData,aspectRatio:[CGFloat],conainerWidth:CGFloat) -> String{
        
        var rectOpt:[String:Any] = [:]
        
        rectOpt["rect"] = imageBounds(imageDimensions: [metaData.width as! CGFloat,metaData.height as! CGFloat], aspectRatio: aspectRatio, focusPoint: metaData.focus_point as! [CGFloat])
        
        
        return imgixPath(width: conainerWidth,opts:rectOpt)
    }
    
    private  static func imageBounds(imageDimensions:[CGFloat],aspectRatio:[CGFloat],focusPoint:[CGFloat]) -> [CGFloat] {
        
        if (imageDimensions[0] * aspectRatio[1]) < (imageDimensions[1] * aspectRatio[0]){
            //use entire width
            let expectedHeight = (imageDimensions[0]*aspectRatio[1])/aspectRatio[0]
            let bounds = findBounds(imageWidth: imageDimensions[1], cropWidth: expectedHeight, focusPoint: focusPoint[1])
            return [0,bounds,imageDimensions[0],expectedHeight]
        }else {
            //use entire height
            let expectedWidth = (imageDimensions[1]*aspectRatio[0])/aspectRatio[1]
            let bound = findBounds(imageWidth: imageDimensions[0], cropWidth: expectedWidth, focusPoint: focusPoint[0])
            return [bound,0,expectedWidth,imageDimensions[1]]
            
        }
        
    }
    
    private  static func findLeftBound(imageWidth:CGFloat,halfCropWidth:CGFloat,focusPoint:CGFloat) -> CGFloat{
        if (focusPoint - halfCropWidth) < 0{
            return 0
        }else if(focusPoint+halfCropWidth > imageWidth){
            return imageWidth - halfCropWidth
        }else{
            return focusPoint - halfCropWidth
        }
    }
    
    
    private static func findBounds(imageWidth:CGFloat,cropWidth:CGFloat,focusPoint:CGFloat)->CGFloat{
        let leftBound = findLeftBound(imageWidth: imageWidth, halfCropWidth: cropWidth/2, focusPoint: focusPoint)
        
        if (leftBound + cropWidth) > imageWidth{
            return imageWidth - cropWidth
        }else{
            return leftBound
        }
    }
    
    private static func imgixPath(width:CGFloat,opts:[String:Any]) -> String{
        if opts.isEmpty{
            return ""
        }
        var args:[String] = []
        
        opts.forEach { (key,value) in
            args.append(key)
            args.append("=")
            
            if let unwrappedValue = value as? [CGFloat]{
                
                let str = unwrappedValue.map({"\($0.intValue)"})
                
                args.append(str.joined(separator: ","))
            }else{
                args.append("\(value)")
            }
        }
        
        return "&auto=format&" + args.joined(separator: "")
    }
}

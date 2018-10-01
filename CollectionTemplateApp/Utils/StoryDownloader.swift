//
//  StoryDownloader.swift
//  CoreApp-iOS
//
//  Created by Albin CR on 4/3/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit
import Quintype
import Kingfisher

open class StoryDownloader{

    let defaults = UserDefaults.standard
    
    static let cacheToMemoryAndDiskWithTime = "cacheToMemoryAndDiskWithTime"
    
    let fields = ["id","hero-image-s3-key","sections","headline","author-name","created-at","hero-image-caption","story-content-id","tags","hero-image-metadata","story-template","slug","summary","last-published-at","cards"]
    
    var imageBaseUrl = "http://" + (Quintype.publisherConfig?.cdn_image)!  + "/" 
    let baseUrl =  Quintype.publisherConfig?.sketches_host
    var limit:Int?
    let width = UIScreen.main.bounds.width - 30
    
    // internal storage
    
    var cacheTime:Int?
    var noOfDownloads:Int?
    
    var storyIds:[String] = []
    
    var imageView:UIImageView = {
        
        let imageView = UIImageView()
        return imageView
        
    }()
    var imageView2:UIImageView = {
        
        let imageView = UIImageView()
        return imageView
        
    }()
    
    func calculateImageSize() -> CGSize{
        let imageInsets = UIEdgeInsetsMake(0, 15, 0, 15)
        let widthDimension2 = UIScreen.main.bounds.size.width - imageInsets.left - imageInsets.right
        return CGSize.init(width: widthDimension2, height: widthDimension2 * (16/9))
    }
    
    func calculateImageSize(metadata:ImageMetaData?) -> CGSize{
        let widthDimension2 = UIScreen.main.bounds.size.width
        guard metadata != nil else {
            return CGSize.init(width: widthDimension2, height: widthDimension2 * 3.0/4.0)
        }
        
        if let width = metadata?.width, metadata!.height != nil{
            let widthDimenstion1 = CGFloat(width.floatValue)
            let heightDimension1 = CGFloat((metadata?.height!.floatValue)!)
            
            
            let heightDimenstion2 = widthDimension2 * heightDimension1/widthDimenstion1
            return CGSize.init(width: widthDimension2, height: heightDimenstion2)
        }
        
        
        return CGSize.init(width: widthDimension2, height: widthDimension2 * 3.0/4.0)
    }
    
    convenience init(cacheTimeInHour:Int,noOfDownloads:Int){
        self.init()
        cacheTime = cacheTimeInHour
        self.noOfDownloads = noOfDownloads
        getStories(cacheTime:cacheTimeInHour,noOfDownloads:noOfDownloads)
    }
    
    private func getStories(cacheTime:Int,noOfDownloads:Int){
        
        
        Quintype.api.getStories(options: storiesOption.section(sectionName: ""), fields: nil, offset: 0, limit: noOfDownloads, storyGroup: nil, cache: cacheOption.oflineCacheToDisk(hour: cacheTime), Success: { (storyObject) in
            
            storyObject?.forEach({ (story) in
                
                print(story)
                if let image = story.hero_image_s3_key{
                    let sizedImg = self.calculateImageSize()
                    
//                    self.imageView.loadImage(url: self.imageBaseUrl + image + "?w=\(sizedImg.width)", targetSize: sizedImg, imageMetaData: story.hero_image_metadata)
                    
                        self.imageView.loadImage(imageMetaData: story.hero_image_metadata , imageS3Key:  image , targetSize: sizedImg, animation: .fade(0.3))
                    
                }
                
                if let id = story.id{
                    self.storyIds.append(id)
                }
                if storyObject?.last?.id == story.id{
                    
                    self.getStory(cacheTime: cacheTime)
                    
                }
                
            })
            
            
            print("completed Download")
            
        }) { (err) in
            
            print(err)
            
        }
        
        
    }
    
    private func getStory(cacheTime:Int){
        
        
        Quintype.api.getStories(options: .storyOrder(storyIds: storyIds), fields: fields, offset: 0, limit: noOfDownloads, storyGroup: nil, cache: cacheOption.none,returnDataType: returnType.json, Success: { (storiesObject) in
            
            
            storiesObject?.forEach({ (story) in
                
                if let image = story.hero_image_s3_key {
                    let sizedImg = self.calculateImageSize(metadata: story.hero_image_metadata)
                    //                    self.imageView.loadImage(url: self.imageBaseUrl + image + "?w=\(sizedImg.width)", targetSize: sizedImg, imageMetaData: story.hero_image_metadata)
                    
                    let imageURL =  URL.init(string: self.imageBaseUrl + image + "?w=\(sizedImg.width)")
                    self.imageView.kf.setImage(with:imageURL, completionHandler: {
                        (image, error, cacheType, imageUrl) in
                        print(cacheType)
                        self.imageView.image = image
                        
                    })
                }
                
                story.cards.forEach({ (card) in
                    
                    for (_,storyElement) in card.story_elements.enumerated() where storyElement.type == "image"{
                        
                        if let image = storyElement.hero_image_s3_key{
                            let sizedImg = self.calculateImageSize(metadata: storyElement.hero_image_metadata)
                            //                                                        self.imageView2.loadImage(url: self.imageBaseUrl + image + "?w=\(sizedImg.width)", targetSize: sizedImg, imageMetaData: storyElement.hero_image_metadata)
                            
                            let imageURL =  URL.init(string: self.imageBaseUrl + image + "?w=\(sizedImg.width)")
                            self.imageView.kf.setImage(with:imageURL, completionHandler: {
                                (image, error, cacheType, imageUrl) in
                                
                                self.imageView.image = image
                                
                            })
                            
                        }
                        
                        if story.cards.last?.content_id == card.content_id{
                             self.defaults.set(Date(), forKey: "offlineStorageTimer")
                        }
                        
                        
                    }
                    
                })
            })
            
        },json: { (data) in
            var counter = 0
            if let stories = data!["stories"] as? [[String:AnyObject]]{
                
                for (_,story) in (stories.enumerated()){
                    counter = counter + 1
                    print(counter)
                    if let slug = story["slug"] as? String{
                        
                        let url = self.baseUrl! + "/api/v1/stories-by-slug?slug=" + slug
                        
                        Cache.cacheData(data: ["story":story], key: url, cacheTimeInMinute: cacheTime, cacheType: StoryDownloader.cacheToMemoryAndDiskWithTime, oflineStatus: true)
                    }
                    
                }
                
            }
            
        }) { (error) in
            
            print(error)
            
        }
        
    }
    
    
    
    
    
}

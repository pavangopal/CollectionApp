//
//  StoryType.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/27/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation

enum storyType:String{
    
    case text = "text"
    case jsEmbed = "jsembed"
    case audio = "audio"
    case media = "media"
    case video = "video"
    case image = "image"
    case externalFile = "external-file"
    case composite = "composite"
    case youtubePlayer = "youtube-video"
    case pollType = "polltype"
    case soundCloud = "soundcloud-audio"
    
    case title = "title"
    case data = "data"
    
    static let looper:[storyType] = [.text,.jsEmbed,.audio,.media,.video,.image,.externalFile,.composite,.youtubePlayer,.pollType,.soundCloud,.title,.data]
    
}


enum storySubType:String{
    
    case tweet = "tweet"
    case quote = "quote"
    case summery = "summary"
    case blockquote = "blockquote"
    case blurb = "blurb"
    case bigfact = "bigfact"
    case imageGallery = "image-gallery"
    case jwPlayer = "jwplayer"
    case location = "location"
    case instagram = "instagram"
    case question = "question"
    case answer = "answer"
    case q_and_a = "q-and-a"
    case alsoRead = "also-read"
    
    case slider = "slider"
    case table = "table"
    case bitgravityVideo = "bitgravity-video"
    
    case brightcoveVideo = "brightcove-video"
    
    case facebook_video = "facebook-video"
    case facebook_post = "facebook-post"
    
}

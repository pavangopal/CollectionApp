//
//  YoutubeCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/1/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import YouTubePlayer
import Quintype

class YoutubeCell: BaseCollectionCell,YouTubePlayerDelegate {
    
   lazy var youtubeView:YouTubePlayerView = {
        let youtubeView = YouTubePlayerView()
        youtubeView.delegate = self
        return youtubeView
    }()
    
    var loadingView:UIView = {
        let view = UIView()
        return view
    }()
    
    var didAnalyticEventTriggered = false
    var url:URL?
    
    override func setUpViews(){
        super.setUpViews()
        
        loadingView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        
        let storyTemplet = self.margin.storyTemplet
        let leftInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 5 : 0
        let rightInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 10 : 0
        
        contentView.addSubview(youtubeView)
        contentView.addSubview(loadingView)
        
        loadingView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: leftInset, bottomConstant: 0, rightConstant: rightInset, widthConstant: 0, heightConstant: 0)
        
        youtubeView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: leftInset, bottomConstant: 0, rightConstant: rightInset, widthConstant: 0, heightConstant: 0)
        
    }
    
    var playerData:YouTubePlayerView?
    
    override func configure(data: Any?) {
        super.configure(data: data)
        
        let card = data as? CardStoryElement
        
        if playerData != nil{
            
            youtubeView = playerData!
            
        }else{
            if let stringUrl = card?.url {
                
                if let url = URL(string: stringUrl){
                    self.url = url
                    youtubeView.loadVideoURL(url)
                    playerData = youtubeView
                    
                }
            }
            
        }
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView){
        loadingView.isHidden = true
        
    }
    
    override func calculateHeight(targetSize: CGSize) -> CGSize {
        let playerWidth = targetSize.width
        let playerHeight = (9.0/16.0) * playerWidth
        return CGSize(width: targetSize.width, height: playerHeight + 15)
        
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == YouTubePlayerState.Buffering && !didAnalyticEventTriggered{
            reportVideoAnalytics()
            didAnalyticEventTriggered = true
        }
    }
    private func reportVideoAnalytics(){
        let timestampEpoch = Int(Date().timeIntervalSince1970)
        
        if let url = self.url{
            let videoID = url.getVideoIDFromYouTubeURL()
            let videoAnalytics = VideoAnalytics(videoSource: VideoSource.YouTube, videoId: videoID ?? "", videoPlayedTimestamp: "\(timestampEpoch)")
            MoengageAnalytics.TrackMoengageEvent(eventName: AnalyticKeys.MoengageEventName.videoViewed(videoAnalytics: videoAnalytics))

        }
    }
}









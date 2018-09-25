//
//  BrightCoveController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/14/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//
/*
import UIKit
import BrightcovePlayerSDK
import AVKit
import Quintype



class BrightCoveController: AVPlayerViewController,BCOVPlaybackControllerDelegate {
    
    let manager = BCOVPlayerSDKManager.sharedManager()
    
    var playbackService:BCOVPlaybackService?
    var playbackController:BCOVPlaybackController?
    var storyElement: CardStoryElement?
    var didAnalyticsEventReported = false
    
    init(element:CardStoryElement) {
        super.init(nibName: nil, bundle: nil)
        
        storyElement = element
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp(){
        let manager = BCOVPlayerSDKManager.shared()
        playbackController = manager?.createPlaybackController()
        playbackController?.delegate = self
        playbackController?.isAutoPlay = true
        playbackController?.isAutoAdvance = true
        
        playbackController?.options = [kBCOVAVPlayerViewControllerCompatibilityKey: true]
        
        if let storyElementMetaData = self.storyElement?.metadata, let accountId = storyElementMetaData.account_id, let videoId = storyElementMetaData.video_id {
            playbackService = BCOVPlaybackService(accountId: accountId, policyKey: appConfig.brightCovePolicyKey)
            self.requestContentFromPlaybackService(videoId: videoId)
        }
    }
    
    func requestContentFromPlaybackService(videoId:String){
        self.playbackService?.findVideo(withVideoID: videoId, parameters: [:], completion: { (video, jsonResponse, error) in
            if let videoD = video {
                self.playbackController?.setVideos([videoD] as NSArray)
            }else{
                print("Error retrieving video: \(error)")
            }
        })
    }
    
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        self.player = session.player
        reportVideoAnalytics()
    }

 
    
    private func reportVideoAnalytics(){
        let timestampEpoch = Int(Date().timeIntervalSince1970)
        let videoAnalytics = VideoAnalytics(videoSource: VideoSource.BrightCove, videoId: self.storyElement?.metadata?.video_id ?? "", videoPlayedTimestamp: "\(timestampEpoch)")
        MoengageAnalytics.TrackMoengageEvent(eventName: AnalyticKeys.MoengageEventName.videoViewed(videoAnalytics: videoAnalytics))
    }
    
}
 */

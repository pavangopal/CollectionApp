//
//  JWPlayerController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/6/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

//class JWController: BaseController {
//    
//    var player: JWPlayerController!
//    
//    var playerContainerView :UIView = {
//        let view = UIView()
//        return view
//    }()
//    
//    var config: JWConfig = JWConfig()
//    var storyElement:CardStoryElement!
//    
//    init(element:CardStoryElement) {
//        super.init()
//        storyElement = element
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        
//        view.addSubview(playerContainerView)
//        
//        playerContainerView.anchorCenterSuperview()
//        playerContainerView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: UIScreen.main.bounds.width, heightConstant: 300)
//        
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        self.configurePlayer(storyElement: self.storyElement)
//        self.createPlayer()
//        
//    }
//    
//    func createPlayer(){
//        self.playerContainerView.addSubview(self.player.view)
//    }
//    
//    func configurePlayer(storyElement:CardStoryElement){
//        
//        if Quintype.isInternetAvailable(){
//            
//            if let videoId = storyElement.metadata?.video_id{
//                config.file = "http://content.jwplatform.com/videos/\(videoId).mp4"
//                config.image = "http:\(storyElement.metadata?.thumbnail_url ?? "")"
//                
//                config.premiumSkin = JWPremiumSkinRoundster
//                let playerWidth = self.view.frame.width
//                let playerHeight = (9.0/16.0) * playerWidth
//                player = JWPlayerController(config: config)
//                
//                player.view.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: playerWidth, height: playerHeight))
//                player.forceFullScreenOnLandscape = false
//                player.forceLandscapeOnFullScreen = false
//                
//                self.player.view.autoresizingMask = [UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleWidth]
//            }
//        }
//    }
//}


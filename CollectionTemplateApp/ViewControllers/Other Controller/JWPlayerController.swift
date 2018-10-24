////
////  JWPlayerController.swift
////  TheQuint-Staging
////
////  Created by Pavan Gopal on 11/6/17.
////  Copyright © 2017 Pavan Gopal. All rights reserved.
////
//
//import UIKit
//import Quintype
//
//
//class JWController: UIViewController {
//    
//    var player: JWPlayerController = {
//        
//        let view = JWPlayerController()
//        return view
//        
//    }()
//    
//    var config: JWConfig = JWConfig()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        player.config = config
//        view.addSubview(player.view)
//        player.view.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 15, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        
//    }
//    
//    func configure(storyElement:CardStoryElement){
//        
//        if Quintype.isInternetAvailable(){
//            
//            if let videoId = storyElement.metadata?.video_id{
//                config.file = "http://content.jwplatform.com/videos/\(videoId).mp4"
//                config.cssSkin = "http://p.jwpcdn.com/iOS/Skins/nature01/nature01.css"
//                let playerWidth = self.view.frame.width
//                let playerHeight = (9.0/16.0) * playerWidth
//                player.view.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: playerWidth, height: playerHeight))
//                
//            }
//        }
//    }
//    
//    
//}

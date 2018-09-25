//
//  BitGravityController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/20/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Quintype

class BitGravityController: BaseController {
    
    var storyElement:CardStoryElement!
    
    init(element:CardStoryElement) {
        super.init()
        storyElement = element
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let urlString = storyElement.url{
            let videoURL = URL(string: urlString)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()
        }
        
    }
    
}

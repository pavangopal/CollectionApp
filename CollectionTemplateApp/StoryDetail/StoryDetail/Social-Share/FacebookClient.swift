//
//  FacebookClient.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/7/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Social
import FacebookShare
import Quintype

class FacebookClient:SocialPlatform{
    
    func share(story: Story, controller: UIViewController) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let baseUrl = Quintype.publisherConfig?.sketches_host
            let storyHeadline = story.headline ?? ""
            let slug = story.slug ?? ""
            let urlString = (baseUrl! + "/" + slug).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
            composer?.setInitialText(storyHeadline)
            
            composer?.add(URL(string: urlString))
            controller.present(composer!, animated: true, completion: nil)
            
        }else{
            
            let baseUrl = Quintype.publisherConfig?.sketches_host
            let slug = story.slug ?? ""
            let url = (baseUrl! + "/" + slug).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
            let faceBookContent = LinkShareContent(url: URL(string: url)!)
            
            let shareDialog = ShareDialog(content: faceBookContent)
            shareDialog.mode = .automatic
            shareDialog.failsOnInvalidData = true
            
            shareDialog.completion = { result in
                // Handle share results
            }
            
            do{
                try shareDialog.show()
            }catch let error{
                print(error.localizedDescription)
            }
        }
     
    }
}

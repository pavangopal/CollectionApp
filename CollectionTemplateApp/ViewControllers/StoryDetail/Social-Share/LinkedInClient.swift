//
//  LinkedInClient.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/7/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype
import UIKit
import SafariServices

class LinkedInClient:NSObject,SocialPlatform,SFSafariViewControllerDelegate {
    
    func share(story: Story, controller: UIViewController) {
        //        let headline = story.headline ?? ""
        
        let baseUrl = Quintype.publisherConfig?.sketches_host
        let slug = story.slug ?? ""
        
        let encodedString = (baseUrl! + "/" + slug).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        let urlString = "linkedin://shareArticle?mini=true&url=\(encodedString)"
        
        if !Helper.openApplicationWithURl(urlString: urlString){
            //If app is not installed show it in SafariViewController
            
            let urlString = "https://www.linkedin.com/shareArticle?mini=true&url=\(encodedString)"
            self.showSafariController(story: story,urlString:urlString, controller: controller)
        }
    }
    
    func showSafariController(story:Story,urlString:String,controller:UIViewController){
        let svc = SFSafariViewController(url: URL(string: urlString)!)
        
        svc.delegate = self
        controller.present(svc, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
}

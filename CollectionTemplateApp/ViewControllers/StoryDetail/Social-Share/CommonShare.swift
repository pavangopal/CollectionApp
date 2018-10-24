//
//  CommonShare.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/15/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

class CommonShare:SocialPlatform{
    
    func share(story:Story,controller:UIViewController){
        
        let baseUrl = Quintype.publisherConfig?.sketches_host
        let firstActivityItem = story.headline ?? ""
        let slug = story.slug ?? ""
        let url = (baseUrl! + "/" + slug).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        
        let secondActivityItem : URL = URL(string: url)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        //          This lines is for the popover you need to show in iPad
        //        activityViewController.popoverPresentationController?.sourceView = sender
        
        //          This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        controller.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func openActivityViewController(activityItem:[Any]){
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        
        //          This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        if let topController = UIApplication.shared.topMostViewController() {
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

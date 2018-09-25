//
//  TwitterClient.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/7/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype
import UIKit
import Social
import TwitterKit

class TwitterClient:NSObject,SocialPlatform,TWTRComposerViewControllerDelegate{
    
    func share(story: Story, controller: UIViewController) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let composer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let baseUrl = Quintype.publisherConfig?.sketches_host
            let storyHeadline = story.headline ?? ""
            let slug = story.slug ?? ""
            let urlString = (baseUrl! + "/" + slug).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
            composer?.setInitialText(storyHeadline)
            
            composer?.add(URL(string: urlString))
            controller.present(composer!, animated: true, completion: nil)
        }
        else{
            
            ///TESTING Logout::
            //            let store = Twitter.sharedInstance().sessionStore
            //            let userId = (store.session()?.userID)
            //
            //            if let userId1 = userId{
            //                store.logOutUserID(userId1)
            //            }
            
            let baseUrl = Quintype.publisherConfig?.sketches_host
            let storyHeadline = story.headline ?? ""
            let slug = story.slug ?? ""
            let urlString = (baseUrl! + "/" + slug).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
            
            if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
                // App must have at least one logged-in user to compose a Tweet
                let composer = TWTRComposerViewController(initialText: storyHeadline + "\n" + urlString, image: nil, videoData: nil)
                composer.delegate = self
                //TODO: Temporaryly Fixed the tweet height issue should be remmoved
                
                controller.navigationController?.present(composer, animated: true, completion: {
                    if let textView = composer.view!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews[1].subviews[1] as? UITextView,
                        let scrollView = composer.view!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews.first! as? UIScrollView {
                        composer.view.clipsToBounds = false
                        
                        textView.sizeToFit()
                        scrollView.contentSize = textView.frame.size
                        scrollView.setNeedsUpdateConstraints()
                    }
                })
            } else {

                TWTRTwitter.sharedInstance().logIn(with: controller.navigationController!, completion: { (session, error) in
                    if session != nil { // Log in succeeded
                        
                        let composer = TWTRComposerViewController(initialText: storyHeadline + "\n" + urlString, image: nil, videoData: nil)
                        composer.delegate = self
                        //TODO: Temporaryly Fixed the tweet height issue should be remmoved
                        controller.navigationController?.present(composer, animated: true, completion: {
                            if let textView = composer.view!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews[1].subviews[1] as? UITextView,
                                let scrollView = composer.view!.subviews.first!.subviews.first!.subviews.first!.subviews.first!.subviews.first! as? UIScrollView {
                                composer.view.clipsToBounds = false
                                textView.sizeToFit()
                                scrollView.contentSize = textView.frame.size
                                scrollView.setNeedsUpdateConstraints()
                            }
                        })
                    }
                })
            }
        }
    }
    

    
    
    
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
        print("Failed with Error: \(error)")
        
        let errorObject = error as NSError
        
        var title:String?
        var message:String?
        
        switch errorObject.code {
            
        case 187:
            
            title = "Cannot Send Tweet"
            message =  "The tweet is a duplicate and cannot be sent"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            controller.present(alert, animated: false, completion: nil)
            
        default:
            break
            
        }
        
    }
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        
    }
    
    func composerDidCancel(_ controller: TWTRComposerViewController) {
    }
}

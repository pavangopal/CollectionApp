//
//  WhatsAppClient.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/7/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

class WhatsAppClient:SocialPlatform{
    
    func share(story:Story,controller:UIViewController){
        
        let baseUrl = Quintype.publisherConfig?.sketches_host
        let headline = story.headline ?? ""
        let slug = story.slug ?? ""
        
        let postingString = headline + "\n" + (baseUrl! + "/" + slug)
        
        let encodedString = postingString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!

        let urlString = "whatsapp://send?text=\(encodedString)"
        
        if !Helper.openApplicationWithURl(urlString: urlString){
            
            let alert = UIAlertController(title: "Cannot post on WhatsApp", message: "Please install the app from Appstore", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            controller.present(alert, animated: false, completion: nil)
           
        }
        
    }
}

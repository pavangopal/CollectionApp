//
//  UrlExtension.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/5/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

extension URL {
    func queryStringComponents() -> [String: AnyObject] {
        
        var dict = [String: AnyObject]()
        
        // Check for query string
        if let query = self.query {
            
            // Loop through pairings (separated by &)
            for pair in query.components(separatedBy: "&") {
                
                // Pull key, val from from pair parts (separated by =) and set dict[key] = value
                let components = pair.components(separatedBy: "=")
                if (components.count > 1) {
                    dict[components[0]] = components[1] as AnyObject?
                }
            }
            
        }
        
        return dict
    }
    func getVideoIDFromYouTubeURL() -> String? {
        if self.pathComponents.count > 1 && (self.host?.hasSuffix("youtu.be"))! {
            return self.pathComponents[1]
        }
        return self.queryStringComponents()["v"] as? String
    }
}

//
//  Constants.swift
//  CoreApp-iOS
//
//  Created by Albin CR on 3/23/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import Quintype

struct Environment{
    
    struct Production{
        
        static var baseURL = "https://madrid.quintype.io"//"https://www.samachara.com" //"https://www.mediaonetv.in"//
        static var imageBaseURL = "https://" + (Quintype.publisherConfig?.cdn_image)! + "/"
        static var appStoreLink = "https://itunes.apple.com/in/app/thequint/id1066244587?mt=8"
        
        struct RemoteConfig{
            static var forceUpdateVersionKey = "mediaone_ios_force_update_from_version"
            static var mediaOneLiveTVLink = "mediaone_live_tv_link"
        }
        
        
        struct Onesignal{
            static var onesignalId = "ad351e56-9e14-47ff-960d-5690dc22c6eb"
            static var onesignalTag = "mediaone-breaking-news"
        }
        
        struct Metype{
            static var id = 83
            static var host = "https://www.metype.com/"
        }
        
        
        struct Twitter {
            static var consumerKey = "AeGdX7iTHfBF9u89i5dUohG3F"
            static var consumerSecret = "XlBKENNli6EvNgvnUgKjiAkaU8v61SJRLDXQoJv1mmDQw11EUk"
        }
        
        struct App {
            static var AppName = "MediaOne"
        }
    }
    
    struct Development {
        
        static var baseURL = "https://ace-web.qtstage.io"
        static var imageBaseURL = "https://" + (Quintype.publisherConfig?.cdn_image)! + "/"
        static var appStoreLink = "https://itunes.apple.com/in/app/thequint/id1066244587?mt=8"

        struct RemoteConfig{
            static var forceUpdateVersionKey = "mediaone_ios_force_update_from_version"
            static var mediaOneLiveTVLink = "mediaone_live_tv_link"
        }
        
        
        struct Onesignal{
            static var onesignalId = "4c682092-a930-4a8c-8772-5a53ed3f29d3"
            static var onesignalTag = "mediaone-breaking-news"
        }
        
        struct Metype{
            static var id = 2
            static var host = "https://www.metype.com/"
        }
        
        
        struct Twitter {
            static var consumerKey = "xZM7OR43sZW7Qcw59ZQQBvbUp"
            static var consumerSecret = "xPIh3ZVFCpwW71rQxhcGNvbgi2ERld1fRxuSnV0Vx3bzFesxBC"
        }
        
        struct App {
            static var AppName = "MediaOne Staging"
        }
    }
    
}

//Change .Development to .Production while Archive

var appConfig = Environment.Development.self








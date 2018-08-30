//
//  SettingDataSource.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

enum SettingsSectionType:String{
    
    case AppSettings = "App Settings"
    case ImageQuality = "Image Quality"
    case Support = "Support"
    case Social  = "Social"
    case Information = "Information"
    
    var items:[SettingsItem] {
        
        switch self {
        case .AppSettings:
            return [.Notification,.Cache]
            
        case .ImageQuality:
            return [.High,.Medium,.Low]
            
        case .Support:
            return [.ReportAProblem]
            
        case .Social:
            return [.Facebook,.Twitter,.Instagram,.Youtube]
            
        case .Information:
            return [.AboutUs,.PrivacyPolicy,.TermsAndCondition,.Version]
            
        }
    }
}

enum SettingsItem{
    case Notification
    case Cache
    
    case High
    case Medium
    case Low
    
    case RateUs
    case ReportAProblem
    
    case Facebook
    case Twitter
    case Instagram
    case Youtube
    
    case AboutUs
    case TermsAndCondition
    case PrivacyPolicy
    case Version
    
    
    var displayString:String {
        
        switch self {
            //AppSetting
            
        case .Notification:
            return "Notification"
            
        case .Cache:
            return "Cache"
            
        //Image
        case .High:
            return "High"
        case .Medium:
            return "Medium"
        case .Low:
            return "Low"
            
        //Support
        case .RateUs:
            return "Rate Us"
        case .ReportAProblem:
            return "Report A Problem"
            
        //social
        case .Facebook:
            return "Facebook"
        case .Twitter:
            return "Twitter"
        case .Instagram:
            return "Instagram"
        case .Youtube:
            return "Youtube"
            
        //info
        case .AboutUs:
            return "About Us"
        case .TermsAndCondition:
            return "Terms & Conditions"
        case .PrivacyPolicy:
            return "Privacy Policy"
        case .Version:
            return "Version"
        }
    }
    
    var subTitleString:String? {
        
        switch self {
        case .Cache:
            return "Tap to clear Cache"
            
        case .RateUs:
            return "Rate us on app store"
            
        case .ReportAProblem:
            return "Report a problem to the developers"
            
        case .Facebook:
            return "Like us on Facebook!"
            
        case .Twitter:
            return "Like us on Twitter!"
            
        case .Instagram:
            return "Like us on Instagram!"
            
        case .Youtube:
            return "Subscribe our channel on Youtube!"
            
        case .Version:
            return getVersion()
            
        default:
            return nil
        }
    }
    
    var urlString:String?{
        
        switch self {
            
        case .Facebook:
            return "https://www.facebook.com/quintillion"
            
        case .Twitter:
            return "https://twitter.com/TheQuint"
            
        case .Instagram:
            return "https://www.instagram.com/thequint"
            
        case .AboutUs:
            return "https://www.mediaonetv.in/about-us"
            
        case .TermsAndCondition:
            return "https://www.mediaonetv.in/terms-and-conditions"
            
        case .PrivacyPolicy:
            return "https://www.mediaonetv.in/privacy-policy"
            
        case .Youtube:
            return "https://youtube.com/thequint"
            
        default:
            return nil
        }
    }
    
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let appVersion = dictionary["CFBundleShortVersionString"] as! String
        let buildNum = dictionary["CFBundleVersion"] as! String
        let versionInfo = "\(appConfig.App.AppName) v\(appVersion) (\(buildNum))"
        return versionInfo
    }
}

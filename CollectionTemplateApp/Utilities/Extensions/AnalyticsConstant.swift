//
//  AnalyticsConstant.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Firebase
import Quintype
import FirebaseAnalytics

enum ImageStoryElementType{
    case HeroImage
    case ListImage
    case Gallery(selectedIndex:Int)
}

struct AnalyticKeys{
    
    enum events:String{
        case homeVisited = "HOME_VISITED"
        case storyItemClicked = "STORY_ITEM_CLICKED"
        case menuItemClicked = "MENU_ITEM_CLICKED"
        case searchItemClicked = "SEARCH_ITEM_CLICKED"
        case sectionListClicked = "SECTION_LIST_CLICKED"
        case tagListClicked = "TAG_LIST_CLICKED"
        case shareMoreClicked = "SHARE_MORE_CLICKED"
        case tagClicked = "TAG_CLICKED"
        case authorClicked = "AUTHOR_CLICKED"
        case shareFacebookClicked = "SHARE_FACEBOOK_CLICKED"
        case shareTwitterClicked = "SHARE_TWITTER_CLICKED"
        case shareGplusClicked = "SHARE_GPLUS_CLICKED"
        case shareLinkedinClicked = "SHARE_LINKEDIN_CLICKED"
        case relatedStoryClicked = "RELATED_STORY_CLICKED"
        case nextStoryClicked = "NEXT_STORY_CLICKED"
        case previousStoryClicked = "PREVIOUS_STORY_CLICKED"
        case commentClicked = "COMMENTS_CLICKED"
        case readMoreClicked = "READ_MORE_CLICKED"
        case movieReviewClicked = "MOVIE_REVIEW_CLICKED"
        case videoStoryClicked = "VIDEO_STORY_CLICKED"
        case homeNotification = "HOME_NOTIFICATION"
        case storyNotification = "STORY_NOTIFICATION"
        case unknown = "UNKNOWN"
        case settingsScreenOpened = "SETTINGS_SCREEN_OPENED"
        
    }
    
    enum category:String{
        case homeScreen = "HOME_SCREEN"
        case storyDetailScreen = "STORY_DETAIL_SCREEN"
        case sidebarOpened = "NAV_DRAWER"
        case sectionScreen = "SECTION_SCREEN"
        case authorScreen = "AUTHOR_SCREEN"
        case entertainmentScreen = "ENTERTAINMENT_SCREEN"
        case videoScreen = "VIDEO_SCREEN"
        case notification = "NOTIFICATION"
        case settingsScreen = "SETTINGS_SCREEN"
        
    }
    
    //MO-Engage
    enum MoengageEventName{
        
        case sectionViewed(sectionMeta:SectionMeta?)
        case subSectionViewed(sectionMeta:SectionMeta?)
        case storyViewed(story:Story?)
        case videoViewed(videoAnalytics:VideoAnalytics?)
        case audioListened
        
        var eventName:String{
            switch self {
            case .sectionViewed(_):
                return "SectionViewed"
            case .subSectionViewed(_):
                return "SubSectionViewed"
            case .storyViewed(_):
                return "StoryViewed"
            case .videoViewed(_):
                return "VideoViewed"
            default:
                return ""
            }
        }
    }
    
    enum MoengageEventAttributes:String{
        
        case sectionName = "SectionName"
        case sectionID = "SectionID"
        
        case subSectionName = "SubSectionName"
        case subSectionID = "SubSectionID"
        
        case storyPublishedTimestamp = "StoryPublishedTimestamp"
        case storyUpdatedTimestamp = "StoryUpdatedTimestamp"
        case storyType = "StoryType"
        case associatedTags = "AssociatedTag"
        case authorName = "AuthorName"
        
        case videoPlayTapTimestamp = "VideoPlayedTimestamp"
        case VideoSource = "VideoSource"
        case VideoID = "VideoID"
        
        case audioPlayTapCount  = "Audio Play Tap Count"
        case audioPlayTapTimestamp = "AudioPlayedTimestamp"
        case audioDuration = "Audio Duration"
        
    }
}

class GoogleAnalytics {
    
    class func Track(with category:AnalyticKeys.category, event:AnalyticKeys.events){
        
        FIRAnalytics.logEvent(withName: category.rawValue, parameters: ["EventType":event.rawValue])
        analyticWithKey(category: category.rawValue, value: event.rawValue)
    }
    
    class func Track(with category:AnalyticKeys.category,value:String){
        FIRAnalytics.logEvent(withName: category.rawValue, parameters: ["Value":value])
        
        analyticWithKey(category: category.rawValue, value: value)
    }
    
    
    private class func analyticWithKey(category:String,value:String){
        FIRAnalytics.setUserPropertyString(value, forName: category)
        
    }
    
}

class MoengageAnalytics{
    
    
    class func TrackMoengageEvent(eventName:AnalyticKeys.MoengageEventName){
        
        var payloadAttributes:[AnalyticKeys.MoengageEventAttributes:Any] = [:]
        
        switch eventName {
            
        case .sectionViewed(let sectionMeta):
            
            if let sectionMeta = sectionMeta{
                payloadAttributes =  [
                    AnalyticKeys.MoengageEventAttributes.sectionName : sectionMeta.name ?? "",
                    AnalyticKeys.MoengageEventAttributes.sectionID : sectionMeta.id?.stringValue ?? ""
                ]
            }
            
            break
            
        case .subSectionViewed(let sectionMeta):
            
            if let sectionMeta = sectionMeta{
                payloadAttributes =  [
                    AnalyticKeys.MoengageEventAttributes.subSectionName : sectionMeta.name ?? "",
                    AnalyticKeys.MoengageEventAttributes.subSectionID : sectionMeta.id ?? ""
                ]
            }
            
            break
            
        case .storyViewed(let story):
            if let story = story{
                payloadAttributes =  [
                    AnalyticKeys.MoengageEventAttributes.sectionName : story.sections.first?.name ?? "",
                    AnalyticKeys.MoengageEventAttributes.storyPublishedTimestamp : story.published_at?.stringValue ?? "",
                    AnalyticKeys.MoengageEventAttributes.storyUpdatedTimestamp : story.updated_at?.stringValue ?? "",
                    AnalyticKeys.MoengageEventAttributes.storyType : story.story_template?.rawValue ?? "",
                    AnalyticKeys.MoengageEventAttributes.associatedTags : story.tags.first?.name ?? "",
                    AnalyticKeys.MoengageEventAttributes.authorName : story.authors.first?.name ?? ""
                ]
            }
            break
            
        case .videoViewed(let videoAnalytics):
            if let videoAnalytics = videoAnalytics{
                payloadAttributes =  [
                    AnalyticKeys.MoengageEventAttributes.VideoSource : videoAnalytics.videoSource.rawValue,
                    AnalyticKeys.MoengageEventAttributes.VideoID : videoAnalytics.videoId,
                    AnalyticKeys.MoengageEventAttributes.videoPlayTapTimestamp : videoAnalytics.videoPlayedTimestamp
                ]
            }
            
        default:
            break
        }
        
        let eventDict = NSMutableDictionary()
        
        payloadAttributes.forEach { (eventValueDict) in
            eventDict.setObject(eventValueDict.value, forKey: eventValueDict.key.rawValue as NSCopying)
        }
        
//        MoEngage.sharedInstance().trackEvent(eventName.eventName, andPayload: eventDict)
        
    }
    
    
}
struct VideoAnalytics{
    var videoSource: VideoSource
    var videoId:String
    var videoPlayedTimestamp:String
}
enum VideoSource:String{
    case BrightCove = "Brightcove"
    case YouTube = "YouTube"
}

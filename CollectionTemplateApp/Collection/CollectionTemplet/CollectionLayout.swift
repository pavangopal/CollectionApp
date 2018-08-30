//
//  CollectionTemplet.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/14/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

enum CollectionLayout:String {
    
    case TwoColOneAd = "TwoColOneAd"
    
    case FullscreenCarousel = "FullscreenCarousel"
    case HalfImageSlider = "HalfImageSlider"
    case FullImageSlider = "FullImageSlider"
    case FullscreenSimpleSlider = "FullscreenSimpleSlider"
    
    case FourColGrid = "FourColGrid"
    
    case ThreeCol = "ThreeCol"
    
    case TwoCol = "TwoCol"
    case OneColStoryList = "OneColStoryList"
    
    case UNKNOWN = ""
    
    
//    var components:[SubComponent]{
//        switch self {
//        case .TwoColOneAd:
//            return [SubComponent.StoryCard]
//        default:
//            return []
//        }
//    }
    
}

enum SubComponent {
    case StoryCard
    case StoryList
    case AD
}

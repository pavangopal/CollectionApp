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
//    case FullscreenCarousel = "FullscreenCarousel"
    case HalfImageSlider = "HalfImageSlider"
    case FullImageSlider = "FullImageSlider"
    case FullscreenSimpleSlider = "FullscreenSimpleSlider"
    case FourColGrid = "FourColGrid"
    case ThreeCol = "ThreeCol"
    case TwoCol = "TwoCol"
    case OneColStoryList = "OneColStoryList"
    case FullscreenLinearGallerySlider = "FullscreenLinearGallerySlider"
    case LShapeOneWidget = "LShapeOneWidget"
    case TwoColCarousel = "TwoColCarousel"
    case TwoColHighlight = "TwoColHighlight"
    
    case UNKNOWN = ""
    

}

enum SubComponent {
    case StoryCard
    case StoryList
    case AD
}

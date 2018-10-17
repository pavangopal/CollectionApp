//
//  HomeCellType.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

enum HomeCellType:String{
    
    case collectionTitleCell = "CollectionTitleCell"
    case imageTextCell = "ImageTextCell"
    case fourColumnGridCell = "FourColumnGridCell"
    case fullImageSliderCell = "FullImageSliderCell"
    case storyListCell = "StoryListCell"
    case imageStoryListCardCell = "ImageStoryListCardCell"
    case carousalContainerCell = "CarousalContainerCell"
    case simpleSliderCell = "SimpleSliderCell"
    case linearGallerySliderCell = "LinearGallerySliderCell"
    case linerGalleryCarousalContainer = "LinerGalleryCarousalContainer"
    case imageStoryListCell = "ImageStoryListCell"
    case imageTextDescriptionCell = "ImageTextDescriptionCell"
    case storyListCardCell = "StoryListCardCell"
    
}

extension HomeCellType {
    var cell:BaseCollectionCell.Type {
        
        switch self {
        case .collectionTitleCell:
            return CollectionTitleCell.self
        case .imageTextCell:
            return ImageTextCell.self
        case .fourColumnGridCell:
            return FourColumnGridCell.self
            
        case .fullImageSliderCell:
            return FullImageSliderCell.self
        case .storyListCell:
            return StoryListCell.self
        case .imageStoryListCardCell:
            return ImageStoryListCardCell.self
        case .carousalContainerCell:
            return CarousalContainerCell.self
        case .simpleSliderCell:
            return SimpleSliderCell.self
        case .linearGallerySliderCell:
            return LinearGallerySliderCell.self
        case .linerGalleryCarousalContainer:
            return LinerGalleryCarousalContainer.self
        case .imageStoryListCell:
            return ImageStoryListCell.self
        case .imageTextDescriptionCell:
            return ImageTextDescriptionCell.self
        case .storyListCardCell:
            return StoryListCardCell.self
            
        }
        
    }
    
    var innerCellHeight:CGFloat{
        switch self {
        case .simpleSliderCell,.fullImageSliderCell:
            return 450
        case .linearGallerySliderCell:
            return 300
        case .imageTextCell:
            return 400
        default:
            return 250
        }
    }
    
    var imageWidth:CGFloat{
        switch self {
        
        case .imageStoryListCardCell:
            return 175
            
        case .imageStoryListCell:
            return 95
            
        case .storyListCell,.storyListCardCell:
            return 0
        default:
            return CollectionLayoutEngine.targetWidth
        }
    }
    
    var aspectRatio:CGFloat{
        switch self {
        case .imageStoryListCell:
            return 1
        case .fullImageSliderCell,.simpleSliderCell:
            return 2/3
        default:
            return 9/16
        }
    }
    
    var sectionFont:UIFont{
        switch self {
            
        default:
            return FontService.shared.homeSectionFont
        }
    }
    
    var headlineFont:UIFont{
        switch self {
            
        default:
            return FontService.shared.homeHeadlineRegular
        }
    }
    
    var subheadLineFont:UIFont{
        switch self {
            
        default:
            return FontService.shared.homeSubHeadlineRegular
        }
    }
    
    var authorFont:UIFont{
        switch self {
            
        default:
            return FontService.shared.homeAuthorFont
        }
    }
    
    var timestampFont:UIFont{
        switch self {
            
        default:
            return FontService.shared.homeTimestampFont
        }
    }
    
    var imageTextAlignment:ImageTextAlignment{
        switch self {
        case .imageStoryListCell,.imageStoryListCardCell:
            return .Horizontal
        case .fullImageSliderCell,.simpleSliderCell:
            return .Cover
        default:
            return .Vertical
        }
    }
    
    var sectionColor:UIColor{
        switch self {
        case .fullImageSliderCell,.imageTextCell,.simpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
    
    var headlineColor:UIColor{
        switch self {
        case .fullImageSliderCell,.simpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
 
    var authorColor:UIColor{
        switch self {
        case .fullImageSliderCell,.simpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
    
    var timestampColor:UIColor{
        switch self {
        case .fullImageSliderCell,.simpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
    
}

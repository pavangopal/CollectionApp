//
//  HomeCellType.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

enum HomeCellType:String{
    
    case CollectionTitleCell = "CollectionTitleCell"
    case DefaultCell = "defaultStoryCell"
    case EmptyCell = "EmptyCell"
    case DefaultCollectionCell = "DefaultCollectionCell"
    case ImageTextCell = "ImageTextCell"
    case FourColumnGridCell = "FourColumnGridCell"
    case FullImageSliderCell = "FullImageSliderCell"
    case StoryListCell = "StoryListCell"
    case ImageStoryListCardCell = "ImageStoryListCardCell"
    case CarousalContainerCell = "CarousalContainerCell"
    case SimpleSliderCell = "SimpleSliderCell"
    case LinearGallerySliderCell = "LinearGallerySliderCell"
    case LinerGalleryCarousalContainer = "LinerGalleryCarousalContainer"
    case ImageStoryListCell = "ImageStoryListCell"
    case ImageTextDescriptionCell = "ImageTextDescriptionCell"
    case StoryListCardCell = "StoryListCardCell"
    
}



extension HomeCellType{
    var innerCellHeight:CGFloat{
        switch self {
        case .SimpleSliderCell,.FullImageSliderCell:
            return 450
        case .LinearGallerySliderCell:
            return 300
        case .ImageTextCell:
            return 400
        default:
            return 250
        }
    }
    
    var imageWidth:CGFloat{
        switch self {
        
        case .ImageStoryListCardCell:
            return 175
            
        case .ImageStoryListCell:
            return 95
            
        case .StoryListCell,.StoryListCardCell:
            return 0
        default:
            return CollectionLayoutEngine.targetWidth
        }
    }
    
    var aspectRatio:CGFloat{
        switch self {
        case .ImageStoryListCell:
            return 1
        case .FullImageSliderCell,.SimpleSliderCell:
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
        case .ImageStoryListCell,.ImageStoryListCardCell:
            return .Horizontal
        case .FullImageSliderCell,.SimpleSliderCell:
            return .Cover
        default:
            return .Vertical
        }
    }
    
    var sectionColor:UIColor{
        switch self {
        case .FullImageSliderCell,.ImageTextCell,.SimpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
    
    var headlineColor:UIColor{
        switch self {
        case .FullImageSliderCell,.SimpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
 
    var authorColor:UIColor{
        switch self {
        case .FullImageSliderCell,.SimpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
    
    var timestampColor:UIColor{
        switch self {
        case .FullImageSliderCell,.SimpleSliderCell:
            return .white
        default:
            return ThemeService.shared.theme.primaryTextColor
        }
    }
    
}

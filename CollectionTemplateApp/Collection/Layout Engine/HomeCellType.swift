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
    
}

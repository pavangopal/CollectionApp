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
    
    case FullScreenCarouselCell = "FullscreenCarouselCell"
    
    case EmptyCell = "EmptyCell"
    
    case DefaultCollectionCell = "DefaultCollectionCell"
    
    case ImageTextCell = "ImageTextCell"
    
    
    case FourColumnGridCell = "FourColumnGridCell"
    case FullImageSliderCell = "FullImageSliderCell"
    
    case StoryListCell = "StoryListCell"
    case ImageStoryListCell = "ImageStoryListCell"
    case CarousalContainerCell = "CarousalContainerCell"
    case SimpleSliderCell = "SimpleSliderCell"

    var innerCellHeight:CGFloat{
        switch self {
        case .FullScreenCarouselCell,.SimpleSliderCell,.FullImageSliderCell:
            return 450
        
        case .ImageTextCell:
            return 300
        default:
            return 250
        }
    }
    
}

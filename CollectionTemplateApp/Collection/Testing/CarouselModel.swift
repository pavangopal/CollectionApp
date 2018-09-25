//
//  CarouselModel.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

struct CarouselModel {
    
    var layoutType:HomeCellType?
//    var stories:[Story] = []
    var collectionName:String?
    var estimatedInnerCellHeight:CGFloat = 0
    var associatedMetaData:AssociatedMetadata?
    var storyViewModel:[StoryViewModel] = []
}

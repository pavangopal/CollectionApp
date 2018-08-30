//
//  StoryCardComponent.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

class StoryCardComponent:Component {
    
    var nestedComponents:[Component] = []
    var paddingBetweenComponents:CGFloat = 10
    
    init(childComponents:[Component]) {
        self.nestedComponents = childComponents
    }
    
    func preferredViewSize(forDisplayingModel:Story,containerSize:CGSize) -> CGSize{
        var size:CGSize = CGSize.zero
        
        nestedComponents.forEach { (component) in
           size = size + component.preferredViewSize(forDisplayingModel: forDisplayingModel, containerSize: containerSize)
        }
        
        if nestedComponents.count>1{
         size.increamentHeightBy(value: paddingBetweenComponents * CGFloat(nestedComponents.count))
        }
        

        return size
    }
    
}



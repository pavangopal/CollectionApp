//
//  ImageComponent.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

protocol Component {
    var nestedComponents:[Component] {get set}
    func preferredViewSize(forDisplayingModel:Story,containerSize:CGSize) -> CGSize
}

class ImageComponent:Component {
    var nestedComponents:[Component] = []

    func preferredViewSize(forDisplayingModel:Story,containerSize:CGSize) -> CGSize {
        let newSize = CGSize(width: containerSize.width, height: floor(containerSize.width*0.7))

        return newSize
    }
    
}

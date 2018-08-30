//
//  AuthorTimeStampComponent.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

class AuthorTimeStampComponent : Component {
    
    var view: UIView?
    var nestedComponents:[Component] = []
    
    private lazy var tttAttributtedLabel = TTTAttributedLabel(frame: .zero)
    
    func loadView(){
        //no-op
    }
    
    func updateComponentWithModel(story:Story){
        
    }
    
    func preferredViewSize(forDisplayingModel:Story,containerSize:CGSize) -> CGSize {
        
        let authorConstraintedWidth = getConstrainedWidth(type: TextComponentType.AuthorName, containerWidth: containerSize.width)
        
        let authorHeight = (forDisplayingModel.authors.first?.name ?? "").getHeightOfString(width: authorConstraintedWidth, font: TextComponentType.AuthorName.font)
        
        return CGSize(width: containerSize.width, height: authorHeight)
    }
    
    func getConstrainedWidth(type:TextComponentType,containerWidth:CGFloat) -> CGFloat {
        switch type {
        case .AuthorName:
            return containerWidth - 100 - 10//padding
        default:
            return CGFloat.greatestFiniteMagnitude
        }
    }
    
}

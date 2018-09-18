//
//  TextComponent.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

class TextComponent : Component {
    
    var horizontalPagging:CGFloat = 10
    var verticalPagging:CGFloat = 10
    
    var view: UIView?
    var nestedComponents:[Component] = []
    
    private lazy var tttAttributtedLabel = TTTAttributedLabel(frame: .zero)
    private var type:TextComponentType
    
    init(type:TextComponentType){
        self.type = type
    }
    
    func loadView(){
        tttAttributtedLabel.numberOfLines = 0
        tttAttributtedLabel.font = type.font
        view = tttAttributtedLabel
    }
    
    func updateComponentWithModel(story:Story){
        
    }
    
    func preferredViewSize(forDisplayingModel:Story,containerSize:CGSize) -> CGSize {
        
        var text = ""
        var constrainedWidth = containerSize.width
        
        switch type {
            
        case .SectionName:
            
            text = forDisplayingModel.sections.first?.display_name ?? forDisplayingModel.sections.first?.name ?? ""
            
        case .Headline:
           
            text = forDisplayingModel.headline ?? ""
            
        case .SubHeadline:
            text = forDisplayingModel.subheadline ?? ""
            
        case .AuthorName:
            
            text = forDisplayingModel.author_name ?? ""
            constrainedWidth = getConstrainedWidth(type: TextComponentType.AuthorName, containerWidth: constrainedWidth)
            
        case .TimeStamp:
            text = forDisplayingModel.first_published_at?.convertTimeStampToDate ?? ""
            
        }
        
        let textSize = TTTAttributedLabel.sizeThatFitsAttributedString(NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: type.font]), withConstraints: CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 3)
        
        let size = CGSize(width: containerSize.width, height: textSize.height)
        
        return size
    }
    
    func getConstrainedWidth(type:TextComponentType,containerWidth:CGFloat) -> CGFloat {
        switch type {
        case .AuthorName:
            return containerWidth//- 100 - horizontalPagging
        default:
            return CGFloat.greatestFiniteMagnitude
        }
    }
  
}

enum TextComponentType {
    
    case SectionName
    case Headline
    case SubHeadline
    case AuthorName
    case TimeStamp
    
    var font:UIFont {
        switch self {
            
        case .SectionName:
            return FontService.shared.homeSectionFont
        case .Headline:
            return FontService.shared.homeHeadlineRegular
        case .SubHeadline:
            return FontService.shared.homeSubHeadlineRegular
        case .AuthorName:
            return FontService.shared.homeAuthorFont
        case .TimeStamp:
            return FontService.shared.homeTimestampFont
        default:
            return UIFont.systemFont(ofSize: 17)
        }
    }
    
    
}

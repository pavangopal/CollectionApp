//
//  HomeCellSizeCalculator.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/19/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

enum Component {
    
    case section
    case headline
    case subheadline
    case author
    case publishTime
    
}

class HomeCellSizeCalculator {
    
    static var maxNumberOfLines:UInt = 3
    static var reviewViewHeight:CGFloat = 20
    
    static var verticalPadding:CGFloat = 10
    static var horizontalPadding:CGFloat = 10
    
    static func calculatedHeightForImageStoryListCardCell(
        storyViewModel:StoryViewModel,
        targetWidth:CGFloat,
        cellType:HomeCellType) -> CGSize {
        
        let containerWidth =
            (cellType.imageTextAlignment == .Vertical) ?
            (targetWidth - (2*horizontalPadding)) :
            (targetWidth - cellType.imageWidth - (2*horizontalPadding))
        
        let targetSize = CGSize(width: containerWidth - 5, height: CGFloat.greatestFiniteMagnitude)
        
        var componentsHeight:CGFloat = 0
        
        let sectionHeight = TTTAttributedLabel.sizeThatFitsAttributedString(storyViewModel.sectionName, withConstraints: targetSize, limitedToNumberOfLines: maxNumberOfLines).height
        
        componentsHeight += sectionHeight
        
        let headlineHeight = TTTAttributedLabel.sizeThatFitsAttributedString(storyViewModel.headline, withConstraints: targetSize, limitedToNumberOfLines: maxNumberOfLines).height
        componentsHeight += headlineHeight
        
        if storyViewModel.storyTemplate == StoryTemplet.Review {
            componentsHeight += reviewViewHeight
        }
        
        let authorHeight = TTTAttributedLabel.sizeThatFitsAttributedString(storyViewModel.authorName, withConstraints: targetSize, limitedToNumberOfLines: maxNumberOfLines).height
        
        let timestampHeight = TTTAttributedLabel.sizeThatFitsAttributedString(storyViewModel.timeStamp, withConstraints: targetSize, limitedToNumberOfLines: maxNumberOfLines).height
        
        //- assumption : timestamp and author are horizontally aligned
        let authorTimeStampMaxHeight = max(timestampHeight, authorHeight)
        componentsHeight += authorTimeStampMaxHeight
        
        componentsHeight = componentsHeight + getVerticalTotalPadding(storyViewModel:storyViewModel)
        
        let  imageHeight = getImageHeightForWidth(cellType:cellType)
        
        if cellType.imageTextAlignment == .Vertical{
            componentsHeight += imageHeight
        }
        
        let newHeight = componentsHeight<imageHeight ? imageHeight : componentsHeight
        
        let size = CGSize(width: targetWidth, height: newHeight+5)
        
        return size
        
    }
    
    private static func getVerticalTotalPadding(storyViewModel:StoryViewModel) -> CGFloat {
        var totalVerticalPadding:CGFloat = 2*verticalPadding // top and bottom padding
        
        if let _ = storyViewModel.sectionName {
            totalVerticalPadding += verticalPadding
        }
        
        if let _ = storyViewModel.reviewRating{
            totalVerticalPadding += verticalPadding
        }
        
        if let _ = storyViewModel.authorName{
            totalVerticalPadding += verticalPadding
        }else if let _ = storyViewModel.timeStamp{
            totalVerticalPadding += verticalPadding
        }
        
        return totalVerticalPadding
    }
    
    private static func getImageHeightForWidth(cellType:HomeCellType) -> CGFloat {
        return (cellType.imageWidth * cellType.aspectRatio)
    }
}

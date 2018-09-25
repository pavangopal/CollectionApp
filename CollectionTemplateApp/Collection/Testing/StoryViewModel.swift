//
//  StoryViewModel.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

enum ImageTextAlignment{
    case Vertical
    case Horizontal
    case Cover
}

let imageAspectRatio:CGFloat = 9/16

class StoryViewModel {
    
    var sectionName:NSAttributedString?
    
    var headline:NSAttributedString?
    var subHeadline:NSAttributedString?
    
    var authorImageUrl:URL?
    var timeStamp:NSAttributedString?
    var authorName:NSAttributedString?
    
    var imageURl:URL?
    var backgroundColor:UIColor?
    
    var reviewRating:Double?
    var storyTemplate:StoryTemplet = StoryTemplet.Unknown
    
    public private(set) var preferredSize:CGSize = .zero
    
    init(story:Story,assocatedMetadata:AssociatedMetadata,cellType:HomeCellType,targetWidth:CGFloat) {
        
        generateStoryViewProperties(associatedMetaData: assocatedMetadata, story: story, cellType: cellType)
        preferredSize =  HomeCellSizeCalculator.calculatedHeightForImageStoryListCardCell(storyViewModel: self, targetWidth: targetWidth, cellType: cellType)
    }
    
}

extension StoryViewModel {
    
    private func generateStoryViewProperties(
        associatedMetaData:AssociatedMetadata,
        story:Story,cellType:HomeCellType) {
        
        self.storyTemplate = story.story_template ?? StoryTemplet.Unknown
        
        self.backgroundColor = getBackgroundColor(associatedMetadata: associatedMetaData)
        
        self.headline = getAttributtedString(text: story.headline, font: cellType.headlineFont,textColor: cellType.headlineColor)
        
        self.imageURl = getImageUrl(story: story, cellType: cellType)
        
        //based on associatedMetadata
        if associatedMetaData.show_author_name {
            self.authorName = getAttributtedString(text: story.author_name, font: cellType.authorFont,textColor: cellType.authorColor)
        }
        
        if associatedMetaData.show_section_tag{
            let sectionName = story.sections.first?.display_name ?? story.sections.first?.name
            self.sectionName = getAttributtedString(text: sectionName, font: cellType.sectionFont,textColor: cellType.sectionColor)
        }
        
        if associatedMetaData.show_time_of_publish{
            self.timeStamp = getAttributtedString(text: story.first_published_at?.convertTimeStampToDate, font: cellType.timestampFont,textColor: cellType.timestampColor)
        }
        
        if story.story_template == StoryTemplet.Review{
            self.reviewRating = story.storyMetadata?.review_rating?.value ?? 0.0
        }
    }
    
    private func getBackgroundColor(associatedMetadata:AssociatedMetadata) -> UIColor {
        if associatedMetadata.theme == .Dark{
            return ThemeService.shared.theme.primaryTextColor
        }else{
            return UIColor.white
        }
    }
    
    private func getAttributtedString(text:String?,font:UIFont,textColor:UIColor) -> NSAttributedString? {
        guard let text = text else{
            return nil
        }
        
        let headlineAttributes = generateAttributes(font: font,textColor:textColor)
        return NSAttributedString(string: text, attributes: headlineAttributes)
    }
    
    private func getImageUrl(story:Story,cellType:HomeCellType) -> URL? {
        guard let heroImageS3Key = story.hero_image_s3_key else{
            return nil
        }
        
        let imageSize = getImageSize(cellType: cellType)
        
        if imageSize.height == 0{
            return nil
        }
        
        let imageUrl = ImageManager.imageUrlFor(metaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, size: imageSize, imageQuality: ImageQuality.High)
        
        return imageUrl
    }
    
    private func getImageSize(cellType:HomeCellType)->CGSize{
        let height:CGFloat = (cellType.imageWidth * imageAspectRatio)
        
        let imageSize = CGSize(width: cellType.imageWidth, height: height)
        return imageSize
    }
    
    private func generateAttributes(font:UIFont,textColor:UIColor) -> [NSAttributedStringKey:NSObject] {
//        let textColor = getTextColor(theme: associatedMetaData.theme)
       
        return [NSAttributedStringKey.font: font,NSAttributedStringKey.foregroundColor: textColor]
    }
    
   private func getTextColor(theme:AssociatedMetadata.Theme) -> UIColor {
        if theme == .Dark{
            return UIColor.white
        }else{
            return ThemeService.shared.theme.primaryTextColor
        }
    }
}




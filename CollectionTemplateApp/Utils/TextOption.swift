//
//  FontOption.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 2/6/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import DTCoreText
import DTFoundation


public enum textOption {
    
    case headline(color:UIColor)
    case titleElement(color:UIColor)
    
    case summaryElement(color:UIColor)
    
    case textElement(color:UIColor)
    
    case imageElementText(color:UIColor)
    case imageElementAttribution(color:UIColor)
    
    case quoteElementText(color:UIColor)
    case quoteElementAttribution(color:UIColor)
    
    case blurbElementText(color:UIColor)
    
    case questionElement(color:UIColor)
    case answerElement(color:UIColor)
    
    case blockQuoteElement(color:UIColor)
    case blockQuoteAttributtion(color:UIColor)
    
    case alsoReadELement(color:UIColor)
    
    case bigFactText(color:UIColor)
    case bigFactAttributtion(color:UIColor)
    
    case explainerTitleText(color:UIColor)
    case explainerTitleIndexFont(color:UIColor)
    
    //Home-Pages
    
    case listCellElement(color:UIColor)
    case searchTitle(color:UIColor)
    case searchAuthorTimeStamp(crolor:UIColor)
    
    case authorBio(color:UIColor)
    case sponsoredSting(color:UIColor)
    
    case homeStoryHeadline(color:UIColor)
    case leftRightImageCellHeadlineFont(color:UIColor)
    case bigStoryReadSnapshotTextFont(color:UIColor)
    case bigStorySummaryTextFont(color:UIColor)
    
    var textAttributtes: [String : Any] {
        
        switch self {
            
        case .headline(let color):
            
            return self.storyElementStyle(font: FontService.shared.storyHeadlineFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .titleElement(let color):
            return self.storyElementStyle(font: FontService.shared.storyTitleElementFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .summaryElement(let color):
            
            return self.storyElementStyle(font: FontService.shared.storySummaryElementFont,color: color)
            
        case .textElement(let color):
            return self.storyElementStyle(font: FontService.shared.storyTextElementFont,color: color)
            
        case .imageElementText(let color):
            return self.storyElementStyle(font: FontService.shared.imageCaptionFont,color: color,textAlignment:CTTextAlignment.center.rawValue)
            
        case .imageElementAttribution(let color):
            return self.storyElementStyle(font: FontService.shared.imageAttributionFont,color: color,textAlignment:CTTextAlignment.center.rawValue)
            
        case .quoteElementText(let color):
            return self.storyElementStyle(font: FontService.shared.storyQuoteElementFont,color:color)
            
        case .quoteElementAttribution(let color):
            return self.storyElementStyle(font: FontService.shared.blockQuoteAttributionFont, color: color)
            
        case .blurbElementText(let color):
            return self.storyElementStyle(font: FontService.shared.storyBlurbElementFont, color: color)
            
        case .questionElement(let color):
            return self.storyElementStyle(font: FontService.shared.questionElementFont, color: color)
            
        case .answerElement(let color):
            return self.storyElementStyle(font: FontService.shared.answerElementFont, color: color)
            
        case .blockQuoteElement(let color):
            return self.storyElementStyle(font: FontService.shared.storyBlockQuoteElementFont, color: color)
            
        case .blockQuoteAttributtion(let color):
            return self.storyElementStyle(font: FontService.shared.blockQuoteAttributionFont, color: color)
            
        case .alsoReadELement(_):
            return self.storyElementStyle(font: FontService.shared.alsoReadElementFont, color: ThemeService.shared.theme.primaryLinkColor)
            
        case .bigFactText(let color):
            return self.storyElementStyle(font: FontService.shared.storyBigFactElementFont, color: color)
            
        case .bigFactAttributtion(let color):
            return self.storyElementStyle(font: FontService.shared.storyBigFactAttributtionFont, color: color)
            
        case .explainerTitleText(let color):
            return self.storyElementStyle(font: FontService.shared.explainerTitleElementFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .explainerTitleIndexFont(let color):
            return self.storyElementStyle(font: FontService.shared.explainerTitleIndexElementFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .listCellElement(let color):
            return self.storyElementStyle(font: FontService.shared.listCellStoryHeadlineFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .searchTitle(let color):
            return self.storyElementStyle(font: FontService.shared.searchScreenStoryTitleFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .searchAuthorTimeStamp(let color):
            return self.storyElementStyle(font: FontService.shared.searchScreenAuthorTimeStampFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .authorBio(let color):
            return self.storyElementStyle(font: FontService.shared.storyTextElementFont, color: color,textAlignment: CTTextAlignment.center.rawValue)
            
        case .sponsoredSting(let color):
            
            return self.storyElementStyle(font: FontService.shared.sponsoredTextFont, color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .homeStoryHeadline(let color):
            return self.storyElementStyle(font: FontService.shared.getCorrectedFont(fontName: FontFamilyName.CooperHewittSemibold.rawValue, size: 20), color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .leftRightImageCellHeadlineFont(let color):
            return self.storyElementStyle(font: FontService.shared.getCorrectedFont(fontName: FontFamilyName.CooperHewittSemibold.rawValue, size: 18), color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .bigStoryReadSnapshotTextFont(let color):
            return self.storyElementStyle(font: FontService.shared.getCorrectedFont(fontName: FontFamilyName.CooperHewittSemibold.rawValue, size: 14), color: color,textAlignment: CTTextAlignment.natural.rawValue)
            
        case .bigStorySummaryTextFont(let color):
            return self.storyElementStyle(font: FontService.shared.getCorrectedFont(fontName: FontFamilyName.CooperHewittSemibold.rawValue, size: 14), color: color,textAlignment: CTTextAlignment.center.rawValue)
        }
        
    }
    
    private func storyElementStyle(font:UIFont,color:UIColor = ThemeService.shared.theme.primaryTextColor,textAlignment:UInt8 = CTTextAlignment.natural.rawValue) -> [String:Any] {
        
        return  [
            DTUseiOS6Attributes:NSNumber.init(value: true),
            DTDefaultFontFamily:font.familyName,
            DTDefaultFontName:font.fontName,
            DTDefaultFontSize:font.pointSize,
            DTDefaultTextColor:color,
            DTDefaultLinkColor:ThemeService.shared.theme.primaryLinkColor,
            DTDefaultLinkDecoration:"#D9241C",
            DTDefaultLinkHighlightColor:ThemeService.shared.theme.primaryLinkHighlightColor,
            DTDefaultTextAlignment: NSNumber(value: textAlignment)
        ]
        
    }
    
}


//
//  StoryDetailLayout.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/30/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import Quintype
import DTCoreText
import TwitterKit

public enum storyDetailLayoutType : String{
    
    case StoryDetailHeaderImageCell = "StoryDetailHeaderImageCell"
    case StoryHeadlineCell = "StoryHeadlineCell"
    case AuthorElementCell = "AuthorElementCell"
    case StoryTextElementCell = "StoryTextElementCell"
    case StoryImageCell = "StoryImageCell"
    case StorySummaryCell = "StorySummaryCell"
    case TwitterCell = "TwitterCell"
    case AdvBlockCell = "AdvBlockCell"
    
    case YoutubeCell =  "YoutubeCell"
    case BlockQuoteCell = "BlockQuoteCell"
    case JSEmbedCell = "JSEmbedCell"
    case BlurbElementCell = "BlurbElementCell"
    case BigfactCell = "BigfactCell"
    case QuestionandAnswerCell = "QuestionandAnswerCell"
    case QuoteCell = "QuoteCell"
    case QuestionElementCell = "QuestionElementCell"
    case AnswerElementCell = "AnswerElementCell"
    case UrlEmbedCell = "UrlEmbedCell"
    case SocialShareCell = "SocialShareCell"
    case GalleryCell = "GalleryCell"
    case RatingCell = "RatingCell"
    case TitleElementCell = "TitleElementCell"
    case KeyEventCell = "KeyEventCell"
    case StoryCardsSorterCell = "StoryCardsSorterCell"
    case AlsoReadCell =  "AlsoReadCell"
    case ExplainerHeaderImageCell = "ExplainerHeaderImageCell"
    case ExplainerTitleCell = "ExplainerTitleCell"
    
    case storyTableElementCell = "storyTableElementCell"
    case BitGravityCell = "BitGravityCell"
    
    case ExplainerSummaryCell = "ExplainerSummaryCell"
    
    case BrightCoveCell = "BrightCoveCell"
    case CommentCell = "CommentCell"
    case StoryDetailsTagElementCell = "StoryDetailsTagElementCell"
}


class StoryDetailLayout {
    
    var layoutType:storyDetailLayoutType
    
    var storyElement:CardStoryElement?
    var card:Card?
    
    var isPinned:Bool = false
    var tweet:TWTRTweet?
    
    public init(layoutType:storyDetailLayoutType){
        
        self.layoutType = layoutType
        
    }
    
    public init(layoutType:storyDetailLayoutType,storyElement:CardStoryElement?){
        self.layoutType = layoutType
        self.storyElement = storyElement
        
    }
    public init(layoutType:storyDetailLayoutType,card:Card?){
        self.layoutType = layoutType
        self.card = card
    }
}

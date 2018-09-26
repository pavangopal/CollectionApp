//
//  LayoutEngine.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/27/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

struct LayoutEngine{
    
    var layoutEngineArray:[[StoryDetailLayout]] = []
    
    
    public mutating func makeLayouts(`for`templet:StoryTemplet? = StoryTemplet.Default,story:Story,completion:@escaping (_ layouts:[[StoryDetailLayout]]) -> Void){
        
        switch templet ?? .Default{
            
        case .LiveBlog:
            updateLiveBlogLayout(forSortingOrder: (story.storyMetadata?.is_closed ?? false) ? SortingOrder.Old : SortingOrder.New, story: story, completion: {_ in })
        case .Video:
            makeLayoutsForVideoTemplet(story: story)
        case .Default:
            makeLayoutForDefaultTemplet(story: story)
        case .Explainer:
            makeLayoutForExplainerSection(story:story)
        default:
            makeLayoutForDefaultTemplet(story: story)
        }
        
        if templet != StoryTemplet.LiveBlog{
//            self.insertAds(story: story, templet: templet)
        }
        
        
        completion(layoutEngineArray)
        
    }
    
    public mutating func insertAds(story:Story,templet:StoryTemplet? = StoryTemplet.Default) {
        
        if layoutEngineArray.count >= 1 && story.storyMetadata?.sponsored_by == nil{
            for (index,story) in layoutEngineArray[1].enumerated(){
                
                if (story.storyElement != nil) {
                    if layoutEngineArray[2].count >= index{
                        //adv after 1st card
                        if templet != StoryTemplet.Explainer && templet !=  StoryTemplet.LiveBlog{
                            layoutEngineArray[2].insert(StoryDetailLayout(layoutType: storyDetailLayoutType.AdvBlockCell), at: index )
                        }
                        if layoutEngineArray.count > 3 {
                            //last adv
                            layoutEngineArray.append([StoryDetailLayout(layoutType: storyDetailLayoutType.AdvBlockCell)])
                        }
                        layoutEngineArray[0].append(StoryDetailLayout(layoutType: storyDetailLayoutType.AdvBlockCell))
                        break
                    }
                }
                
            }
        }
    }
    
    public mutating func makeExplainerPreviewLayout(story:Story,completion:@escaping (_ layouts:[[StoryDetailLayout]]) -> Void){
        
        // dynamic cells
        
        var didMoveFirstSummaryElementToTop = false
        
        for (_,card) in story.cards.enumerated(){
            
            var sectionArray:[StoryDetailLayout] = []
            
            for (_,storyElement) in card.story_elements.enumerated(){
                
                if (storyElement.subtype == storySubType.summery.rawValue) && !didMoveFirstSummaryElementToTop{
                    //Skip the moved summary element
                    didMoveFirstSummaryElementToTop = true
                    continue
                }
                
                if let elementLayout = storyElementMapper(storyElement:storyElement){
                    sectionArray.append(elementLayout)
                }
            }
            
            if sectionArray.count > 0{
                layoutEngineArray.append(sectionArray)
            }
            
        }
        
        completion(layoutEngineArray)
    }
    
    public mutating func updateLiveBlogLayout(`forSortingOrder`:SortingOrder,story:Story,completion:@escaping (_ layouts:[[StoryDetailLayout]]) -> Void){
        
        switch forSortingOrder {
            
        case .New:
            
            let cardsWithDate = story.cards.filter({$0.card_added_at?.convertToDate != nil})
            let sortedCards = cardsWithDate.sorted(by: { (card1, card2) -> Bool in
                
                return (card1.card_added_at?.convertToDate?.compare((card2.card_added_at?.convertToDate)!) == .orderedDescending)
            })
            
            story.cards = sortedCards
            
            break
            
        case .Old:
            
            let cardsWithDate = story.cards.filter({$0.card_added_at?.convertToDate != nil})
            let sortedCards = cardsWithDate.sorted(by: { (card1, card2) -> Bool in
                return (card1.card_added_at?.convertToDate?.compare((card2.card_added_at?.convertToDate)!) == .orderedAscending)
            })
            
            story.cards = sortedCards
            
            break
        }
        
        makeLayoutForLiveBlog(story:story)
        
//        self.insertAds(story: story, templet: StoryTemplet.LiveBlog)
        
        completion(layoutEngineArray)
    }
    
    
    private mutating func makeLayoutForLiveBlog(story:Story){
        
        let topconstantCellArray:[storyDetailLayoutType] = (story.story_template?.staticCells[.Top])!
        let bottomStaticCellArray:[storyDetailLayoutType] = (story.story_template?.staticCells[.Bottom])!
        
        //Initial Top static cells
        var layoutArray:[StoryDetailLayout] = []
        
        for (_,cellType) in topconstantCellArray.enumerated(){
            
            layoutArray.append(StoryDetailLayout(layoutType: cellType))
            
        }
        
        layoutEngineArray.append(layoutArray)
        
        // dynamic cells
        var didMoveFirstSummaryElementToTop = false
        
        for (cardIndex,card) in story.cards.enumerated(){
            var sectionArray:[StoryDetailLayout] = []
            
            if cardIndex == 0{
                sectionArray.append(StoryDetailLayout(layoutType: .StoryCardsSorterCell))
            }
            
            // only one card can be pinned
            if !didMoveFirstSummaryElementToTop && (card.metadata?.metaAttributes?.is_pinned ?? false){
                
                didMoveFirstSummaryElementToTop = true
                
                self.movePinnedCardToTop(card: card)
                
                if sectionArray.count > 0{
                    layoutEngineArray.append(sectionArray)
                }
                continue
            }
            
            sectionArray.append(StoryDetailLayout(layoutType: .KeyEventCell, card: card))
            
            
            for (_,storyElement) in card.story_elements.enumerated(){
                
                
                //rest
                if let elementLayout = storyElementMapper(storyElement:storyElement){
                    sectionArray.append(elementLayout)
                }
            }
            
            if sectionArray.count > 0{
                layoutEngineArray.append(sectionArray)
            }
            
            
        }
        
        
        //Bottom static cells
        
        for (_,cell) in bottomStaticCellArray.enumerated(){
            var layoutArray:[StoryDetailLayout] = []
            
            layoutArray.append(StoryDetailLayout(layoutType: cell))
            layoutEngineArray.append(layoutArray)
        }
    }
    
    private mutating func movePinnedCardToTop(card:Card) {
        
        var cardLayoutWithSummeryElement:[StoryDetailLayout] = []
        
        let summaryLayoutWithCard = card.story_elements.filter({ (storyElement) -> Bool in
            if let elementLayout = storyElementMapper(storyElement:storyElement){
                elementLayout.isPinned = true
                cardLayoutWithSummeryElement.append(elementLayout)
                return true
            }else{
                return false
            }
        })
        
        if summaryLayoutWithCard.count > 0 && cardLayoutWithSummeryElement.count > 0 {
            layoutEngineArray.insert(cardLayoutWithSummeryElement, at: 1)
        }
    }
    
    private mutating func makeLayoutForDefaultTemplet(story:Story){
        
        let topconstantCellArray:[storyDetailLayoutType] = (story.story_template?.staticCells[.Top])!
        let bottomStaticCellArray:[storyDetailLayoutType] = (story.story_template?.staticCells[.Bottom])!
        
        var layoutArray:[StoryDetailLayout] = []
        
        //Initial static cells
        for (_,cellType) in topconstantCellArray.enumerated(){
            
            layoutArray.append(StoryDetailLayout(layoutType: cellType))
            
        }
        
        layoutEngineArray.append(layoutArray)
        
        // dynamic cells
        
        for (_,card) in story.cards.enumerated(){
            
            var sectionArray:[StoryDetailLayout] = []
            
            for (_,storyElement) in card.story_elements.enumerated(){
                
                if let elementLayout = storyElementMapper(storyElement:storyElement){
                    sectionArray.append(elementLayout)
                }
            }
            
            layoutEngineArray.append(sectionArray)
            
        }
        //Bottom static cells
        
        for (_,cell) in bottomStaticCellArray.enumerated(){
            var layoutArray:[StoryDetailLayout] = []
            
            layoutArray.append(StoryDetailLayout(layoutType: cell))
            layoutEngineArray.append(layoutArray)
        }
    }
    
    private mutating func makeLayoutForExplainerSection(story:Story){
        
        let topconstantCellArray:[storyDetailLayoutType] = [.ExplainerHeaderImageCell,.StoryHeadlineCell]//,.AuthorElementCell,.SocialShareCell]
        let bottomStaticCellArray:[storyDetailLayoutType] = (story.story_template?.staticCells[.Bottom])!
        
        var layoutArray:[StoryDetailLayout] = []
        
        //Initial static cells
        for (_,cellType) in topconstantCellArray.enumerated(){
            
            layoutArray.append(StoryDetailLayout(layoutType: cellType))
            
        }
        
        layoutEngineArray.append(layoutArray)
        
        // dynamic cells
        var didMoveFirstSummaryElementToTop = false
        var sectionArray:[StoryDetailLayout] = [StoryDetailLayout(layoutType: storyDetailLayoutType.ExplainerTitleCell)]
        
        for (_,card) in story.cards.enumerated(){
            for (_,storyElement) in card.story_elements.enumerated(){
                //find first summary element match
                
                if (storyElement.subtype == storySubType.summery.rawValue) && !didMoveFirstSummaryElementToTop{
                    
                    didMoveFirstSummaryElementToTop = true
                    
                    let summaryLayout = StoryDetailLayout(layoutType: storyDetailLayoutType.ExplainerSummaryCell, storyElement: storyElement)
                    
                    layoutEngineArray.insert([summaryLayout], at: 1)//insert as a section
                    
                    continue
                    
                }else if (storyElement.type == storyType.title.rawValue){
                    
                    sectionArray.append(StoryDetailLayout(layoutType: storyDetailLayoutType.ExplainerTitleCell, storyElement: storyElement))
                }
                
            }
        }
        
        layoutEngineArray.append(sectionArray)
        
        
        //Bottom static cells
        
        for (_,cell) in bottomStaticCellArray.enumerated(){
            var layoutArray:[StoryDetailLayout] = []
            
            layoutArray.append(StoryDetailLayout(layoutType: cell))
            layoutEngineArray.append(layoutArray)
        }
    }
    
    private mutating func makeLayoutsForVideoTemplet(story:Story){
        
        let topconstantCellArray:[storyDetailLayoutType] = (story.story_template?.staticCells[.Top])!
        let bottomStaticCellArray:[storyDetailLayoutType] = (story.story_template?.staticCells[.Bottom])!
        
        
        //Initial Top static cells
        
        var layoutArray:[StoryDetailLayout] = []
        
        
        for (_,cellType) in topconstantCellArray.enumerated(){
            
            layoutArray.append(StoryDetailLayout(layoutType: cellType))
            
        }
        
        layoutEngineArray.append(layoutArray)
        
        // dynamic cells
        var didMoveVideoElementToTop = false
        
        for (_,card) in story.cards.enumerated(){
            
            var sectionArray:[StoryDetailLayout] = []
            
            for (_,storyElement) in card.story_elements.enumerated(){
                //find first video match
                if (storyElement.type == storyType.video.rawValue || storyElement.type == storyType.youtubePlayer.rawValue || storyElement.subtype == storySubType.jwPlayer.rawValue || storyElement.subtype == storySubType.brightcoveVideo.rawValue) && !didMoveVideoElementToTop{
                    
                    didMoveVideoElementToTop = true
                    
                    if let videoLayout =  self.moveFirstVideoElement(storyElement: storyElement){
                        
                        layoutEngineArray[0].insert(videoLayout, at: 0)
                        
                    }
                    continue
                }
                
                //rest
                if let elementLayout = storyElementMapper(storyElement:storyElement){
                    sectionArray.append(elementLayout)
                }
            }
            
            layoutEngineArray.append(sectionArray)
            
        }
        
        //Bottom static cells
        
        for (_,cell) in bottomStaticCellArray.enumerated(){
            var layoutArray:[StoryDetailLayout] = []
            
            layoutArray.append(StoryDetailLayout(layoutType: cell))
            layoutEngineArray.append(layoutArray)
        }
        
    }
    
    private mutating func moveFirstVideoElement(storyElement:CardStoryElement) -> StoryDetailLayout?{
        
        var firstVideoLayout:StoryDetailLayout?
        
        switch storyElement.subtype{
            
        case storySubType.brightcoveVideo.rawValue?:
            
            firstVideoLayout = StoryDetailLayout(layoutType: storyDetailLayoutType.BrightCoveCell, storyElement: storyElement)
            
            break
            
        case nil:
            
            switch storyElement.type!{
                
            case storyType.youtubePlayer.rawValue:
                
                firstVideoLayout = StoryDetailLayout(layoutType: storyDetailLayoutType.YoutubeCell, storyElement: storyElement)
                
                
                break
                
                
            case storyType.video.rawValue:
                print("Story templet video and element type Video Not Handled")
                break
                
            default:
                break
            }
            
        default :
            break
        }
        
        return firstVideoLayout
        
    }
    
    
    
    private mutating func storyElementMapper(storyElement:CardStoryElement) -> StoryDetailLayout?{
        
        //        var sectionArray:[StoryDetailLayout] = []
        var storyElementLayout : StoryDetailLayout?
        for type in storyType.looper where type.rawValue == storyElement.type{
            
            
            switch storyElement.subtype{
                
            case storySubType.bigfact.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.BigfactCell,storyElement:storyElement)
                break
                
            case storySubType.blockquote.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.BlockQuoteCell,storyElement:storyElement)
                
            case storySubType.blurb.rawValue?:
                storyElementLayout =   createCell(cell: storyDetailLayoutType.BlurbElementCell,storyElement:storyElement)
                break
                
            case storySubType.imageGallery.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.GalleryCell,storyElement:storyElement)
                break
                
            case storySubType.instagram.rawValue?,storySubType.facebook_video.rawValue?,storySubType.facebook_post.rawValue?:
                
                storyElementLayout =  createCell(cell: storyDetailLayoutType.JSEmbedCell,storyElement:storyElement)
                break
                
            case storySubType.location.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.JSEmbedCell,storyElement:storyElement)
                break
                
            case storySubType.question.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.QuestionElementCell,storyElement:storyElement)
                break
                
            case storySubType.answer.rawValue?:
                storyElementLayout =   createCell(cell: storyDetailLayoutType.AnswerElementCell,storyElement:storyElement)
                break
                
            case storySubType.quote.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.QuoteCell,storyElement:storyElement)
                break
                
            case storySubType.summery.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.StorySummaryCell,storyElement:storyElement)
                break
                
            case storySubType.tweet.rawValue?:
                //                storyElementLayout =  createCell(cell: storyDetailLayoutType.JSEmbedCell,storyElement:storyElement)
                storyElementLayout =   createCell(cell: storyDetailLayoutType.TwitterCell,storyElement:storyElement)
                
                break
            case storySubType.q_and_a.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.QuestionandAnswerCell,storyElement:storyElement)
                
                
            case storySubType.alsoRead.rawValue?:
                storyElementLayout =  createCell(cell: storyDetailLayoutType.AlsoReadCell,storyElement:storyElement)
                
            case storySubType.table.rawValue?:
                
                storyElementLayout =  createCell(cell: storyDetailLayoutType.storyTableElementCell, storyElement: storyElement)
                
            case storySubType.bitgravityVideo.rawValue?:
                
                storyElementLayout =  createCell(cell: storyDetailLayoutType.BitGravityCell, storyElement: storyElement)
                
            case storySubType.brightcoveVideo.rawValue?:
                
                storyElementLayout =  createCell(cell: storyDetailLayoutType.BrightCoveCell, storyElement: storyElement)
                
            case nil:
                
                switch type.rawValue{
                case storyType.title.rawValue:
                    storyElementLayout =   createCell(cell: storyDetailLayoutType.TitleElementCell, storyElement: storyElement)
                case storyType.image.rawValue:
                    storyElementLayout =   createCell(cell: storyDetailLayoutType.StoryImageCell,storyElement:storyElement)
                    break
                    
                case storyType.soundCloud.rawValue:
                    storyElementLayout =   createCell(cell: storyDetailLayoutType.UrlEmbedCell, storyElement: storyElement)
                    break
                    
                case storyType.audio.rawValue:
                    
                    break
                case storyType.composite.rawValue:
                    storyElementLayout =   createCell(cell: storyDetailLayoutType.GalleryCell, storyElement: storyElement)
                    break
                    
                case storyType.externalFile.rawValue:
                    
                    break
                    
                case storyType.jsEmbed.rawValue:
                    storyElementLayout =  createCell(cell: storyDetailLayoutType.JSEmbedCell,storyElement:storyElement)
                    break
                case storyType.media.rawValue:
                    
                    break
                case storyType.pollType.rawValue:
                    
                    break
                case storyType.text.rawValue:
                    storyElementLayout =   createCell(cell: storyDetailLayoutType.StoryTextElementCell,storyElement:storyElement)
                    break
                    
                case storyType.video.rawValue:
                    
                    break
                    
                case storyType.youtubePlayer.rawValue:
                    storyElementLayout =  createCell(cell: storyDetailLayoutType.YoutubeCell,storyElement:storyElement)
                    
                    break
                    
                default:
                    print("Unknown Story-Type:\(storyElement.type ?? "or NIL")")
                    break
                }
                break
                
            default:
                
                if storyElement.type == storyType.jsEmbed.rawValue {
                    storyElementLayout =  createCell(cell: storyDetailLayoutType.JSEmbedCell,storyElement:storyElement)
                }else{
                    print("Unknown Story-SubType:\(storyElement.subtype ?? "or NIL")")
                }
                
                break
            }
            
        }
        
        return storyElementLayout
    }
    
    private  mutating func createCell(cell:storyDetailLayoutType,storyElement:CardStoryElement?) -> StoryDetailLayout{
        
        return StoryDetailLayout(layoutType: cell, storyElement: storyElement)
    }
    
    public func cancelLayoutPreparation(){
        
    }
}


extension StoryTemplet{
    
    fileprivate var staticCells:[StaticCellPosition:[storyDetailLayoutType]]{
        
        switch self {
            
        case .LiveBlog:
            
            return [StaticCellPosition.Top:StaticCells.topStoryDetailsCells,StaticCellPosition.Bottom:StaticCells.bottomStoryDetailsCells]
            
        case .Review:
            return [StaticCellPosition.Top:[.StoryDetailHeaderImageCell,.StoryHeadlineCell,.RatingCell],StaticCellPosition.Bottom:StaticCells.bottomStoryDetailsCells]
        case .Video:
            
            return [StaticCellPosition.Top:[.StoryHeadlineCell],StaticCellPosition.Bottom:StaticCells.bottomStoryDetailsCells]
            
        case .Default:
            
            return [StaticCellPosition.Top:StaticCells.topStoryDetailsCells,StaticCellPosition.Bottom:StaticCells.bottomStoryDetailsCells]
            
        default:
            return [StaticCellPosition.Top:StaticCells.topStoryDetailsCells,StaticCellPosition.Bottom:StaticCells.bottomStoryDetailsCells]
            
        }
    }
}

enum StaticCellPosition{
    case Top
    case Bottom
}

public struct StaticCells{
    
    static var topStoryDetailsCells:[storyDetailLayoutType] = [.StoryDetailHeaderImageCell,.StoryHeadlineCell]//,.AuthorElementCell]//,.SocialShareCell
    static var bottomStoryDetailsCells:[storyDetailLayoutType] = [.CommentCell]
    
}


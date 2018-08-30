//
//  CollectionLayoutEngine.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

class CollectionLayoutEngine {
    
    private var parentCollection : CollectionModel?
    
    private var sectionLayout:[[SectionLayout]] = []
    
    func makeLayout(collection:CollectionModel) -> [[SectionLayout]] {
        
        collection.items.forEach { (collectionItem) in
            let sectionLayoutArray = pickLayoutForTemplet(collectionItem: collectionItem)
            if sectionLayoutArray.count > 0{
                self.sectionLayout.append(sectionLayoutArray)
            }
        }
        
        return sectionLayout
    }
    
    private func pickLayoutForTemplet(collectionItem:CollectionItem) -> [SectionLayout] {
        
        let layout = collectionItem.associatedMetadata?.layout ?? ""
        let collectionTemplet = CollectionLayout(rawValue: layout) ?? .UNKNOWN
        
        
        switch collectionTemplet {
            
        case .FourColGrid:
           return  getFourColumGrid(collectionItem:collectionItem)
            
        case .FullscreenCarousel:
            return getCarouselLayout(for: HomeCellType.FullScreenCarouselCell, collectionItem: collectionItem)
            
        case .HalfImageSlider:
            return getCarouselLayout(for: HomeCellType.ImageTextCell, collectionItem: collectionItem)
            
        case .FullImageSlider:
            
            return getCarouselLayout(for: HomeCellType.FullImageSliderCell, collectionItem: collectionItem)
            
        case .FullscreenSimpleSlider:
            return getCarouselLayout(for: HomeCellType.SimpleSliderCell, collectionItem: collectionItem)
            
        case .TwoColOneAd:
            return getTwoColOneAd(collectionItem: collectionItem)
            
        case .ThreeCol:
            return getThreeColLayout(collectionItem: collectionItem)
            
        case .TwoCol:
            return getTwoColLayout(collectionItem:collectionItem)
            
        case .OneColStoryList:
            return getOneColStoryListLayout(collectionItem:collectionItem)
        default:
        
            return makeInnerLayout(collectionItem: collectionItem)
            
        }
        
    }
    
    func getOneColStoryListLayout(collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        if let innerCollection = collectionItem.collection,innerCollection.items.count > 0 {
            //collection title
            if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
                if let titleElement = getTitleLayout(collectionItem: collectionItem){
                    sectionLayoutArray.append(titleElement)
                }
            }
            
            let stories:[Story] = innerCollection.items.filter({$0.story != nil}).map({$0.story!})
            
            for (index,story) in stories.enumerated(){
                
                let sectionLayout =  SectionLayout(homeCellType: HomeCellType.ImageStoryListCell, story: story)
                let size = calculatedHeightForImageStoryListCell(story: story)
                let newHeight = size.height<100 ? 100 : size.height
                sectionLayout.size = CGSize(width: size.width, height: newHeight)
                sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                sectionLayoutArray.append(sectionLayout)
                
            }
            
        }
        return sectionLayoutArray
    }
    
    func getTwoColLayout(collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        if let innerCollection = collectionItem.collection,innerCollection.items.count > 0 {
            //collection title
            if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
                if let titleElement = getTitleLayout(collectionItem: collectionItem){
                    sectionLayoutArray.append(titleElement)
                }
            }
            
            let stories:[Story] = innerCollection.items.filter({$0.story != nil}).map({$0.story!})
            
            for (index,story) in stories.enumerated(){
                 if index == stories.count - 1 && index > 2{
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    sectionLayout.size = calculateHeight(story: story)
                    sectionLayoutArray.append(sectionLayout)
                 }else{
                    
                    let sectionLayout =  SectionLayout(homeCellType: HomeCellType.ImageStoryListCell, story: story)
                    let size = calculatedHeightForImageStoryListCell(story: story)
                    let newHeight = size.height<100 ? 100 : size.height
                    sectionLayout.size = CGSize(width: size.width, height: newHeight)
                    sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                    sectionLayoutArray.append(sectionLayout)
                }
                
            }
            
        }
        return sectionLayoutArray
    }
    
    func getThreeColLayout(collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        
        if let innerCollection = collectionItem.collection,innerCollection.items.count > 0 {
            //collection title
            if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
                if let titleElement = getTitleLayout(collectionItem: collectionItem){
                    sectionLayoutArray.append(titleElement)
                }
            }
            
            let stories:[Story] = innerCollection.items.filter({$0.story != nil}).map({$0.story!})
            
            for (index,story) in stories.enumerated(){
                if index == 0{
                    let sectionLayout = [SectionLayout(homeCellType: HomeCellType.FullImageSliderCell, story: story)]
                    sectionLayoutArray.append(contentsOf: sectionLayout)
                    
                }else if index == 1{

                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: story)
                    let size = calculateHeight(story: story)
                    sectionLayout.size = size
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else if index == 2{
                    
                    //TODO: needs to look like a card
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.StoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    sectionLayout.size = calculatedHeightForStoryListCell(story: story)
                    sectionLayoutArray.append(sectionLayout)
                
                }else{
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.StoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    sectionLayout.size = calculatedHeightForStoryListCell(story: story)
                    sectionLayoutArray.append(sectionLayout)
                }
            }
            
        }
        
        return  sectionLayoutArray
    }
    
    private func getCarouselLayout(`for` innerLayoutType:HomeCellType,collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        
        if let innerCollection = collectionItem.collection,innerCollection.items.count > 0 {
            //collection title
            if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
                if let titleElement = getTitleLayout(collectionItem: collectionItem){
                    sectionLayoutArray.append(titleElement)
                }
            }
            
            let stories:[Story] = innerCollection.items.filter({$0.story != nil}).map({$0.story!})
            
            let carouselModel = CarouselModel.init(layoutType: innerLayoutType, stories: stories, collectionName: innerCollection.name, estimatedInnerCellHeight: innerLayoutType.innerCellHeight)
            let sectionLayout = [SectionLayout(homeCellType: HomeCellType.CarousalContainerCell, carouselModel: carouselModel, associatedMetadata: collectionItem.associatedMetadata)]
            
            sectionLayoutArray.append(contentsOf: sectionLayout)
        }
        
        return  sectionLayoutArray
    }

    private func getFourColumGrid(collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        
        if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
            if let titleElement = getTitleLayout(collectionItem: collectionItem){
                sectionLayoutArray.append(titleElement)
            }
        }
        
        if let innerCollection = collectionItem.collection {
            
            let sectionLayout = innerCollection.items.filter({$0.story != nil}).map({SectionLayout(homeCellType: HomeCellType.FourColumnGridCell, story: $0.story!,associatedMetadata:collectionItem.associatedMetadata)})
            sectionLayoutArray.append(contentsOf: sectionLayout)
            
        }
        
        return sectionLayoutArray
    }
   
    private func getTwoColOneAd(collectionItem:CollectionItem) -> [SectionLayout] {
        
        var sectionedLayout:[SectionLayout] = []
        
        if let innerCollection = collectionItem.collection {
            
            if let titleLayout = getTitleLayout(collectionItem: collectionItem){
                self.makeSection(section: [titleLayout])
            }
            
            for (index,innerCollectinItem) in innerCollection.items.enumerated() {
                
                if index == 0 {
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.ImageTextCell, collectionItem: innerCollectinItem){
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }else{
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.ImageStoryListCell, collectionItem: innerCollectinItem){
                        let size = calculatedHeightForImageStoryListCell(story: collectionItem.story!)
                        let newHeight = size.height<100 ? 100 : size.height
                        sectionLayout.size = CGSize(width: size.width, height: newHeight)
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }
                
            }
            
        }else if let story = collectionItem.story {
            let sectionLayout = SectionLayout(homeCellType: HomeCellType.StoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
            sectionLayout.size = calculatedHeightForStoryListCell(story: story)
            sectionedLayout.append(sectionLayout)
        }
        
        return sectionedLayout
    }
    
    private func getTitleLayout(collectionItem:CollectionItem)->SectionLayout?{
        if let innerCollection = collectionItem.collection{
            return SectionLayout(homeCellType: HomeCellType.CollectionTitleCell, data: innerCollection.name ?? "")
        }
        return nil
    }
    
    private func makeInnerLayout(collectionItem:CollectionItem) -> [SectionLayout] {
        
        var sectionedLayout:[SectionLayout] = []
        
        if let innerCollection = collectionItem.collection {
            
            if let titleLayout = getTitleLayout(collectionItem: collectionItem){
                self.makeSection(section: [titleLayout])
            }
            
            for (index,innerCollectinItem) in innerCollection.items.enumerated(){
                
                if index == 0 {
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.ImageTextCell, collectionItem: innerCollectinItem){
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }else{
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.ImageTextCell, collectionItem: innerCollectinItem){
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }
                
            }
            
        }else if let story = collectionItem.story {
//            let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
//            let size = calculateHeight(story: story)
//            sectionLayout.size = size
//            sectionedLayout.append(sectionLayout)
            let sectionLayout =  SectionLayout(homeCellType: HomeCellType.ImageStoryListCell, story: story)
            let size = calculatedHeightForImageStoryListCell(story: story)
            let newHeight = size.height<100 ? 100 : size.height
            sectionLayout.size = CGSize(width: size.width, height: newHeight)
            sectionLayout.associatedMetaData = collectionItem.associatedMetadata
            sectionedLayout.append(sectionLayout)
        }
        
        return sectionedLayout
    }
    
    func makeStoryCellLayout(`for` type:HomeCellType,collectionItem:CollectionItem) -> SectionLayout?{
        if let innerCollectionItemStory = collectionItem.story {
            
            let sectionLayout = SectionLayout(homeCellType: type, story: innerCollectionItemStory)
            let size = calculateHeight(story: innerCollectionItemStory)
            sectionLayout.size = size
            return sectionLayout
            
        }
//        else if let innerCollectionItemCollection = collectionItem.collection {
//
//            let sectionLayout = SectionLayout(homeCellType: HomeCellType.DefaultCollectionCell, collection: innerCollectionItemCollection)
//            return sectionLayout
//        }
        
        return nil
    }
    
    
    func makeSection(section:[SectionLayout]){
        self.sectionLayout.append(section)
    }
    
    func calculateHeight(story:Story) -> CGSize {
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width-30, height: CGFloat.greatestFiniteMagnitude)
        
        let authorComponent = TextComponent(type: TextComponentType.AuthorName)
        let sectionComponent = TextComponent(type: TextComponentType.SectionName)
        let timeStampComponent = TextComponent(type: TextComponentType.TimeStamp)
        let textComponent = TextComponent(type: TextComponentType.Headline)
        
        let insetCorrectedSize = CGSize(width: targetSize.width - 20, height: targetSize.height)
        
        let sectionComponentSize = sectionComponent.preferredViewSize(forDisplayingModel:story, containerSize: insetCorrectedSize)
        let textComponentSize = textComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        let authorComponentSize = authorComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        let timeStampComponentSize = timeStampComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        
        let maxSize = max(timeStampComponentSize.height, authorComponentSize.height)
        let authorSize = CGSize(width: timeStampComponentSize.width, height: maxSize)
        
        let totalSize = sectionComponentSize + textComponentSize + authorSize
        return CGSize(width: targetSize.width, height: totalSize.height + 40 + 200 + 4 + 5)
        
    }
    
    func calculatedHeightForStoryListCell(story:Story) -> CGSize {
        let targetSize = CGSize(width: UIScreen.main.bounds.width-30, height: CGFloat.greatestFiniteMagnitude)
        
        let authorComponent = TextComponent(type: TextComponentType.AuthorName)
        let timeStampComponent = TextComponent(type: TextComponentType.TimeStamp)
        let sectionComponent = TextComponent(type: TextComponentType.SectionName)
        let textComponent = TextComponent(type: TextComponentType.Headline)
        
        let insetCorrectedSize = CGSize(width: targetSize.width - 20, height: targetSize.height)
        
        let sectionComponentSize = sectionComponent.preferredViewSize(forDisplayingModel:story, containerSize: insetCorrectedSize)
        let textComponentSize = textComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        let authorComponentSize = authorComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        let timeStampComponentSize = timeStampComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        
        let maxSize = max(timeStampComponentSize.height, authorComponentSize.height)
        let authorSize = CGSize(width: timeStampComponentSize.width, height: maxSize)
        let totalSize = sectionComponentSize + textComponentSize + authorSize
        return CGSize(width: targetSize.width, height: totalSize.height + 40 + 4 + 5)
        
    }
    
    func calculatedHeightForImageStoryListCell(story:Story) -> CGSize {
        let targetSize = CGSize(width: UIScreen.main.bounds.width-30-150, height: CGFloat.greatestFiniteMagnitude)
        
        let authorComponent = TextComponent(type: TextComponentType.AuthorName)
        let timeStampComponent = TextComponent(type: TextComponentType.TimeStamp)
        let sectionComponent = TextComponent(type: TextComponentType.SectionName)
        let textComponent = TextComponent(type: TextComponentType.Headline)
        
        let insetCorrectedSize = CGSize(width: targetSize.width - 20, height: targetSize.height)
        
        let sectionComponentSize = sectionComponent.preferredViewSize(forDisplayingModel:story, containerSize: insetCorrectedSize)
        let textComponentSize = textComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        let authorComponentSize = authorComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        let timeStampComponentSize = timeStampComponent.preferredViewSize(forDisplayingModel: story, containerSize: insetCorrectedSize)
        
        let maxSize = max(timeStampComponentSize.height, authorComponentSize.height)
        let authorSize = CGSize(width: timeStampComponentSize.width, height: maxSize)
        let totalSize = sectionComponentSize + textComponentSize + authorSize
        return CGSize(width: targetSize.width+150, height: totalSize.height + 40 + 4 + 5)
        
    }
}




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
    static var targetWidth = UIScreen.main.bounds.width - 30
    
    private var parentCollection : CollectionModel?
    
    private var sectionLayout:[[SectionLayout]] = []
    
    func makeLayout(collection:CollectionModel) -> [[SectionLayout]] {
        
        collection.items.forEach { (collectionItem) in
            let sectionLayoutArray = pickLayoutForTemplet(collectionItem: collectionItem)
            
            let layout = collectionItem.associatedMetadata?.layout ?? ""
            let collectionTemplet = CollectionLayout(rawValue: layout) ?? .UNKNOWN
            
            sectionLayoutArray.first?.collectionLayoutType = collectionTemplet
            
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
            return getFourColumGrid(collectionItem:collectionItem)
            
            
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
            
        case .FullscreenLinearGallerySlider:
            return getLinearGallerySliderCarouselLayout(for: HomeCellType.LinearGallerySliderCell, collectionItem: collectionItem)
            
        case .LShapeOneWidget:
            return getLShapeOneWidgetLayout(collectionItem: collectionItem)
            
        case .TwoColCarousel:
            return getTwoColCarouselLayout(collectionItem: collectionItem)
            
        case .TwoColHighlight:
            return getTwoColHighlightLayout(collectionItem: collectionItem)
            
        default:
            
            return makeInnerLayout(collectionItem: collectionItem)
            
        }
    }
    
    func getTwoColHighlightLayout(collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        
        if let innerCollection = collectionItem.collection,innerCollection.items.count > 0 {
            //collection title
            if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
                if let titleElement = getTitleLayout(collectionItem: collectionItem){
                    sectionLayoutArray.append(titleElement)
                }
            }
            
            let stories:[Story] = innerCollection.items.filter({$0.story != nil}).map({$0.story!})
            
            for (index,story) in stories.enumerated() {
                
                if index == 0{
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata!, cellType: HomeCellType.ImageTextCell)
                    
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else{
                    let sectionLayout =  SectionLayout(homeCellType: HomeCellType.ImageStoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: stories[index], associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageStoryListCell)
                    sectionLayout.storyViewModel = storyViewModel
                    
                    sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                    sectionLayoutArray.append(sectionLayout)
                }
            }
        }
        
        return  sectionLayoutArray
    }
    
    func getTwoColCarouselLayout(collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        
        if let innerCollection = collectionItem.collection,innerCollection.items.count > 0 {
            //collection title
            if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
                if let titleElement = getTitleLayout(collectionItem: collectionItem){
                    sectionLayoutArray.append(titleElement)
                }
            }
            
            let stories:[Story] = innerCollection.items.filter({$0.story != nil}).map({$0.story!})
            let carousalStories = Array<Story>(stories.prefix(3))
            
            let storyViewModelArray = carousalStories.map({createStoryViewModel(story: $0, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageTextCell)})
            
            let cellHeight = storyViewModelArray.map({$0.preferredSize}).max(by: {$1.height>$0.height})
            
            let carouselModel = CarouselModel(layoutType: HomeCellType.ImageTextCell,collectionName: innerCollection.name, estimatedInnerCellHeight: cellHeight?.height ?? 0, associatedMetaData: collectionItem.associatedMetadata,storyViewModel:storyViewModelArray)
            
            let sectionLayout = [SectionLayout(homeCellType: HomeCellType.CarousalContainerCell, carouselModel: carouselModel, associatedMetadata: collectionItem.associatedMetadata)]
            
            sectionLayoutArray.append(contentsOf: sectionLayout)
            
            for index in carousalStories.count..<stories.count {
                let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: stories[index],associatedMetadata:collectionItem.associatedMetadata)
                
                let storyViewModel = createStoryViewModel(story: stories[index], associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageTextCell)
                sectionLayout.storyViewModel = storyViewModel
                sectionLayoutArray.append(sectionLayout)
            }
        }
        
        return  sectionLayoutArray
    }
    
    func getLShapeOneWidgetLayout(collectionItem:CollectionItem) -> [SectionLayout] {
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
                if index == 0 {
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.FullImageSliderCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.FullImageSliderCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else {
                    
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)

                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata!, cellType: HomeCellType.ImageTextCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }
            }
            
        }
        
        return  sectionLayoutArray
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
            
            stories.forEach { (story) in
                let sectionLayout =  SectionLayout(homeCellType: HomeCellType.ImageStoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageStoryListCell)
                sectionLayout.storyViewModel = storyViewModel
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

            for (index,story) in stories.enumerated() {
                if index == stories.count - 1 && index > 2 {
                    //ImageTextDescriptionCell
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageTextCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(sectionLayout)
                }else{

                    let sectionLayout =  SectionLayout(homeCellType: HomeCellType.ImageStoryListCardCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageStoryListCardCell)
                    sectionLayout.storyViewModel = storyViewModel
                    
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
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.FullImageSliderCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.FullImageSliderCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else if index == 1{
                    
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.ImageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)

                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata!, cellType: HomeCellType.ImageTextCell)
                    
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else if index == 2{
                    
                    //TODO: needs to look like a card
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.StoryListCardCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.StoryListCardCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(sectionLayout)
                    
                }else{
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.StoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.StoryListCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(sectionLayout)
                }
            }
            
        }
        
        return  sectionLayoutArray
    }
    
    private func getLinearGallerySliderCarouselLayout(`for` innerLayoutType:HomeCellType,collectionItem:CollectionItem) -> [SectionLayout] {
        var sectionLayoutArray:[SectionLayout] = []
        
        if let innerCollection = collectionItem.collection,innerCollection.items.count > 0 {
            //collection title
            if (collectionItem.associatedMetadata?.show_collection_name ?? true) {
                if let titleElement = getTitleLayout(collectionItem: collectionItem){
                    sectionLayoutArray.append(titleElement)
                }
            }
            
            let stories:[Story] = innerCollection.items.filter({$0.story != nil}).map({$0.story!})
            
            let storyViewModelArray = stories.map({createStoryViewModel(story: $0, associatedMetadata: collectionItem.associatedMetadata, cellType: innerLayoutType)})
            
let cellHeight = storyViewModelArray.map({$0.preferredSize}).max(by: {$1.height>$0.height})
            let carouselModel = CarouselModel(layoutType: innerLayoutType, collectionName: innerCollection.name, estimatedInnerCellHeight: cellHeight?.height ?? 0, associatedMetaData: collectionItem.associatedMetadata,storyViewModel:storyViewModelArray)
            
            let sectionLayout = [SectionLayout(homeCellType: HomeCellType.LinerGalleryCarousalContainer, carouselModel: carouselModel, associatedMetadata: collectionItem.associatedMetadata)]
            
            sectionLayoutArray.append(contentsOf: sectionLayout)
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
            let storyViewModelArray = stories.map({createStoryViewModel(story: $0, associatedMetadata: collectionItem.associatedMetadata, cellType: innerLayoutType)})
            
            let cellHeight = storyViewModelArray.map({$0.preferredSize}).max(by: {$1.height>$0.height})

            let carouselModel = CarouselModel(layoutType: innerLayoutType, collectionName: innerCollection.name, estimatedInnerCellHeight: cellHeight?.height ?? 0, associatedMetaData: collectionItem.associatedMetadata,storyViewModel:storyViewModelArray)
            
            let sectionLayout = SectionLayout(homeCellType: HomeCellType.CarousalContainerCell, carouselModel: carouselModel, associatedMetadata: collectionItem.associatedMetadata)
            
            sectionLayoutArray.append(contentsOf: [sectionLayout])
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
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.ImageStoryListCardCell, collectionItem: innerCollectinItem){
                        let storyViewModel = createStoryViewModel(story: innerCollectinItem.story!, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageStoryListCardCell)
                        sectionLayout.storyViewModel = storyViewModel
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }
                
            }
            
        }else if let story = collectionItem.story {
            let sectionLayout = SectionLayout(homeCellType: HomeCellType.StoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
            let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.StoryListCell)
            sectionLayout.storyViewModel = storyViewModel
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
            
            let sectionLayout =  SectionLayout(homeCellType: HomeCellType.ImageStoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)

            let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.ImageStoryListCell)
            sectionLayout.storyViewModel = storyViewModel
            
            sectionLayout.associatedMetaData = collectionItem.associatedMetadata
            sectionedLayout.append(sectionLayout)
            
        }
        
        return sectionedLayout
    }
    
    func makeStoryCellLayout(`for` type:HomeCellType,collectionItem:CollectionItem) -> SectionLayout?{
        if let innerCollectionItemStory = collectionItem.story {
            
            let sectionLayout = SectionLayout(homeCellType: type, story: innerCollectionItemStory,associatedMetadata:collectionItem.associatedMetadata)

            let storyViewModel = createStoryViewModel(story: innerCollectionItemStory, associatedMetadata: collectionItem.associatedMetadata ?? AssociatedMetadata(), cellType: type)
            sectionLayout.storyViewModel = storyViewModel
            return sectionLayout
            
        }
        
        return nil
    }
    
    
    func makeSection(section:[SectionLayout]){
        self.sectionLayout.append(section)
    }
   private func createStoryViewModel(story: Story, associatedMetadata: AssociatedMetadata?, cellType: HomeCellType) -> StoryViewModel {
        
        return  StoryViewModel(story: story, assocatedMetadata: associatedMetadata ?? AssociatedMetadata(), cellType: cellType)
    }
}




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
    static let shared = CollectionLayoutEngine()
    private init(){}
    
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
    
    func makeLayout(stories:[Story]) -> [SectionLayout]{
        
        var sectionLayoutArray: [SectionLayout] = []
        let associatedMetadata = AssociatedMetadata()
        associatedMetadata.show_section_tag = true
        associatedMetadata.show_author_name = true
        
        stories.forEach { (story) in
            let sectionLayout = SectionLayout(homeCellType: HomeCellType.imageTextCell, story: story,associatedMetadata:associatedMetadata)
            
            let storyViewModel = createStoryViewModel(story: story, associatedMetadata: associatedMetadata, cellType: HomeCellType.imageTextCell)
            
            sectionLayout.storyViewModel = storyViewModel
            sectionLayoutArray.append(contentsOf: [sectionLayout])
        }
        
        return sectionLayoutArray
    }
    
    private func pickLayoutForTemplet(collectionItem:CollectionItem) -> [SectionLayout] {
        
        let layout = collectionItem.associatedMetadata?.layout ?? ""
        let collectionTemplet = CollectionLayout(rawValue: layout) ?? .UNKNOWN
        
        switch collectionTemplet {
            
        case .FourColGrid:
            return getFourColumGrid(collectionItem:collectionItem)
            
            
        case .HalfImageSlider:
            
            return getCarouselLayout(for: HomeCellType.imageTextCell, collectionItem: collectionItem)
            
        case .FullImageSlider:
            
            return getCarouselLayout(for: HomeCellType.fullImageSliderCell, collectionItem: collectionItem)
            
        case .FullscreenSimpleSlider:
            return getCarouselLayout(for: HomeCellType.simpleSliderCell, collectionItem: collectionItem)
            
        case .TwoColOneAd:
            return getTwoColOneAd(collectionItem: collectionItem)
            
        case .ThreeCol:
            return getThreeColLayout(collectionItem: collectionItem)
            
        case .TwoCol:
            return getTwoColLayout(collectionItem:collectionItem)
            
        case .OneColStoryList:
            return getOneColStoryListLayout(collectionItem:collectionItem)
            
        case .FullscreenLinearGallerySlider:
            return getLinearGallerySliderCarouselLayout(for: HomeCellType.linearGallerySliderCell, collectionItem: collectionItem)
            
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
    
    private func getTwoColHighlightLayout(collectionItem:CollectionItem) -> [SectionLayout] {
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
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.imageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata!, cellType: HomeCellType.imageTextCell)
                    
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else{
                    let sectionLayout =  SectionLayout(homeCellType: HomeCellType.imageStoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: stories[index], associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageStoryListCell)
                    sectionLayout.storyViewModel = storyViewModel
                    
                    sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                    sectionLayoutArray.append(sectionLayout)
                }
            }
        }
        
        return  sectionLayoutArray
    }
    
    private func getTwoColCarouselLayout(collectionItem:CollectionItem) -> [SectionLayout] {
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
            
            let storyViewModelArray = carousalStories.map({createStoryViewModel(story: $0, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageTextCell)})
            
            let cellHeight = storyViewModelArray.map({$0.preferredSize}).max(by: {$1.height>$0.height})
            
            let carouselModel = CarouselModel(layoutType: HomeCellType.imageTextCell,collectionName: innerCollection.name, estimatedInnerCellHeight: cellHeight?.height ?? 0, associatedMetaData: collectionItem.associatedMetadata,storyViewModel:storyViewModelArray)
            
            let sectionLayout = [SectionLayout(homeCellType: HomeCellType.carousalContainerCell, carouselModel: carouselModel, associatedMetadata: collectionItem.associatedMetadata)]
            
            sectionLayoutArray.append(contentsOf: sectionLayout)
            
            for index in carousalStories.count..<stories.count {
                let sectionLayout = SectionLayout(homeCellType: HomeCellType.imageTextCell, story: stories[index],associatedMetadata:collectionItem.associatedMetadata)
                
                let storyViewModel = createStoryViewModel(story: stories[index], associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageTextCell)
                sectionLayout.storyViewModel = storyViewModel
                sectionLayoutArray.append(sectionLayout)
            }
        }
        
        return  sectionLayoutArray
    }
    
    private  func getLShapeOneWidgetLayout(collectionItem:CollectionItem) -> [SectionLayout] {
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
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.fullImageSliderCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.fullImageSliderCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else {
                    
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.imageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata!, cellType: HomeCellType.imageTextCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }
            }
            
        }
        
        return  sectionLayoutArray
    }
    
    private  func getOneColStoryListLayout(collectionItem:CollectionItem) -> [SectionLayout] {
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
                let sectionLayout =  SectionLayout(homeCellType: HomeCellType.imageStoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageStoryListCell)
                sectionLayout.storyViewModel = storyViewModel
                sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                sectionLayoutArray.append(sectionLayout)
            }
        }
        return sectionLayoutArray
    }
    
    private  func getTwoColLayout(collectionItem:CollectionItem) -> [SectionLayout] {
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
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.imageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageTextCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(sectionLayout)
                }else{
                    
                    let sectionLayout =  SectionLayout(homeCellType: HomeCellType.imageStoryListCardCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageStoryListCardCell)
                    sectionLayout.storyViewModel = storyViewModel
                    
                    sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                    
                    sectionLayoutArray.append(sectionLayout)
                }
                
            }
        }
        return sectionLayoutArray
    }
    
    private func getThreeColLayout(collectionItem:CollectionItem) -> [SectionLayout] {
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
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.fullImageSliderCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.fullImageSliderCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else if index == 1{
                    
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.imageTextCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata!, cellType: HomeCellType.imageTextCell)
                    
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(contentsOf: [sectionLayout])
                    
                }else if index == 2{
                    
                    //TODO: needs to look like a card
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.storyListCardCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.storyListCardCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(sectionLayout)
                    
                }else{
                    let sectionLayout = SectionLayout(homeCellType: HomeCellType.storyListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
                    let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.storyListCell)
                    sectionLayout.storyViewModel = storyViewModel
                    sectionLayoutArray.append(sectionLayout)
                }
            }
            
        }
        
        return  sectionLayoutArray
    }
    
    private  func getLinearGallerySliderCarouselLayout(`for` innerLayoutType:HomeCellType,collectionItem:CollectionItem) -> [SectionLayout] {
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
            
            let sectionLayout = [SectionLayout(homeCellType: HomeCellType.linerGalleryCarousalContainer, carouselModel: carouselModel, associatedMetadata: collectionItem.associatedMetadata)]
            
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
            
            let sectionLayout = SectionLayout(homeCellType: HomeCellType.carousalContainerCell, carouselModel: carouselModel, associatedMetadata: collectionItem.associatedMetadata)
            
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
            
            let sectionLayout = innerCollection.items.filter({$0.story != nil}).map({SectionLayout(homeCellType: HomeCellType.fourColumnGridCell, story: $0.story!,associatedMetadata:collectionItem.associatedMetadata)})
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
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.imageTextCell, collectionItem: innerCollectinItem){
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }else{
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.imageStoryListCardCell, collectionItem: innerCollectinItem){
                        let storyViewModel = createStoryViewModel(story: innerCollectinItem.story!, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageStoryListCardCell)
                        sectionLayout.storyViewModel = storyViewModel
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }
                
            }
            
        }else if let story = collectionItem.story {
            let sectionLayout = SectionLayout(homeCellType: HomeCellType.storyListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
            let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.storyListCell)
            sectionLayout.storyViewModel = storyViewModel
            sectionedLayout.append(sectionLayout)
        }
        
        return sectionedLayout
    }
    
    private func getTitleLayout(collectionItem:CollectionItem)->SectionLayout?{
        if let innerCollection = collectionItem.collection{
            return SectionLayout(homeCellType: HomeCellType.collectionTitleCell, data: innerCollection.name ?? "")
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
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.imageTextCell, collectionItem: innerCollectinItem){
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }else{
                    if let sectionLayout = makeStoryCellLayout(for: HomeCellType.imageTextCell, collectionItem: innerCollectinItem){
                        sectionLayout.associatedMetaData = collectionItem.associatedMetadata
                        sectionedLayout.append(sectionLayout)
                    }
                    
                }
                
            }
            
        }else if let story = collectionItem.story {
            
            let sectionLayout =  SectionLayout(homeCellType: HomeCellType.imageStoryListCell, story: story,associatedMetadata:collectionItem.associatedMetadata)
            
            let storyViewModel = createStoryViewModel(story: story, associatedMetadata: collectionItem.associatedMetadata, cellType: HomeCellType.imageStoryListCell)
            sectionLayout.storyViewModel = storyViewModel
            
            sectionLayout.associatedMetaData = collectionItem.associatedMetadata
            sectionedLayout.append(sectionLayout)
            
        }
        
        return sectionedLayout
    }
    
    private func makeStoryCellLayout(`for` type:HomeCellType,collectionItem:CollectionItem) -> SectionLayout?{
        if let innerCollectionItemStory = collectionItem.story {
            
            let sectionLayout = SectionLayout(homeCellType: type, story: innerCollectionItemStory,associatedMetadata:collectionItem.associatedMetadata)
            
            let storyViewModel = createStoryViewModel(story: innerCollectionItemStory, associatedMetadata: collectionItem.associatedMetadata ?? AssociatedMetadata(), cellType: type)
            sectionLayout.storyViewModel = storyViewModel
            return sectionLayout
            
        }
        
        return nil
    }
    
    
    private func makeSection(section:[SectionLayout]){
        self.sectionLayout.append(section)
    }
    private func createStoryViewModel(story: Story, associatedMetadata: AssociatedMetadata?, cellType: HomeCellType) -> StoryViewModel {
        
        return  StoryViewModel(story: story, assocatedMetadata: associatedMetadata ?? AssociatedMetadata(), cellType: cellType)
    }
}




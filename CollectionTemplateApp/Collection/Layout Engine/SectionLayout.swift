//
//  HomeLayout.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

class SectionLayout {

    var homeCellType: HomeCellType
    
    var collection:CollectionModel?
    var story:Story?
    var collectionItem:CollectionItem?
    
    var storyArray:[Story]?
    
    var data:Any?
    
    var associatedMetaData:AssociatedMetadata?
    var carouselModel:CarouselModel?
    var size:CGSize = .zero
    
    var storyViewModel:StoryViewModel?
    
    var collectionLayoutType:CollectionLayout?
    
    public init(homeCellType:HomeCellType){
        self.homeCellType = homeCellType
        
    }
    
    public init(homeCellType:HomeCellType,data:Any){
        self.homeCellType = homeCellType
        self.data = data
    }
    
    public init(homeCellType:HomeCellType,collection:CollectionModel){
        self.homeCellType = homeCellType
        self.collection = collection
        
    }
    
    public init(homeCellType:HomeCellType,story:Story,associatedMetadata:AssociatedMetadata? ){
        self.associatedMetaData = associatedMetadata
        self.homeCellType = homeCellType
        self.story = story
    }
    
    public init(homeCellType:HomeCellType,collectionItem:CollectionItem){
        self.homeCellType = homeCellType
        self.collectionItem = collectionItem
    }
    
    public init(homeCellType:HomeCellType,storyArray:[Story],associatedMetadata:AssociatedMetadata? ){
        self.homeCellType = homeCellType
        self.storyArray = storyArray
        self.associatedMetaData = associatedMetadata
    }
    
    public init(homeCellType:HomeCellType,carouselModel:CarouselModel?,associatedMetadata:AssociatedMetadata?) {
        self.homeCellType = homeCellType
        self.carouselModel = carouselModel
        self.associatedMetaData = associatedMetadata
    }
}

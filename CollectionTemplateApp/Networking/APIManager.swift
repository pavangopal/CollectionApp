//
//  APIManager.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/27/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype
import DTCoreText
import CHCSVParser

protocol APIManagerDelegate:class {
    func engagmentLoaded()
    func shouldReload()
    
}
class APIManager{
    
    static let shared =  APIManager()
    
    private init(){}
    
    public var queue = OperationQueue()
    
    public weak var apiDelegate:APIManagerDelegate?
    
    func getStoryBySlug(controller:BaseController ,storySlug:String){
        
        DispatchQueue.main.async {
            controller.state = ViewState.loading
        }
        
        
        var cahceOption = cacheOption.cacheToDiskWithTime(min: 10)
        #if DEBUG
            cahceOption = .none
        #endif
        
        Quintype.api.getStoryFromSlug(slug: storySlug, cache: cahceOption, Success: { (story) in
            
            self.prepareRendarableStory(controller: controller, story: story)
            
        }) { (error) in
            
            controller.state = ViewState.error(message: "No Story :(")
        }
    }
    
    func getStoryById(controller:BaseController ,storyId:String){
        Quintype.api.getStoryFromId(storyId: storyId, cache: .none, Success: { (story) in
            
            self.prepareRendarableStory(controller: controller, story: story)
            
        }) { (error) in
            controller.state = ViewState.error(message: "No Story :(")
        }
    }
    
    func getTopStories(controller:BaseController,offset:Int){
        if offset == 0{
            DispatchQueue.main.async {
                controller.state = ViewState.loading
            }
        }
        
        Quintype.api.getStories(options: .topStories, fields: nil, offset: offset * 10, limit: 10, storyGroup: nil, cache: .none, Success: { (stories) in
            
            guard let unwrappedStories = stories , unwrappedStories.count > 0 else{
                controller.state = ViewState.error(message: "No Story :(")
                return
            }
            
            var searchResultArray:[SearchResult] = []
            
            for(_,singleSearchResult) in unwrappedStories.enumerated(){
                
                let search = SearchResult()
                search.imageLink = singleSearchResult.hero_image_s3_key
                search.headline = singleSearchResult.headline
                search.slug = singleSearchResult.slug
                search.imageMeta = singleSearchResult.hero_image_metadata
                searchResultArray.append(search)
            }
            
            controller.state = ViewState.loaded(data: searchResultArray)
            
        }) { (errorMessage) in
            
            controller.state = ViewState.error(message: errorMessage ?? "")
        }
    }
    
    
    private func getStoryEngagmentCount(storyId:String,story:Story){
        Quintype.api.getStoryEngagmentForStoryId(storyID: storyId, Success: { (engagement) in
            
            if engagement.engagmentCount > 999{
                
                story.engagment = engagement
                self.apiDelegate?.engagmentLoaded()
            }
            
        }) { (errorMessage) in
            print(errorMessage ?? "Error message is nil")
        }
    }
    
    public func getBulkEngagmentCount(storyIdArray:[String],storyArray:[Story],completion:@escaping ([String:Engagement])->()){
        
        Quintype.api.getBulkStoryEngagmentForStoryIdArray(storyIDArray: storyIdArray, Success: { (storyIdEngagmentDict) in
            print(storyIdEngagmentDict)
            completion(storyIdEngagmentDict)
        }) { (errorMessage) in
            print(errorMessage!)
            completion([:])
        }
    }
    
    
    private func prepareRendarableStory(controller:BaseController,story:Story?){
        
        self.queue.qualityOfService = .userInitiated
        self.queue.maxConcurrentOperationCount = Int.max
        
        guard let unwrappedStory = story else{
            controller.state = ViewState.error(message: "No Story :(")
            return
        }
        
        let operation1 = BlockOperation(block: {
            
//            let readTimeManager = ReadTimeManager()
            unwrappedStory.storyReadTime = "" //readTimeManager.getReadTimeInMinutes(story: unwrappedStory)
            
            StoryModifier.updateStoryTempletBasedOnMetaData(story: unwrappedStory)
            
        })
        
        var layout: StoryLayoutWrapper?
        
        let operation2 = BlockOperation(block: {
            var layoutEngine = LayoutEngine()
            
            layoutEngine.makeLayouts(for: unwrappedStory.story_template, story: unwrappedStory, completion: { (storyDetailLayout) in
                
                layout =  StoryLayoutWrapper(story: unwrappedStory, storyDetailLayout: storyDetailLayout)
                
                let flatLayout = layout!.storyDetailLayout.flatMap({$0})
                
                if flatLayout.contains(where: {$0.layoutType == storyDetailLayoutType.storyTableElementCell}){
                    StoryModifier.parseTableData(story: unwrappedStory)
                }
                
                //convert attributted text for elements
                StoryModifier.getDisplayText(storyDetailLayout: storyDetailLayout, story: unwrappedStory)
                
                StoryModifier.loadTwitterElements(storyDetailLayout: flatLayout, success: {
                    OperationQueue.main.addOperation {
                        self.apiDelegate?.shouldReload()
                    }
                })
            })
        })
        
        operation2.completionBlock = {
            print("completed")
            
            OperationQueue.main.addOperation({
                
                if !operation2.isCancelled{
                    if controller.viewIfLoaded?.window == nil {
                        // viewController is not visible
                        print("Content loaded for controller which is not visible")
                        controller.state = ViewState.loaded(data: "")
                        
                    }else{
                        controller.state = ViewState.loaded(data: layout)
                    }
                    
                }else{
                    print("Operation is cancelled")
                }
                
            })
            self.getStoryEngagmentCount(storyId: unwrappedStory.id!,story: unwrappedStory)
        }
        
        operation2.addDependency(operation1)
        self.queue.addOperations([operation1,operation2], waitUntilFinished: false)
        
    }
}

struct StoryLayoutWrapper {
    let story:Story
    let storyDetailLayout : [[StoryDetailLayout]]
}

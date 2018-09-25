//
//  AuthorApiManger.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/11/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype


protocol AuthorApiMangerDelegate: class {
    func didFetchAuthor(author:Author)
    func didFailWithError(error:String)
    func didFetchUserEngagment()
}


class AuthorApiManger{
    open static var bulkNecessaryFields:Array<String> = ["id","headline","slug","url","hero-image-s3-key","hero-image-metadata","first-published-at","last-published-at","alternative","published-at","author-name","author-id","sections","story-template","summary","metadata"]
    
    var limit = 20
    var offset = 0
    
     init(){}
    
     var apiDelegate:AuthorApiMangerDelegate?
    
    
    func getAuthorDetail(authorId:Int){
        
        Quintype.api.getAuthorDetails(authorId: "\(authorId)", Success: { (author) in
            print(author)
            self.apiDelegate?.didFetchAuthor(author: author)
        }) { (errorMessage) in
            print(errorMessage ?? "error")
            self.apiDelegate?.didFailWithError(error: errorMessage ?? "")
        }
    }
    
    
    func getStoriesForAuthor(authorId:Int,controller:BaseController){
        
        Quintype.api.search(searchBy: searchOption.authorId(authorId: "\(authorId)"),sortType: "latest-published", fields:AuthorApiManger.bulkNecessaryFields, offset: offset, limit: limit, cache: cacheOption.none, Success: { (data) in
            
            self.offset = self.limit + self.offset
            
            controller.state = ViewState.loaded(data: data?.stories)
            self.getUserEngagment(storyArray: data?.stories ?? [])
            
        }, Error: { (error) in
            
            controller.state = ViewState.error(message: error ?? "")
            
        })
    }
    
    func getUserEngagment(storyArray:[Story]){
        
//        DispatchQueue.global(qos: .background).async {
//            let userEngagmentManager = UserEngagmentApiManager()
//            
//            
//            let storyIdArray = storyArray.filter({$0.id != nil}).map({$0.id!})
//            
//            userEngagmentManager.getBulkEngagmentCount(storyIdArray: storyIdArray, completion: { (storyIdEngagmentDict) in
//                
//                for story in storyArray{
//                    innerLoop: for (storyId,engagment) in storyIdEngagmentDict{
//                        if story.id == storyId{
//                            story.engagment = engagment
//                            break innerLoop
//                        }
//                        
//                    }
//                    
//                }
//                
//                DispatchQueue.main.async {
//                    self.apiDelegate?.didFetchUserEngagment()
//                }
//                
//                
//            }) { (errorMessage) in
//                DispatchQueue.main.async {
//                    print(errorMessage)
//                }
//                
//            }
//        }
        
        
    }
}

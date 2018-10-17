//
//  NetworkManager.swift
//  CollectionTemplet
//
//  Created by Pavan Gopal on 7/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

class NetworkManager {
    
    let router = Router<CollectionApi>()
    
    private var page:Page
    private var limit = 5
    private var slug :String
    
    typealias CompletionHandler = (Success: (CollectionModel)->(),Error: (Error)->())
    
    var completion : CompletionHandler?
    
    init(storySlug:String,storyLimit:Int) {
        slug = storySlug
        limit = storyLimit
        page = Page(offsetPara: 0, limitPara: limit)
        
    }
    
    func getCollection() {
        return startFetch(slug: slug,limit:limit,offset: 0)
        
    }
    
    func startFetch(slug:String,limit:Int,offset:Int) {
        
        if  page.status == Page.PagingStatus.Paging ||
            page.status == Page.PagingStatus.LastPage
        {return}
        
        print("Page Number :: \((page.offset/page.limit)*1)")
        
        if page.status == Page.PagingStatus.Errored{
            page.minus()
        }
        
        page.status = Page.PagingStatus.Paging
        page.kick()
        
        self.router.request(.Single(slug: slug, limit: limit,offset:self.page.offset)) { data, response, error in
            
            if error != nil{
                self.completion?.Error(error!)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                
                switch result {
                    
                case .success:
                    
                    guard let responseData = data else {
                        return
                    }
                    
                    do {
                        let data = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        
                        if let jsonData = data as? [String:AnyObject] {
                            ApiParser.collectionParser(data: jsonData, completion: { (collection, error) in
                                
                                let collectionItemArray = collection.items.filter({$0.type == "collection"})
                                
                                self.recursiveBulkCall(numberOfLevel: 2, parentCollection: collection, collectionItems: collectionItemArray, completion: { (collectionModel) in
                                    
                                    if collection.items.count < limit{
                                        self.page.status = Page.PagingStatus.LastPage
                                    }else{
                                        self.page.status = Page.PagingStatus.NotPaging
                                    }
                                    
                                    self.completion?.Success(collectionModel)
                                    
                                },Error: { (error) in
                                    
                                    self.completion?.Error(error)
                                })
                                
                            })
                        }
                        
                    }catch {
                        self.page.status = Page.PagingStatus.Errored
                    }
                case .failure(let networkFailureError):
                    self.page.status = Page.PagingStatus.Errored
                    self.completion?.Error(NetworkError.Custom(message: networkFailureError))
                    
                    
                }
            }
        }
    }
    
    var childKeyparentKeyMapping:[String:String] = [:]
    
    func recursiveBulkCall(numberOfLevel:Int,parentCollection:CollectionModel,collectionItems:[CollectionItem],completion: @escaping (CollectionModel)->(),Error:((Error)->())?){
        
        if numberOfLevel == 0 || collectionItems.count == 0 {
            completion(parentCollection)
            return 
        }
        
        let slugArray = collectionItems.map({$0.slug!})
        
        PostBulkApiCall(slugArray: slugArray, limit: 5, Completion: { (stringCollectionModel) in
            
            
            var nestedCollectionItemArray:[CollectionItem] = []
            
            collectionItems.forEach({ (collectionItem) in
                
                //If collection is present in the nested Api call show the stories of that
                
                let collectionModel = stringCollectionModel[collectionItem.slug!]
                
                if collectionItem.collection?.items.first?.type == "collection"{
                    let innerCollectionModelItems = collectionModel?.items
                    collectionItem.collection?.items = innerCollectionModelItems ?? []
                    let parentKey = self.childKeyparentKeyMapping[collectionItem.slug!]
                    collectionItem.slug = parentKey
                    
                }else{
                  collectionItem.collection = collectionModel
                }
                
                if let innercollectionItem = collectionItem.collection!.items.first(where: {$0.type == "collection"}){
                    self.childKeyparentKeyMapping[innercollectionItem.slug!] = collectionItem.slug
                    
                    collectionItem.slug = innercollectionItem.slug
                    nestedCollectionItemArray.append(collectionItem)
                }
            })
            
            self.recursiveBulkCall(numberOfLevel: numberOfLevel-1,parentCollection: parentCollection, collectionItems: nestedCollectionItemArray, completion: completion, Error:nil)
            
        }) { (error) in
            Error?(error)
            return
        }
        
    }
    
    
    func PostBulkApiCall(slugArray:[String],limit:Int,Completion: @escaping ([String:CollectionModel])->(),Error: @escaping (Error)->()) {
        
        self.router.request(CollectionApi.BulkPost(slugArray: slugArray, limit: limit,itemType: ItemType.Story.rawValue)) { data, response, error in
            
            if error != nil{
                Error(NetworkError.NoInternet)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                
                switch result {
                    
                case .success:
                    
                    guard let responseData = data else {
                        Error(NetworkError.NoData)
                        return
                    }
                    
                    do {
                        let data = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        
                        if let jsonData = data as? [String:AnyObject] {
                            ApiParser.collectionBulkParser(data: jsonData, completion: { (collectionArray, error) in
                                Completion(collectionArray)
                            })
                        }else{
                            Error(NetworkError.ParsingError)
                        }
                        
                    }catch {
                        Error(NetworkError.ParsingError)
                    }
                case .failure(let networkFailureError):
                    Error(NetworkError.Custom(message: networkFailureError))
                }
            }
        }
    }
    
    func GetBulkApiCall(slugArray:[String],limit:Int,Completion: @escaping ([String:CollectionModel])->(),Error: @escaping (Error)->()) {
        
        self.router.request(CollectionApi.BulkGet(slugArray: slugArray, limit: limit)) { data, response, error in
            
            if error != nil{
                Error(NetworkError.NoInternet)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                
                switch result {
                    
                case .success:
                    
                    guard let responseData = data else {
                        Error(NetworkError.NoData)
                        return
                    }
                    
                    do {
                        let data = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        
                        if let jsonData = data as? [String:AnyObject] {
                            ApiParser.collectionBulkParser(data: jsonData, completion: { (collectionArray, error) in
                                Completion(collectionArray)
                            })
                        }else{
                            Error(NetworkError.ParsingError)
                        }
                        
                    }catch {
                        Error(NetworkError.ParsingError)
                    }
                case .failure(let networkFailureError):
                    Error(NetworkError.Custom(message: networkFailureError))
                }
            }
        }
    }
    
    public func next() {
        return self.startFetch(slug: self.slug, limit: limit,offset: page.offset)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    enum ItemType:String{
        case Story = "story"
        case Collection = "collection"
        case All = ""
    }
}


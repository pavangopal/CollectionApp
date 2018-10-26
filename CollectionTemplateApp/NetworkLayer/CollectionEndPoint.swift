//
//  CollectionEndPoint.swift
//  CollectionTemplet
//
//  Created by Pavan Gopal on 7/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

public enum CollectionApi{
    
    case BulkGet(slugArray:[String],limit:Int)
    case BulkPost(slugArray:[String],limit:Int,itemType:String)
    case Single(slug:String,limit:Int,offset:Int)
    
    
}

extension CollectionApi: EndPointType {
    
    var storyFields: String {
      return "id,hero-image-s3-key,sections,headline,subheadline,author-name,created-at,hero-image-caption,story-content-id,tags,hero-image-metadata,story-template,slug,metadata,first-published-at,authors"
    }
    
    var baseURL: URL {
        guard let url = URL(string: appConfig.baseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
            
        case .Single(let slug,_,_):
            return "/api/v1/collections/\(slug)"
            
        case .BulkGet(_,_):
            return "/api/v1/bulk/collection"
            
        case .BulkPost(_,_,_):
            return "/api/v1/bulk"
            
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .BulkPost(_,_,_):
            return .post
        default:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
            
        case .BulkGet(let slugArray,let limit):
            
            var urlParameters:[String:Any] = [:]
            var indexToUse = 0
            
            for slug in slugArray{
                indexToUse += 1
                let slugToUse = slug
                
                urlParameters["slug\(indexToUse)"] = slugToUse
                urlParameters["limit\(indexToUse)"] = "\(limit)"
            }
            
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
            
            
        case .BulkPost(let slugArray,let limit,let itemType):
            
            var bodyParameters:[String:Any] = [:]
            var outerDict: [String:[String:Any]] = [:]
            
            for slug in slugArray {
                var innerDict:[String:Any] = [:]
                
                innerDict = [
                            "_type":"collection",
                            "slug":slug,
                            "limit":limit,
                            "story-fields":storyFields,
                            "item-type":itemType
                          ]
                
                outerDict[slug] = innerDict
            }
            
            bodyParameters["requests"] = outerDict
            
            return .requestParametersAndHeaders(bodyParameters: bodyParameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: nil)
            
        case .Single(_,let limit,let offset):
            
            let urlParameters:[String:Any] = [
                                                "story-fields": storyFields,
                                                "limit":limit,
                                                "offset":offset
                                             ]
            
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}







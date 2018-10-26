//
//  TagApiManager.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

protocol TagApiManagerDelegate:class {
    func didLoadData(stories:[Story])
    func didFailWithError(error:String?)
}

class TagApiManager {
    
    private var tagSlug:String
    private var limit:Int = 10
    private var offset:Int = 0
    private var page:Page
    weak var delegate:TagApiManagerDelegate?
    
    init(slug:String,offset:Int = 0,limit:Int = 10,delegate:TagApiManagerDelegate){
        self.tagSlug = slug
        page = Page(offsetPara: offset, limitPara: limit)
        self.delegate = delegate
    }
    
    public func startFetch() {
        
        
        if  page.status == Page.PagingStatus.Paging
//            || page.status == Page.PagingStatus.LastPage
        {return}
        
        
        if page.status == Page.PagingStatus.Errored{
            page.minus()
        }
        
        page.status = Page.PagingStatus.Paging
        page.kick()
        
        let apiOption = storiesOption.tag(tagName: self.tagSlug)
        
        Quintype.api.getStories(options: apiOption, fields: nil, offset: page.offset, limit: page.limit, storyGroup: nil, cache: cacheOption.none, Success: { [weak self] (storyCollection) in
            
            guard let stories = storyCollection,let strongSelf = self else{return}
            
            if stories.count < strongSelf.page.limit {
                strongSelf.page.status = Page.PagingStatus.LastPage
            }else{
                strongSelf.page.status = Page.PagingStatus.NotPaging
            }
            
            strongSelf.delegate?.didLoadData(stories: stories)
            
            }, Error: { [weak self](error) in
                guard let strongSelf = self else{return}
                strongSelf.page.status = Page.PagingStatus.Errored
                strongSelf.delegate?.didFailWithError(error: error)
        })
    }
    
    public func next() {
        startFetch()
    }
}


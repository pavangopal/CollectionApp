//
//  TagViewModel.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

protocol TagViewModelling:class {
    init(tagSlug:String)
    func startFetch()
    func loadNext()
}

class TagViewModel : TagViewModelling {
    
    private var tagApiManager:TagApiManager?
    
    var isMoreDataAvailable = Dynamic<Bool>(nil)
    
    var state:Dynamic<ViewState<Any>> =  Dynamic<ViewState<Any>>(ViewState.loading)
    
    required init(tagSlug:String) {
        
        tagApiManager = TagApiManager(slug: tagSlug, delegate: self)
        
    }
    
    func startFetch(){
        tagApiManager?.startFetch()
    }
    
    func loadNext(){
        tagApiManager?.next()
    }
    
}

//MARK: - Protocol conformance
extension TagViewModel: TagApiManagerDelegate {
    
    func didLoadData(stories: [Story]) {

        if stories.count > 0 {
            isMoreDataAvailable.value = true
            
            let layout = CollectionLayoutEngine.shared.makeLayout(stories: stories)
            state.value = ViewState.loaded(data: layout)
        }else{
            isMoreDataAvailable.value = false
        }
    }
    
    func didFailWithError(error: String?) {
        if let error = error {
            state.value = ViewState.error(message: error)
        }
    }
}




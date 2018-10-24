//
//  TagViewModel.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

protocol ListViewModelModelling:class {
    init(slug:String)
    func startFetch()
    func loadNext()
}

class TagViewModel : ListViewModelModelling {
    
    private var tagApiManager:TagApiManager?
    
    var isMoreDataAvailable = Dynamic<Bool>(nil)
    
    var state:Dynamic<ViewState<Any>> =  Dynamic<ViewState<Any>>(ViewState.loading)
    
    required init(slug:String) {
        
        tagApiManager = TagApiManager(slug: slug, delegate: self)
        
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
        
        isMoreDataAvailable.value = stories.count > 0
        let layoutEngine = CollectionLayoutEngine()
        let layout = layoutEngine.makeLayout(stories: stories)
        state.value = ViewState.loaded(data: layout)
    }
    
    func didFailWithError(error: String?) {
        if let error = error {
            state.value = ViewState.error(message: error)
        }
    }
}




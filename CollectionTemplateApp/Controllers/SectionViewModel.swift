//
//  SectionViewModel.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/17/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

class SectionViewModel: ListViewModelModelling{
    private var apiManager:CollectionApiManager?
    
    var isMoreDataAvailable = Dynamic<Bool>(nil)
    
    var state:Dynamic<ViewState<Any>> =  Dynamic<ViewState<Any>>(ViewState.loading)
    
    required init(slug:String){
        apiManager = CollectionApiManager(slug: slug, limit: 5, delegate: self)
    }
    
    func startFetch(){
        apiManager?.startFetch()
        
    }
    func loadNext(){
        apiManager?.fetchNextPage()
    }
}

extension SectionViewModel : CollectionApiManagerDelegate {
    
    func didRecieveData(collectionModel: CollectionModel) {
        
        self.isMoreDataAvailable.value = collectionModel.items.count > 0
        let layoutArray = CollectionLayoutEngine.shared.makeLayout(collection: collectionModel)
        state.value = ViewState.loaded(data: layoutArray)
        
    }
    
    func didRecieveError(error: Error) {
        state.value = ViewState.error(message: error.localizedDescription)
    }
}

/*
 protocol SectionApiManagerDelegate:class {
 associatedtype Data
 func didLoadData(data:Data)
 func didfailWithError(error:String)
 }
 
 
 extension SectionViewModel : SectionApiManagerDelegate {
 
 typealias Data = CollectionModel
 
 func didLoadData(data: CollectionModel) {
 if data.items.count > 0{
 self.isMoreDataAvailable.value = true
 let layoutArray = CollectionLayoutEngine.shared.makeLayout(collection: data)
 state.value = ViewState.loaded(data: layoutArray)
 }else{
 isMoreDataAvailable.value = false
 }
 }
 
 func didfailWithError(error: String) {
 state.value = ViewState.error(message: error)
 }
 }
 */

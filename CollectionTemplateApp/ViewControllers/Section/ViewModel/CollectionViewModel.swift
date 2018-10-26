//
//  CollectionViewModel.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

protocol CollectionViewModelDelegate : class {
    func didRecieveData(sectionLayoutArray:[[SectionLayout]])
}

class CollectionViewModel {
    
    private var apiManager:CollectionApiManager?
    private weak var delegate:CollectionViewModelDelegate?
    
//    private var sectionLayoutArray:[[SectionLayout]] = []
    
    init(slug:String,delegate:CollectionViewModelDelegate) {
        
        apiManager = CollectionApiManager(slug: slug, limit: 5, delegate: self)
        
        self.delegate = delegate
    }
    
    func startFetch(){
        apiManager?.startFetch()
    }
    
    func loadNext(){
        apiManager?.fetchNextPage()
    }
    
    
}

extension CollectionViewModel: CollectionApiManagerDelegate{
    
    func didRecieveData(collectionModel: CollectionModel) {
        DispatchQueue.global(qos: .default).async {
            let layoutEngine = CollectionLayoutEngine()
            let layoutArray = layoutEngine.makeLayout(collection: collectionModel)
            DispatchQueue.main.async {
                self.delegate?.didRecieveData(sectionLayoutArray: layoutArray)
            }
        }
    }
    
    func didRecieveError(error: Error) {
        print(error)
    }
    
    
}

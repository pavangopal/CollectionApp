//
//  CollectionApiManager.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

protocol CollectionApiManagerDelegate: class {
    func didRecieveData(collectionModel:CollectionModel)
    func didRecieveError(error:Error)
}

final class CollectionApiManager {
    
    private var slug : String
    private var limit : Int
    private weak var delegate : CollectionApiManagerDelegate?
    
    private var networkManager: NetworkManager
    
    init(slug:String,limit:Int, delegate:CollectionApiManagerDelegate ) {
        self.slug = slug
        self.limit = limit
        self.delegate = delegate
        self.networkManager = NetworkManager(storySlug: slug, storyLimit: limit)
    }
    
    public func startFetch(){
        self.configureCompletionHandler()
        self.networkManager.getCollection()
    }
    
    private func configureCompletionHandler(){
        
        self.networkManager.completion = (Success: { [weak self](collectionModel) in
            guard let selfD = self else{return}
            
            DispatchQueue.main.async {
                selfD.delegate?.didRecieveData(collectionModel: collectionModel)
            }
            
            
        },  Error: { error in
            
            if let errorD = error as? NetworkError{
                print("Error Message: \(errorD.errorMessage)")
                DispatchQueue.main.async {
                    self.delegate?.didRecieveError(error: errorD)
                }
                
            }
        })
    }
    
   public func fetchNextPage(){
        networkManager.next()
    }
    
    public func reset(){
        self.networkManager = NetworkManager(storySlug: slug, storyLimit: limit)
    }
}

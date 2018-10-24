//
//  DataStore.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/29/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation

class DataLoadOperation:Operation{
    
    var dataSource :StoryDetailDataSourceAndDelegate?
    var loadingCompleteHandler: ((StoryDetailDataSourceAndDelegate) -> ())?
    
    private let _dataSource:StoryDetailDataSourceAndDelegate
    
    init(_ dataSource:StoryDetailDataSourceAndDelegate){
        _dataSource = dataSource
    }
    
    override func main() {
        if isCancelled { return }
        self.dataSource = _dataSource
        
        if let loadingCompletion = loadingCompleteHandler {
            DispatchQueue.main.async {
                loadingCompletion(self._dataSource)
            }
        }
    }
}

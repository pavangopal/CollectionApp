//
//  Dynamic.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

protocol Observer{
    associatedtype T
    var bind :(T) -> () {get set}
}

class Dynamic<T>:Observer {
    var bind: (T) -> () = {_ in}
    
    var value :T? {
        didSet {
            if let value = value{
                bind(value)
            }      
        }
    }
    
    init(_ v :T?) {
        value = v
      
    }
    
}

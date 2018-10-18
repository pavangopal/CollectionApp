//
//  NavigationRouter.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/17/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

enum RouteType {
    case StoryDetailScreen
    case TagScreen
    case AuthorScreen
    case SectionScreen
}

public typealias ModuleParameters = [String: String]

protocol ModelType {
    var route:RouteType {get}
    
    init(route:RouteType)
    
    func openModule(parameters:ModuleParameters?)
    
    
}



class NavigationRouter : ModelType {
    var route: RouteType
    
    required init(route: RouteType) {
        self.route = route
    }
    
    func openModule(parameters: ModuleParameters?) {
        
    }
}

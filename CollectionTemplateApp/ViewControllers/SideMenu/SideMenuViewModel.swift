//
//  SideMenuViewModel.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/29/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

class SideMenuViewModel {
    
    var parentMenu:Menu?
    var subMenus:[Menu] = []
    var isCollapsed:Bool = true
    
    init(parentMenu:Menu,subMenus:[Menu]) {
        self.parentMenu = parentMenu
        self.subMenus = subMenus
    }
    
}

enum MenuItemType : String {
    case Section
    case Link
    case Tag
    case PlaceHolder
}

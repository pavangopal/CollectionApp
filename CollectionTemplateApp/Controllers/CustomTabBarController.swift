//
//  CustomTabBarController.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/13/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var navigationControllerContainer:[UINavigationController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabController = HomeController(slug: "home")//HomeContainerController(singleMenu:newMenu)
        let homeNavigationController = UINavigationController(rootViewController: tabController)
        
        
        navigationControllerContainer.append(homeNavigationController)
        viewControllers = navigationControllerContainer
        
        tabBar.clipsToBounds = true
    }


}

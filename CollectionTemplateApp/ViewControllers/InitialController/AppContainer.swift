//
//  AppContainer.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/31/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit

class AppContainer: UIViewController {

    var tabbarController: CustomTabBarController!
    var menuController: MenuController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTabbarController()
    }

    func prepareTabbarController(){
        tabbarController = CustomTabBarController()
        let navigationController = UINavigationController(rootViewController: tabbarController)
        navigationController.navigationBar.isHidden = true
        addViewController(anyController: navigationController)
    }
}

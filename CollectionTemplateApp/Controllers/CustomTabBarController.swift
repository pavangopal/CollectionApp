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

        setUpTabbar()
        
    }
    
    func setUpTabbar() {
        let tabbarItems = [TabbarItems.Home,TabbarItems.Settings]
        
        tabbarItems.forEach { (item) in
            switch item{
                
            case .Home:
                let homeController = SectionController(slug: "home")
                let homeNavigationController = UINavigationController(rootViewController: homeController)
                homeNavigationController.navigationBar.isHidden = true
                homeController.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                
                navigationControllerContainer.append(homeNavigationController)
                
            case .Settings:
                let settingVC = SettingsController()
                let settingNVC = UINavigationController(rootViewController: settingVC)
                settingNVC.title = item.rawValue
                settingVC.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                navigationControllerContainer.append(settingNVC)
                
            }
        }
        
        viewControllers = navigationControllerContainer
        tabBar.clipsToBounds = true
    }

}

enum TabbarItems:String{
    
    case Home = "Home"
    case Settings = "Settings"
    
    var icon:UIImage{
        switch self{
        case .Home:
            return AssetImage.homeIcon.image
        case .Settings:
            return AssetImage.settingIcon.image
        }
    }
}

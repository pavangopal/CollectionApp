//
//  CustomTabBarController.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/13/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class CustomTabBarController: UITabBarController {
    
    var navigationControllerContainer:[UINavigationController] = []
    let menuArray = Quintype.publisherConfig?.layout?.menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabbar()
        
    }
    
    func setUpTabbar() {
       
        let tabbarItems = [TabbarItems.Home,TabbarItems.Settings]//,.menu]
        
        tabbarItems.forEach { (item) in
            switch item {
                
            case .Home:
                
                var validSectionArray = menuArray?.filter({$0.section_slug != nil})
                
                let homeMenu = self.createHomeMenu()
                
                if (validSectionArray?.count ?? 0) > 0{
                    validSectionArray?.insert(homeMenu, at: 0)
                }
                
                let homeController = HomeController(menuArray: [homeMenu])
                let homeNavigationController = UINavigationController(rootViewController: homeController)
                homeNavigationController.navigationBar.isHidden = true
                homeController.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                homeController.navigationBar.setNavigationItems()
                self.navigationControllerContainer.append(homeNavigationController)
                
//                let homeController = SectionController(slug: "home")
//                let homeNavigationController = UINavigationController(rootViewController: homeController)
//                homeNavigationController.navigationBar.isHidden = true
//                homeController.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
//
//                navigationControllerContainer.append(homeNavigationController)
                
            case .Settings:
                let settingVC = SettingsController()
                let settingNVC = UINavigationController(rootViewController: settingVC)
                
                settingNVC.title = item.rawValue
                settingVC.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                navigationControllerContainer.append(settingNVC)
                
            case .menu:
                
                let sideMenuVC = MenuController(menu: menuArray ?? [])
                let sideMenuNVC = UINavigationController(rootViewController: sideMenuVC)
                
                sideMenuNVC.title = item.rawValue
                sideMenuVC.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                navigationControllerContainer.append(sideMenuNVC)
            }
        }
        
        viewControllers = navigationControllerContainer
        tabBar.clipsToBounds = true
    }
    
    func createHomeMenu() -> Menu {
        
        let homeMenu = Menu()
        
        homeMenu.section_slug = "home"
        homeMenu.section_name = "Home"
        homeMenu.title = "Home"
        
        return homeMenu
    }
}

enum TabbarItems:String{
    
    case Home = "Home"
    case Settings = "Settings"
    case menu = "menu"
    
    var icon:UIImage{
        switch self{
        case .Home:
            return AssetImage.homeIcon.image
        case .Settings:
            return AssetImage.settingIcon.image
        case .menu:
            return AssetImage.settingIcon.image
        
        }
    }
}

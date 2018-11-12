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
//        self.tabBar.isTranslucent = false
    }
    
    func setUpTabbar() {
       
        let tabbarItems:[TabbarItems] = [.Home,.Settings]//,.menu]
        
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
                homeController.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                self.navigationControllerContainer.append(homeNavigationController)
                
            case .Settings:
                let settingVC = SettingsController()
                let settingNVC = UINavigationController(rootViewController: settingVC)
                
                settingNVC.title = item.rawValue
                settingVC.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                navigationControllerContainer.append(settingNVC)
                
            case .Menu:
                
                let sideMenuVC = MenuController(menu: menuArray ?? [])
                let sideMenuNVC = UINavigationController(rootViewController: sideMenuVC)
                
                sideMenuNVC.title = item.rawValue
                sideMenuVC.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                navigationControllerContainer.append(sideMenuNVC)
                
            case .Search:
                let searchController = SearchController()
                let searchNC = UINavigationController(rootViewController: searchController)
                searchNC.title = item.rawValue
                searchNC.tabBarItem = UITabBarItem(title: item.rawValue, image: item.icon, tag: item.hashValue)
                navigationControllerContainer.append(searchNC)
                
            case .More:
                
                break
            }
        }
        
        viewControllers = navigationControllerContainer
        
        self.navigationControllerContainer.forEach { (navigation) in
            navigation.navigationBar.isTranslucent = false
            navigation.navigationBar.barTintColor = ThemeService.shared.theme.primarySectionColor
            navigation.navigationBar.tintColor = .white
        }
        
        tabBar.clipsToBounds = true
        tabBar.barTintColor = ThemeService.shared.theme.primarySectionColor
        tabBar.tintColor = ThemeService.shared.theme.tintColor
//        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .white
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
    case Menu = "Menu"
    case Search = "search"
    case More = "more"
    
    var icon:UIImage{
        switch self{
        case .Home:
            return AssetImage.homeIcon.image
        case .Settings:
            return AssetImage.settingIcon.image
        case .Menu:
            return AssetImage.settingIcon.image
        case .Search:
            return AssetImage.Search.image
        case .More:
            return AssetImage.homeIcon.image
        }
    }
}

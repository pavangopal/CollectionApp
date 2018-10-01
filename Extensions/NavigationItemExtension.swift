//
//  NavigationItemExtension.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/26/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Quintype
import UIKit
import WebKit

extension UIViewController:SideMenuControllerDelegate,UIPopoverPresentationControllerDelegate{
    
    var rightSearchBarButtonItem:UIBarButtonItem {
        get {
            let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed(sender:)))
            searchButton.tintColor = .white
            return searchButton
        }
    }
    
    var rightMenuButtonItem:UIBarButtonItem {
        get {
            
            let menuButton = UIBarButtonItem(image: AssetImage.Hamberger.image, style: .done, target: self, action: #selector(self.sideMenuButtonPressed(sender:)))
            menuButton.tintColor = .white
            return menuButton
        }
    }
    
    var trendingNewsButtonItem:BadgeBarItem {
        get {
            
            // button
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            rightButton.setBackgroundImage(AssetImage.Trending.image, for: .normal)
            
            // Bar button item
            let rightBarButtomItem = BadgeBarItem(customView: rightButton)
            
            //            rightButton.addSubview(rightBarButtomItem.badgeLabel)
            navigationItem.rightBarButtonItem = rightBarButtomItem
            
            rightBarButtomItem.tintColor = .white
            return rightBarButtomItem
        }
    }
    
    
    
    
    @objc func sideMenuButtonPressed(sender:UIBarButtonItem) {
        
        if let menuArray = Quintype.publisherConfig?.layout?.menu{
            
            let sectionArray = menuArray.filter({$0.section_slug != nil})
            let linkAray = menuArray.filter({$0.item_type?.lowercased() == "link" && $0.url != "/about-us#download" && $0.url != "https://hindi.thequint.com"})
            var validSectionArray = sectionArray + linkAray
            
            let homeMenu = Menu()
            
            homeMenu.section_slug = "home"
            homeMenu.section_name = "Home"
            homeMenu.title = "Home"
            
            if (validSectionArray.count) > 0{
                validSectionArray.insert(homeMenu, at: 0)
            }
            
            let sideMenuController = SideMenuController(menuArray: validSectionArray)
            sideMenuController.delegate = self
            sideMenuController.modalPresentationStyle = .overFullScreen
            
            sideMenuController.dismissCompletionHandler = { () -> Void in
                self.dismiss(animated: false, completion: nil)
            }
            
            present(sideMenuController, animated: false, completion: nil)
        }
    }
    
    
    @objc func setupNavgationbar(){
        rightSearchBarButtonItem.accessibilityLabel = "section"
        self.navigationItem.setRightBarButtonItems([rightMenuButtonItem,rightSearchBarButtonItem], animated: true)
        
        let image = UIImage.from(color: UIColor.black.withAlphaComponent(0.1))
        
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setClearNavigationBar(){
        let image = UIImage.from(color: UIColor.black.withAlphaComponent(0.1))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .clear
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setSolidNavigationBar(){

        self.navigationController?.navigationBar.barTintColor = ThemeService.shared.theme.primarySectionColor
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.barTintColor = nil
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = nil
        
        
    }
    
    @objc func setupNavgationbarForHome(){
        rightSearchBarButtonItem.accessibilityLabel = "home"
        
        self.navigationItem.setRightBarButtonItems([rightMenuButtonItem,rightSearchBarButtonItem], animated: true)
        self.navigationController?.navigationBar.barTintColor = ThemeService.shared.theme.primarySectionColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        
       
    }
    
    @objc func goToHomeTab(sender:UIBarButtonItem){
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @objc func searchButtonPressed(sender:UIBarButtonItem){
        
        let searchController = SearchController()
        self.navigationController?.navigationItem.title = ""
        self.navigationController?.pushViewController(searchController, animated: true)
        
    }
    
    
    @objc func itemSelectedAtIndex(slug:String,index:Int) {
        Quintype.analytics.trackPageViewSectionVisit(section: slug)
        
//        if let currentController = self.navigationController?.viewControllers.last{
//            
//            if currentController.isKind(of: HomeController.self){
//                if let homeController = currentController as? HomeController{
//                    homeController.moveTo(viewController: homeController.viewControllerCollection[index], animated: true)
//                }
//            }else{
//                
//                let storyDetailController = HomeController(slug: slug)
//                self.navigationController?.pushViewController(storyDetailController, animated: true)
//                
//            }
//            
//        }
    }
    func getWebview(url:String) -> WKWebView{
        
        let webview = WKWebView()
        webview.load(URLRequest(url: URL(string: url)!))
        return webview
        
    }
    @objc func linkSelected(menu: Menu) {
        if let slug = menu.title{
            Quintype.analytics.trackPageViewSectionVisit(section: slug)
            if let url = menu.url{
                if let _ = URL(string:url)?.host{
                    if url == "https://www.thequint.com/your-story"{
                        self.tabBarController?.selectedIndex = 3
                    }
                    let webViewController = PopupController(customWebview: getWebview(url: url))
                    self.navigationController?.pushViewController(webViewController, animated: false)
                }else{
                    let webViewController = PopupController(customWebview: getWebview(url: appConfig.baseURL + url))
                    self.navigationController?.pushViewController(webViewController, animated: false)
                }
                
                
            }
            
        }
        
    }
    
}

class BadgeBarItem:UIBarButtonItem{
    
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
}

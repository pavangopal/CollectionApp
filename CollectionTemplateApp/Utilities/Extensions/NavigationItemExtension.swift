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

extension UIViewController : UIPopoverPresentationControllerDelegate,MenuControllerDelegate {
    
    var rightSearchBarButtonItem:UIBarButtonItem {
        get {
            let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed(sender:)))
            searchButton.tintColor = .white
            return searchButton
        }
    }
    
    var leftMenuButtonItem:UIBarButtonItem {
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
        guard let menuController = loadMenuController() else{
            return
        }
        
        menuController.delegate = self
        menuController.dismissCompletionHandler = { () -> Void in
            self.dismiss(animated: false, completion: nil)
        }
        
        let navigationController = UINavigationController(rootViewController: menuController)
        navigationController.navigationBar.isHidden = true
        
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.view.backgroundColor = UIColor.clear
        
        present(navigationController, animated: false, completion: nil)
        
    }
    
    func loadMenuController() -> MenuController? {
        if let menuArray = Quintype.publisherConfig?.layout?.menu {
            let validSectionArray = menuArray.filter({$0.url != "/about-us#download" && $0.url != "https://hindi.thequint.com"})
            return MenuController(menu: validSectionArray)
        }
        return nil
    }
    
    
    @objc func setupNavgationbar(){
        rightSearchBarButtonItem.accessibilityLabel = "section"
        self.navigationItem.setRightBarButtonItems([leftMenuButtonItem,rightSearchBarButtonItem], animated: true)
        let brandImage = AssetImage.BrandLogo.image.withRenderingMode(.alwaysTemplate)
        let logoItem = UIBarButtonItem(image: brandImage, style: .done, target: nil, action: #selector(self.goToHomeTab(sender:)))
        logoItem.tintColor = ThemeService.shared.theme.primaryQuintColor
        
        if let controllerCount =  self.navigationController?.viewControllers.count{
            if controllerCount <= 1{
                self.navigationItem.leftBarButtonItem = logoItem
            }
        }
    }
    
    func setClearNavigationBar(){
        let image = UIImage.from(color: UIColor.black.withAlphaComponent(0.1))
        
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setSolidNavigationBar(){
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.backgroundColor = ThemeService.shared.theme.primarySectionColor
        self.navigationController?.navigationBar.barTintColor = ThemeService.shared.theme.primarySectionColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = ThemeService.shared.theme.primarySectionColor
        
    }
    
    @objc func setupNavgationbarForHome() {
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        self.navigationItem.setLeftBarButtonItems([leftMenuButtonItem], animated: true)
        
        let brandImage = AssetImage.BrandLogo.image.withRenderingMode(.alwaysTemplate)
        let logoItem = UIBarButtonItem(image: brandImage, style: .done, target: nil, action: nil)
        logoItem.tintColor = ThemeService.shared.theme.primaryQuintColor
        
        if let controllerCount =  self.navigationController?.viewControllers.count{
            if controllerCount <= 1{
                self.navigationItem.leftBarButtonItems?.append(logoItem)
            }
        }
    }
    
    func addbackButton() {
        
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(title: "back", style: .done, target: self, action: #selector(self.popController)), at: 0)
    }
    
    @objc func popController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goToHomeTab(sender:UIBarButtonItem){
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @objc func searchButtonPressed(sender:UIBarButtonItem){
        
        let searchController = SearchController()
        self.navigationController?.navigationItem.title = ""
        self.navigationController?.pushViewController(searchController, animated: true)
        
    }
    
    func itemSelectedAtIndex(menuArray:[Menu],index:Int){
        
        if index >= menuArray.count{
            return
        }
        
        Quintype.analytics.trackPageViewSectionVisit(section: menuArray[index].section_slug ?? "")
        
        if let lastController = self.navigationController?.viewControllers.last {
            
            if lastController.isKind(of: HomeController.self){
                if let homeController = lastController as? HomeController{
                    homeController.moveToViewController(at: index, animated: true)
                }
            }else{
                
                let storyDetailController = SectionController(slug: menuArray[index].section_slug ?? "")
                self.navigationController?.pushViewController(storyDetailController, animated: true)
            }
            
        }
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

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

//
//  CustomNavigationBar.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype
import WebKit

protocol CustomNavigationBarDelegate:class {
    associatedtype Delegate
    
    init(delegate:Delegate)
        
}

@objc protocol NavigationItemDelegate:class{
    func searchBarButtonPressed()
    func hamburgerBarButtonPressed()
}

class CustomNavigationBar: UINavigationBar , CustomNavigationBarDelegate {
    
    typealias Delegate = NavigationItemDelegate
    
    fileprivate weak var navigationDelegate:Delegate?

    
    lazy var rightSearchBarButtonItem:UIBarButtonItem  = {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchBarButtonPressed))
        searchButton.tintColor = .white
        return searchButton
    }()
    
   lazy var leftMenuButtonItem:UIBarButtonItem = {
            let menuButton = UIBarButtonItem(image: AssetImage.Hamberger.image, style: .done, target: self, action: #selector(self.hamburgerBarButtonPressed))
            menuButton.tintColor = .white
            return menuButton
    
    }()
    
    lazy var backButtonItem:UIBarButtonItem = {
        let menuButton = UIBarButtonItem(image: AssetImage.BackArrow.image, style: .done, target: self, action: #selector(self.backButtonPressed))
        menuButton.tintColor = .white
        return menuButton
        
    }()
    
    required init(delegate:Delegate){
        super.init(frame: .zero)
        self.navigationDelegate = delegate
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setNavigationItems(){
        let navigationItem = UINavigationItem(title: "")
    
        navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        navigationItem.setLeftBarButton(leftMenuButtonItem, animated: true)
        items = [navigationItem]
        
    }
    
    func setClearColorNavigationBar() {
        let image = UIImage.from(color: UIColor.black.withAlphaComponent(0.1))
        setBackgroundImage(image, for: UIBarMetrics.default)
        shadowImage = UIImage()
        backgroundColor = .clear
        barTintColor = .clear
        tintColor = .white
        isTranslucent = true
    }
    
    func setSolidColorNavigationBar() {
        setBackgroundImage(nil, for: UIBarMetrics.default)
        shadowImage = nil
        backgroundColor = nil
        barTintColor = ThemeService.shared.theme.primarySectionColor
        tintColor = .white
        isTranslucent = false
        
    }
    
    func setBackNavigationBarButton(){
        let navigationItem = UINavigationItem(title: "")
        
        navigationItem.setLeftBarButtonItems([backButtonItem], animated: true)
        
        items = [navigationItem]
    }
    
    func setBackHambergerMenu(){
        let navigationItem = UINavigationItem(title: "")
        
        navigationItem.setLeftBarButtonItems([backButtonItem,leftMenuButtonItem], animated: true)
        
        items = [navigationItem]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CustomNavigationBar{
    
   @objc func searchBarButtonPressed() {
        if let delegateController = self.navigationDelegate as? UIViewController {
            let searchController = SearchController()
            delegateController.navigationController?.navigationItem.title = ""
            delegateController.navigationController?.pushViewController(searchController, animated: true)
        }
    }
    
   @objc func hamburgerBarButtonPressed(){
        guard let controller = self.navigationDelegate as? UIViewController else{
            return
        }
        
        if let menuArray = Quintype.publisherConfig?.layout?.menu {
           
            let validSectionArray = menuArray.filter({$0.url != "/about-us#download" && $0.url != "https://hindi.thequint.com"})
           
            let sideMenuController = MenuController(menu: validSectionArray)
            sideMenuController.delegate = self
            sideMenuController.dismissCompletionHandler = { () -> Void in
                controller.dismiss(animated: false, completion: nil)
            }
            
            let navigationController = UINavigationController(rootViewController: sideMenuController)
            navigationController.navigationBar.isHidden = true
            
            navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.view.backgroundColor = UIColor.clear
            
            controller.present(navigationController, animated: false, completion: nil)
            
        }
        
    }
    
   @objc private func backButtonPressed(){
        guard let controller = self.navigationDelegate as? UIViewController else{
            return
        }
        controller.navigationController?.popViewController(animated: true)
    }
}

extension CustomNavigationBar : MenuControllerDelegate{
    
    func itemSelectedAtIndex(menuArray:[Menu],index:Int){
        
        guard let controller = self.navigationDelegate as? UIViewController,index<menuArray.count else{
            return
        }
        
        Quintype.analytics.trackPageViewSectionVisit(section: menuArray[index].section_slug ?? "")
        
        if let lastController = controller.navigationController?.viewControllers.last {

            if lastController.isKind(of: HomeController.self){
                if let homeController = lastController as? HomeController{
                    homeController.moveToViewController(at: index, animated: true)
                }
            }else{

                let storyDetailController = SectionController(slug: menuArray[index].section_slug ?? "")
                controller.navigationController?.pushViewController(storyDetailController, animated: true)
                
//                let homeController = HomeController(menuArray: menuArray)
//                homeController.selectedIndex = index
//                let homeNavigationController = lastController.navigationController?.presentingViewController as? UINavigationController
//                homeNavigationController?.pushViewController(homeController, animated: true)
            }

        }
    }
    
    func getWebview(url:String) -> WKWebView{
        
        let webview = WKWebView()
        webview.load(URLRequest(url: URL(string: url)!))
        return webview
        
    }
    
    @objc func linkSelected(menu: Menu) {
        guard let controller = self.navigationDelegate as? UIViewController else{
            return
        }
        if let slug = menu.title{
            Quintype.analytics.trackPageViewSectionVisit(section: slug)
            if let url = menu.url{
                if let _ = URL(string:url)?.host{
                 
                    let webViewController = PopupController(customWebview: getWebview(url: url))
                    controller.navigationController?.pushViewController(webViewController, animated: false)
                }else{
                    let webViewController = PopupController(customWebview: getWebview(url: appConfig.baseURL + url))
                    controller.navigationController?.pushViewController(webViewController, animated: false)
                }
            }
            
        }
        
    }
}

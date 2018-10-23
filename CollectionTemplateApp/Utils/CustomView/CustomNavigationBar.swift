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
    
   lazy var rightMenuButtonItem:UIBarButtonItem = {
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
    
        navigationItem.setRightBarButtonItems([rightMenuButtonItem,rightSearchBarButtonItem], animated: true)
        
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
                controller.dismiss(animated: false, completion: nil)
            }
        
            controller.present(sideMenuController, animated: false, completion: nil)
            
        }
        
    }
    
   @objc private func backButtonPressed(){
        guard let controller = self.navigationDelegate as? UIViewController else{
            return
        }
        controller.navigationController?.popViewController(animated: true)
    }
}

extension CustomNavigationBar : SideMenuControllerDelegate{
    
    @objc func itemSelectedAtIndex(slug:String,index:Int) {
        Quintype.analytics.trackPageViewSectionVisit(section: slug)
        guard let controller = self.navigationDelegate as? UIViewController else{
            return
        }
        if let currentController = controller.navigationController?.viewControllers.last{

            if currentController.isKind(of: HomeController.self){
                if let homeController = currentController as? HomeController{
                    homeController.moveTo(viewController: homeController.viewControllerCollection[index], animated: true)
                }
            }else{

                let storyDetailController = SectionController(slug: slug)
                controller.navigationController?.pushViewController(storyDetailController, animated: true)

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

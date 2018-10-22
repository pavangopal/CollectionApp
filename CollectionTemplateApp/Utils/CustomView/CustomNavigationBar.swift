//
//  CustomNavigationBar.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationBar: UINavigationBar {
    
    var rightSearchBarButtonItem:UIBarButtonItem {
        get {
            let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
            searchButton.tintColor = .white
            return searchButton
        }
    }
    
    var rightMenuButtonItem:UIBarButtonItem {
        get {
            let menuButton = UIBarButtonItem(image: AssetImage.Hamberger.image, style: .done, target: self, action: nil)
            menuButton.tintColor = .white
            return menuButton
        }
    }
   
    init(){
        super.init(frame: .zero)
//        isTranslucent = false
//        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setNavigationItems(){
        let navigationItem = UINavigationItem(title: "")
        navigationItem.setLeftBarButtonItems([rightMenuButtonItem,rightSearchBarButtonItem], animated: true)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

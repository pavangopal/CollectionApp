//
//  HomeContainerNavigationExtension.swift
//  CoreApp-iOS
//
//  Created by Albin CR on 3/22/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit
import OneSignal
import Quintype

extension UIViewController{
    
    var rightSearchBarButtonItem:UIBarButtonItem {
        get {
            return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action:  #selector(searchTapped(_:)))
        }
    }
    
    
  @objc func setupNavgationbar(){
        
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
    }
    
   @objc func searchTapped(_ sender:UIBarButtonItem){
        
//        let searchController = SearchController()
//        self.navigationController?.pushViewController(searchController, animated: true)
//        
//        GoogleAnalytics.Track(with: .homePage, event: .searchItemClicked)
        
    }
    
}


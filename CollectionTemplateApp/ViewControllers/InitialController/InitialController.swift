//
//  InitialController.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/13/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Crashlytics

class InitialController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializer()
    }
    
    @objc private func initializer(){
        
        getPublisher()
    }
    
    @objc func getPublisher(){
        
        Quintype.api.getPublisherConfig(cache: cacheOption.loadOldCacheAndReplaceWithNew, Success: { (data) in
            let appDelegate  = UIApplication.shared.delegate as? AppDelegate
            let window = appDelegate?.window
            window?.rootViewController = AppContainer()
            
        }) { (error) in
            print(error ?? "")
        }
    }
    
}

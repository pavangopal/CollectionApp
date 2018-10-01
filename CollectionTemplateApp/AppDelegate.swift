//
//  AppDelegate.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/13/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import WatchdogInspector

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        TWWatchdogInspector.start()
        TWWatchdogInspector.setEnableMainthreadStallingException(false)

        Quintype.initWithBaseUrl(baseURL: appConfig.baseURL)

        loadInitialViewController()
        UIApplication.shared.statusBarStyle = .lightContent

        return true
    }
    
    func loadInitialViewController(){
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        // Set Background Color of window
        window?.backgroundColor = UIColor.white
        // Allocate memory for an instance of the 'MainViewController' class
        let mainViewController = InitialController()
        // Set the root view controller of the app's window
        window!.rootViewController = mainViewController
        // Make the window visible
        window!.makeKeyAndVisible()
        
    }

}


//
//  SafariViewController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/12/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: NSObject, SFSafariViewControllerDelegate {
    
    var url:URL!
    var topController:UIViewController?
    
    required init(url:URL){
        
        self.url = url
        self.topController = UIApplication.shared.topMostViewController()
        
    }
    
    func showSafariController(){
        
        if let controller = self.topController{
            let svc = SFSafariViewController(url: self.url)
            
            svc.delegate = self
            controller.present(svc, animated: true, completion: nil)
        }else{
            if UIApplication.shared.canOpenURL(self.url){
                UIApplication.shared.open(self.url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if let controller = self.topController{
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigation = self.presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

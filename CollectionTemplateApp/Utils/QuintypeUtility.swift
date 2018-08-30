//
//  QuintypeUtility.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/3/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit
import Quintype
import OneSignal

class QuintypeUtility{
    
    static let sharedInstance = QuintypeUtility()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicatory(uiView: UIView) {
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
//        actInd.color = ThemeService.sharedInstance.theme.primaryColor
        actInd.isHidden = false
        uiView.addSubview(actInd)
        //        uiView.isUserInteractionEnabled = false
        actInd.startAnimating()
        
    }
    
    func hideActivityIndicatory(uiView: UIView){
        actInd.stopAnimating()
    }
    
    
    class func initNavgationAndTabBar(){
        
        //Accesing window of the app
        let appDelegate  = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        window?.rootViewController = CustomTabBarController()
    }
    
    class func checkForOnesignalPushToken() -> Bool{
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        let hasPrompted = status.permissionStatus.hasPrompted
        print("hasPrompted = \(hasPrompted)")
        let userStatus = status.permissionStatus.status
        print("userStatus = \(userStatus)")
        
        let isSubscribed = status.subscriptionStatus.subscribed
        print("isSubscribed = \(isSubscribed)")
        let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
        print("userSubscriptionSetting = \(userSubscriptionSetting)")
        let userID = status.subscriptionStatus.userId
        print("userID = \(userID ?? "")")
        let pushToken = status.subscriptionStatus.pushToken
        print("pushToken = \(pushToken ?? "")")
        return (pushToken != nil ? true : false)
    }
}




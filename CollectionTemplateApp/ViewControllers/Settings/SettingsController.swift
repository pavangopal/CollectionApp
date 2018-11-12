//
//  SettingsController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/13/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Kingfisher
import StoreKit
import UserNotifications

class SettingsController: UIViewController,SKStoreProductViewControllerDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    var acivityIndicator:UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    
    var composer:MailComposer?
    var dataSource:[SettingsSectionType] = [.AppSettings,.ImageQuality,.Support,.Social,.Information]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalytics.Track(with: AnalyticKeys.category.settingsScreen, event: AnalyticKeys.events.settingsScreenOpened)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSolidNavigationBar()
        

        view.addSubview(tableView)
        view.addSubview(acivityIndicator)
        tableView.fillSuperview()
        acivityIndicator.anchorCenterSuperview()
        
        title = "Settings"

        tableView.register(cellClass: SettingCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if dataSource.count > 0{
            self.tableView.reloadData()
        }
        
    }
}

extension SettingsController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: SettingCell.self, for: indexPath)
        let item = self.dataSource[indexPath.section].items[indexPath.row]
        if item == .Version{
            cell.isUserInteractionEnabled = false
        }else{
            cell.isUserInteractionEnabled = true
        }
        cell.configure(settingItem: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.dataSource[indexPath.section].items[indexPath.row]
        
        switch item {
            
        case .Notification:
            
            if !UIApplication.shared.isRegisteredForRemoteNotifications{
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (setting) in
                    DispatchQueue.main.async {
                        if setting.authorizationStatus == .denied{
                            self.showEventsAcessDeniedAlert(title: "Notification Setting", message: "Notification is disabled for TheQuint. Please enable it in Settings to continue.")
                        }else{
                            self.showEventsAcessDeniedAlert(title: "Notification Setting", message: "Notification is enabled for TheQuint. Please change it in Settings to continue.")
                        }
                    }
                    
                })
            }else{
                self.showEventsAcessDeniedAlert(title: "Notification Setting", message: "Notification is disabled for TheQuint. Please enable it in Settings to continue.")
            }
            
        case .Cache:
            let alertController = UIAlertController(title: "Confirmation",
                                                    message: "Are you sure you want to clear cache?",
                                                    preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
                
                self.clearAllCache()
            }
            
            alertController.addAction(yesAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
            
        case .High:
            
            ThemeService.shared.imageQuality = .High
            
        case .Medium:
            ThemeService.shared.imageQuality = .Medium
            
        case .Low:
            
            ThemeService.shared.imageQuality = .Low
            
        case .RateUs:
            
            openAppStoreProduct()
            
        case .ReportAProblem:
            
            acivityIndicator.startAnimating()
            let bugId = "\(arc4random())"
            
            composer =  MailComposer(recipients: ["ios@quintype.com"], ccRecipient: ["support@quintype.com"], subject: "#\(bugId) - Bug Report from TheQuint iOS app", body: nil, controller: self)
            self.acivityIndicator.stopAnimating()
            
        case .Facebook:
            if let urlString = item.urlString{
                openURL(url: urlString, appKey: "fb://profile/315252535308608")
            }
            break
        case   .Twitter:
            if let urlString = item.urlString{
                openURL(url: urlString, appKey: "twitter://user?screen_name=thequint")
            }
            
            break
        case   .Instagram:
            if let urlString = item.urlString{
                openURL(url: urlString, appKey: "instagram://user?username=thequint")
            }
            
            
            break
        case   .Youtube:
            if let urlString = item.urlString{
                openURL(url: urlString, appKey: "https://youtube.com/thequint")
            }
            
            break
        case  .AboutUs:
            if let urlString = item.urlString, let url = URL(string: urlString){
                let safariViewController = SafariViewController(url: url)
                safariViewController.showSafariController()
            }
            
            
            break
        case  .PrivacyPolicy:
            if let urlString = item.urlString, let url = URL(string: urlString){
                let safariViewController = SafariViewController(url: url)
                safariViewController.showSafariController()
            }
            
            
            break
        case  .TermsAndCondition:
            
            if let urlString = item.urlString, let url = URL(string: urlString){
                let safariViewController = SafariViewController(url: url)
                safariViewController.showSafariController()
            }
            
            break
        default:
            break
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func openAppStoreProduct() {
        guard let url = URL(string: appConfig.appStoreLink) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func clearAllCache(){
        
        acivityIndicator.startAnimating()
        
        let domain = Bundle.main.bundleIdentifier!
        
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        UserDefaults.standard.synchronize()
        
        self.clearUnusedImagesfromCache()
        
        ImageCache.default.clearDiskCache {
            self.acivityIndicator.stopAnimating()
        }
    }
    
    func openURL(url:String,appKey:String){
        
        
        if UIApplication.shared.canOpenURL( URL(string: appKey)!){
            UIApplication.shared.open(URL(string: appKey)!)
        }else{
            if let appUrl = URL(string: url){
                let safariViewController = SafariViewController(url: appUrl)
                safariViewController.showSafariController()
            }
        }
        
        
    }
    
    func showEventsAcessDeniedAlert(title:String,message:String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            if let appSettingsUrl = URL(string: UIApplicationOpenSettingsURLString),UIApplication.shared.canOpenURL(appSettingsUrl) {
                
                UIApplication.shared.open(appSettingsUrl , options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

//
//  PopupController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 1/12/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import WebKit

class PopupController: UIViewController,WKUIDelegate {
    
    var activityIndicator:UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    var popWebview:WKWebView?
    var progressView: UIProgressView!
    var shouldShowLogo:Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        if !shouldShowLogo{
            addCancel()
        }
    }
    
    convenience init(customWebview:WKWebView,showLogo:Bool=false){
        self.init(nibName: nil, bundle: nil)
        
        self.shouldShowLogo = showLogo

        self.popWebview = customWebview
        prepareWebView()
        
        if showLogo{
        setupNavgationbar()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLogo(){
        let brandImage = AssetImage.BrandLogo.image.withRenderingMode(.alwaysTemplate)
        let logoItem = UIBarButtonItem(image: brandImage, style: .done, target: nil, action: nil)
        logoItem.tintColor = ThemeService.shared.theme.primaryQuintColor
        self.navigationItem.leftBarButtonItem = logoItem
        setupNavgationbar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        themeNavigation()
    }
    func addCancel(){
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = cancelItem
        
    }
    func themeNavigation(){
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = ThemeService.shared.theme.primarySectionColor
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func loadWebView(configuration:WKWebViewConfiguration){
        UserDefaults.standard.register(defaults: ["UserAgent" : "Custom Agent"])
        let userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")! + " Custom Agent"
        UserDefaults.standard.register(defaults: ["UserAgent" : userAgent])
        
        popWebview = WKWebView(frame: self.view.frame, configuration: configuration)
        prepareWebView()
    }
    
    func prepareWebView(){
        popWebview?.uiDelegate = self
        popWebview?.navigationDelegate = self
        
        view.addSubview((popWebview)!)
        popWebview?.fillSuperview()
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        view.addSubview(progressView)
        view.addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        
        progressView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 2)
        popWebview?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    @objc func cancelTapped() {
        if isModal(){
         self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    public func webViewDidClose(_ webView: WKWebView) {
//        print(#function)
        if isModal(){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float((popWebview?.estimatedProgress) ?? 0)
            if progressView.progress == 1{
             activityIndicator.stopAnimating()
            }
        }
    }
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if (navigationAction.targetFrame == nil) {
            let popUpVC = PopupController()
            let navVC = UINavigationController(rootViewController: popUpVC)
            popUpVC.loadWebView(configuration: configuration)
            self.navigationController?.present(navVC, animated: true, completion: nil)
            return (popUpVC.popWebview)!
        }
        
        return nil;
        
    }
    
    deinit {
        print("deinit called")
        
        popWebview?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .actionSheet)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}

extension PopupController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}


//
//  MetypeView.swift
//  Metype
//
//  Created by Albin.git on 9/11/17.
//  Copyright © 2017 Albin.git. All rights reserved.
//

import UIKit
import WebKit

open class Metype:UIViewController,WKUIDelegate{
    
    var wkWebView:WKWebView = {
        
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
        
    }()
    
    var progressView: UIProgressView!
    private var url : URL!
    private var publisherHost:String!
    
    
    public init(accountId:Int,metypeHost:String,publisherHost:String,slug:String,color:UIColor) {
        
        let base64String = Data((publisherHost + "/" + slug).utf8).base64EncodedString()
        
        let url = URL(string: metypeHost + "iframe?account_id=\(accountId)&primary_color=IzRkMDg2YQ==&page_url=\(base64String)")
        self.url = url
        self.publisherHost = publisherHost
        super.init(nibName: nil, bundle: nil)
    }

    
    
//    class open func getMetypeController(accountId:Int,metypeHost:String,publisherHost:String,slug:String,color:UIColor) -> Metype{
//
//        let url = URL(string: metypeHost + "iframe?account_id=\(accountId)&primary_color=IzRkMDg2YQ==&page_url=\(publisherHost + "/" + slug)")
//        let view = Metype(publisherHost: publisherHost)
//        view.url = url
//        return view
//
//    }
    
    override open func viewDidLoad() {
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        view.addSubview(wkWebView)
        view.addSubview(progressView)
        
        progressView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 2)
        wkWebView.fillSuperview()
        
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        loadWebContent()
    }
    
    private func loadWebContent()  {
        
        //        Remove user agent for google login to work
        
        UserDefaults.standard.register(defaults: ["UserAgent" : "Custom Agent"])
        let userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")! + " Custom Agent"
        UserDefaults.standard.register(defaults: ["UserAgent" : userAgent])
        
        wkWebView.uiDelegate = self
        var request = URLRequest(url: url)
        request.setValue(publisherHost, forHTTPHeaderField: "Referer")
        wkWebView.load(request)
        
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
    
    public func webViewDidClose(_ webView: WKWebView) {
        
        print(#function)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(wkWebView.estimatedProgress)
            print(Float(wkWebView.estimatedProgress))
        }
    }
    
    deinit {
        print("deinit called")
        wkWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//
//  SoundCloudCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/2/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import WebKit

class UrlEmbedCell:BaseCollectionCell,WKNavigationDelegate{
    
    
    var status = false
    var indexPath:IndexPath?
    var isHeightCalculated:Bool = true
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var contentLoaded:String = ""
    var webViewLoaded = false
    
    lazy var webview:WKWebView = {
        var scriptContent = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let userScript = WKUserScript(source: scriptContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webview = WKWebView(frame: .zero, configuration: configuration)
        
        webview.translatesAutoresizingMaskIntoConstraints = false
        webview.scrollView.isScrollEnabled = false
        
        return webview
    }()
    
    var loadingView:UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    override func setUpViews(){
        super.setUpViews()
        
        contentView.addSubview(loadingView)
        contentView.addSubview(webview)
        
        webview.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        loadingView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        
        contentView.bringSubview(toFront: loadingView)
        
        showActivityIndicatory(uiView: self.contentView)
        webview.navigationDelegate = self
    }
    
    override func configure(data: Any?, indexPath: IndexPath,status:Bool) {
        
        self.indexPath = indexPath
        
        if webViewLoaded{
            return
        }
        
        let card = data as? CardStoryElement
        
        if let urlString = card?.embed_url,let url = URL(string: urlString){
            self.webview.load(URLRequest(url: url))
            
        }else if let urlString = card?.url,let url = URL(string: urlString){
                self.webview.load(URLRequest(url: url))
            
        }
        
    }
    

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewLoaded = true
        hideActivityIndicatory()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewLoaded = true
        hideActivityIndicatory()
    }
    
    func showActivityIndicatory(uiView: UIView) {
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        actInd.color = UIColor.lightGray
        uiView.addSubview(actInd)
        actInd.startAnimating()
        
    }
    
    func hideActivityIndicatory(){
        loadingView.isHidden = true
        actInd.stopAnimating()
    }
}


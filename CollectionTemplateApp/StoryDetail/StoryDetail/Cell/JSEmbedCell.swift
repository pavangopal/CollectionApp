//
//  JSEmbedCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/1/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import WebKit

class JSEmbedCell:BaseCollectionCell,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate{
    
    var MyObservationContext = 0
    
    var status = false
    var indexPath:IndexPath?
    
    var activityIndicatorView: UIActivityIndicatorView = {
         let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicatorView.color = UIColor.lightGray
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    var loadingView:UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var contentLoaded:String = ""
    
    var observing = false
    var didCaliculateSize = false
    
    weak var timer :Timer?
    
    var actualHeight :CGFloat?{
        
        willSet{
            
            if (newValue ?? 0) > self.contentView.frame.size.height{
            
                self.didCaliculateSize = true
                self.actualHeight = newValue
                self.delegate?.didCalculateSize(indexPath:self.indexPath!,size: CGSize(width: self.screenWidth - 20, height:actualHeight ?? 0),elementType: storyDetailLayoutType.JSEmbedCell)
                self.hideActivityIndicatory()
            }
        }
    }
    
    lazy var webview:WKWebView = {
        var scriptContent = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0');meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let userScript = WKUserScript(source: scriptContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webview = WKWebView(frame: .zero, configuration: configuration)
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.translatesAutoresizingMaskIntoConstraints = false
        webview.scrollView.isScrollEnabled = false
    
        webview.scrollView.delegate = self
        
        return webview
    }()

    var heightConstraint: NSLayoutConstraint?
    
    var webFrameCounter:Int = 0
    
    
   override func setUpViews(){
        super.setUpViews()
        self.contentView.clipsToBounds = true
    
        let view = self.contentView
        view.backgroundColor = .white
        
        view.addSubview(webview)
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicatorView)
        
        webview.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
    
        loadingView.fillSuperview()
        activityIndicatorView.anchorCenterSuperview()
        showActivityIndicatory()
    }
    
    override func configure(data: Any?, indexPath: IndexPath,status:Bool) {
        
        super.configure(data: data, indexPath: indexPath,status:status)
        self.indexPath = indexPath
        
        if !didCaliculateSize{
            self.showActivityIndicatory()
        }
        
        let card = data as? CardStoryElement
        if let base64String = card?.embed_js{
            DispatchQueue.global(qos: .userInitiated).async {
                if let html = base64String.decodeBase64()?.trim(){
                    
                    let padding = self.margin.Left + self.margin.Right + 22
                    
                    var fullHtml = "<html><head><style>body,iframe {margin-bottom:10 !important; margin-left:0 !important; margin-right:0 !important;  box-shadow: none !important; padding:0 !important; width:\(UIScreen.main.bounds.width - padding)!important; heightPlaceholder}</style> </head><body id='foo'> \(html) </body></html>"
                    
                    if fullHtml.contains("audioboom"){
                       fullHtml = fullHtml.replacingOccurrences(of: "heightPlaceholder", with: "")
                    }else{

                        let regex = try! NSRegularExpression(pattern: "height", options: NSRegularExpression.Options.caseInsensitive)
                        let range = NSMakeRange(0, fullHtml.count)
                        fullHtml = regex.stringByReplacingMatches(in: fullHtml, options: [], range: range, withTemplate: "")
                    }
                    
                    if self.contentLoaded != card!.id!{
                        DispatchQueue.main.async {
                        
                            self.webview.loadHTMLString(fullHtml, baseURL: URL(string: "https://localhost"))
                            self.contentLoaded = card!.id!
                        }
                    }
                }
            }

        }
        
        //        webview.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    func showActivityIndicatory() {
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicatory(){
        loadingView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
    
    deinit {
        stopTimer()
    }
    
}


extension JSEmbedCell {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if (!observing) {
            startTimer()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopTimer()
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if (navigationAction.targetFrame == nil) {
            if let url = navigationAction.request.url,UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return nil
            }
            let popUpVC = PopupController()
            popUpVC.addCancel()
            let navVC = UINavigationController(rootViewController: popUpVC)
            popUpVC.loadWebView(configuration: configuration)
            
            self.delegate?.shouldNavigateTo(controller: navVC)
            
            return (popUpVC.popWebview)!
        }
        
        return nil;
        
    }
    
    
    
    func startTimer(){
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(reloadCell), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(5)) {
            guard self.timer != nil else { return}
            print("Exiting JsEmbed Loading")
            
            self.didCaliculateSize = true
            self.delegate?.didCalculateSize(indexPath:self.indexPath!,size: CGSize(width: self.screenWidth - 20, height: self.actualHeight ?? 0),elementType: storyDetailLayoutType.JSEmbedCell)
            
            self.hideActivityIndicatory()
//            self.stopTimer()
        }
    }
    
    @objc func reloadCell(){
        
        actualHeight = webview.scrollView.contentSize.height
    }
    
    func stopTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    
    //MARK: Not used
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize"{
            self.webview.evaluateJavaScript("document.body.offsetHeight") { (result, error) in
                if error == nil {
                    if let result = result as? CGFloat{
                        print("TotalHEight ==== \(result)")
                    }
                }
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
        return layoutAttributes
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}


extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}



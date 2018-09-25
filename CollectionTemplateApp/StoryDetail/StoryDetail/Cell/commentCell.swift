

import UIKit
import Quintype
import WebKit

class CommentCell:BaseCollectionCell,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate{
    
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
    
    var contentLoaded:Bool = false
    
    var observing = false
    var didCaliculateSize = false
    
    weak var timer :Timer?
    
    var actualHeight :CGFloat?{
        
        willSet{
            
            if (newValue ?? 0) > self.contentView.frame.size.height{
                
                self.didCaliculateSize = true
                self.actualHeight = newValue
                self.delegate?.didCalculateSize(indexPath:self.indexPath!,size: CGSize(width: self.screenWidth - 20, height:actualHeight ?? 0),elementType: storyDetailLayoutType.CommentCell)
                self.hideActivityIndicatory()
            }
        }
    }
    
    lazy var webview:WKWebView = {
        var scriptContent = ""
        
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
        webview.scrollView.minimumZoomScale = 1.0
        webview.scrollView.maximumZoomScale = 1.0
        webview.contentScaleFactor = 0
        return webview
    }()
    
    var heightConstraint: NSLayoutConstraint?
    
    var webFrameCounter:Int = 0
    
    
    override func setUpViews(){
//        super.setUpViews()
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
        
        if let story = data as? Story{
            
            if !didCaliculateSize{
                self.showActivityIndicatory()
            }
            
                if !self.contentLoaded {
                    DispatchQueue.main.async {
                       
                        if let slug = story.slug{
                            let base64String = Data((appConfig.baseURL + "/" + slug).utf8).base64EncodedString()
                            
                            guard let url = URL(string: appConfig.Metype.host + "iframe?account_id=\(appConfig.Metype.id)&primary_color=IzRkMDg2YQ==&page_url=\(base64String)")else {
                                return
                            }
                            
                            var request = URLRequest(url: url)
                            request.setValue(appConfig.baseURL, forHTTPHeaderField: "Referer")
                            self.contentLoaded = true
                            self.webview.load(request)
                        }else{
                            return
                        }
                    }
                }
            
        }
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}


extension CommentCell {
    
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
            self.delegate?.didCalculateSize(indexPath:self.indexPath!,size: CGSize(width: self.screenWidth - 20, height: self.actualHeight ?? 0),elementType: storyDetailLayoutType.CommentCell)
            
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




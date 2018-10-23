//
//  StoryDetailController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import WebKit

class StoryDetailController: BaseController {
    
    var segmentContainerViewHeightAnchor : NSLayoutConstraint?
    var pageIndex:Int?
    
    var segmentContainerView:UIView = {
        let view  = UIView()
        view.addBlur(style: .light)
        view.clipsToBounds = true
        return view
    }()
    
    var segmentControl:UISegmentedControl = {
        let items = ["View","Counter View"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    
    var collectionView:UICollectionView = {
        let layout = StickyHeadersCollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(hexString: "#F4F4F4")
        
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        return collectionView
        
    }()
    
    var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.layer.zPosition = 999
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Please wait ...", attributes: attributes)
        
        return refreshControl
        
    }()
    
   lazy var navigationBar:CustomNavigationBar = {
        let navigationBar = CustomNavigationBar(delegate: self)
        return navigationBar
    }()
    
    override var state: ViewState<Any>?{
        didSet{
            update()
            
            switch state! {
            case .loaded(let storyLayoutWrapper):
                
                
                guard let unwrappedLayout = storyLayoutWrapper as? StoryLayoutWrapper else{
                    return
                }
                self.layoutWrapper = unwrappedLayout
                self.story = unwrappedLayout.story
                
                self.storyDetailLayout = unwrappedLayout.storyDetailLayout
                
                GoogleAnalytics.Track(with: AnalyticKeys.category.storyDetailScreen, value:story?.headline ?? AnalyticKeys.events.unknown.rawValue)
                
                MoengageAnalytics.TrackMoengageEvent(eventName: AnalyticKeys.MoengageEventName.storyViewed(story: self.story))
                
                //store-StoryForViewCounterView
                self.getViewCounterView(layoutObject:unwrappedLayout)
                
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }else{
                    self.createViews()
                }
                
                self.updateSegmenetViews()
                
                self.setupCollectionViewDataSource(storyLayoutWrapper:unwrappedLayout)
                
            case .error(let message):
                
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                    self.resetData()
                    self.collectionView.reloadData()
                }
                
                if story == nil{
                    errorView.displayErrorMessage(message: message)
                }else{
                    errorView.isHidden = true
                }
                
                
            case .needsReloading:
                
                break
                
            default:
                break
            }
        }
    }
    
    var viewCounterViewStoryDict:[ViewConterViewType:StoryLayoutWrapper] = [:]
    var currentViewCounterStoryType:ViewConterViewType = .Unknown
    var layoutWrapper:StoryLayoutWrapper?
    
    func getViewCounterView(layoutObject:StoryLayoutWrapper){
        
        if let viewType = story?.storyMetadata?.viewType{
            
            if viewType == .Unknown{
                
                switch currentViewCounterStoryType{
                    
                case .CounterView:
                    
                    story?.storyMetadata?.viewType = .View
                    viewCounterViewStoryDict[.View] = layoutObject
                    
                case .View:
                    
                    story?.storyMetadata?.viewType = .CounterView
                    viewCounterViewStoryDict[.CounterView] = layoutObject
                    
                case .Unknown:
                    //                    viewCounterViewStoryDict[.Unknown] = layoutObject
                    break
                }
            }else{
                viewCounterViewStoryDict[viewType] = layoutObject
            }
        }
    }
    
    var storySlug:String = ""
    
    var story:Story? = nil {
        didSet{
            if oldValue == nil{
                Quintype.analytics.trackPageViewStoryVisit(story: story!)
            }
        }
    }
    
    var dataSource : StoryDetailDataSourceAndDelegate?
    
    var viewCounterViewDataSource :[ViewConterViewType:StoryDetailDataSourceAndDelegate] = [:]
    var storyDetailLayout : [[StoryDetailLayout]] = []
    
    convenience init(slug:String) {
        self.init()
        self.storySlug = slug
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = .white
        self.addStateHandlingView(in: self.view)
        
        self.createNavigationBar()
        navigationBar.setSolidColorNavigationBar()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.story == .none{
            APIManager.shared.getStoryBySlug(controller: self, storySlug: self.storySlug)
            APIManager.shared.apiDelegate = self
            
        }
    }
    
    func setupRefreshControl(){
        if #available(iOS 10.0, *) {
            
            self.collectionView.refreshControl = refreshControl
            
        } else {
            collectionView.addSubview(refreshControl)
            
        }
        
        refreshControl.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)
        
    }
    
    @objc func refreshData(sender:UIRefreshControl){
        
        APIManager.shared.getStoryBySlug(controller: self, storySlug: self.storySlug)
        APIManager.shared.apiDelegate = self
    }
    
    func externalWebView(url:URLRequest) -> WKWebView{
        
        let webview = WKWebView()
        webview.load(url)
        webview.backgroundColor = .green
        return webview
        
    }
    
    func createViews(){
        
        
        if story?.story_template == StoryTemplet.Elsewhere{
            
            if let externalStoryUrl = story?.storyMetadata?.reference_url{
                if let externalUrl = URL(string: externalStoryUrl){
                    let externalUrlRequest = URLRequest(url: externalUrl)
                    let webView = externalWebView(url:externalUrlRequest)
                    webView.scrollView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
                    let externalStoryController = PopupController(customWebview: webView)
                    
                    self.addViewController(anyController: externalStoryController)
                    self.view.bringSubview(toFront: navigationBar)
                    return
                    
                }
            }
        }
        
        view.addSubview(collectionView)
        view.addSubview(segmentContainerView)
        segmentContainerView.addSubview(segmentControl)
        
        if let _ = self.layoutWrapper?.supplementaryView{
            navigationBar.isHidden = true
         segmentContainerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }else{
            navigationBar.isHidden = false
            segmentContainerView.anchor(navigationBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            collectionView.anchor(navigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
        
        segmentContainerViewHeightAnchor =  segmentContainerView.heightAnchor.constraint(equalToConstant: 0)
        segmentContainerViewHeightAnchor?.priority = UILayoutPriority.defaultHigh
        segmentContainerViewHeightAnchor?.isActive = true
        
        segmentControl.anchor(nil, left: segmentContainerView.leftAnchor, bottom: nil , right: segmentContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        segmentControl.anchorCenterYToSuperview()
        
//        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        segmentControl.addTarget(self, action: #selector(self.segmentChanged(sender:)), for: .valueChanged)
        segmentContainerView.isUserInteractionEnabled = true
        
        self.setupRefreshControl()
        
        
        
    }
    
    func setupCollectionViewDataSource(storyLayoutWrapper:StoryLayoutWrapper){
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        if self.story?.storyMetadata?.viewType == ViewConterViewType.View || self.story?.storyMetadata?.viewType == ViewConterViewType.CounterView{
            
            if (viewCounterViewDataSource[(self.story?.storyMetadata?.viewType)!] == nil){
                
                viewCounterViewDataSource[(self.story?.storyMetadata?.viewType)!] = StoryDetailDataSourceAndDelegate(layoutWrapper: storyLayoutWrapper, collectionview: collectionView, controller: self)
            }
            
            collectionView.delegate = viewCounterViewDataSource[(self.story?.storyMetadata?.viewType)!]
            collectionView.dataSource = viewCounterViewDataSource[(self.story?.storyMetadata?.viewType)!]
            
            
        }else{
            dataSource = StoryDetailDataSourceAndDelegate(layoutWrapper:storyLayoutWrapper, collectionview: collectionView, controller: self)
            collectionView.delegate = dataSource
            collectionView.dataSource = dataSource
            
        }
        
    }
    
    
    
    func updateSegmenetViews(){
        segmentContainerView.tintColor = ThemeService.shared.theme.primarySectionColor
        
        if self.story?.storyMetadata?.viewType == ViewConterViewType.View || self.story?.storyMetadata?.viewType == ViewConterViewType.CounterView{
            
            let storyMetadata = story?.storyMetadata
            self.segmentControl.selectedSegmentIndex = (storyMetadata?.viewType == ViewConterViewType.CounterView) ? 1 : 0
            self.segmentContainerViewHeightAnchor?.constant = 50
            
            self.collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset
            
        }
    }
    
    @objc func closeViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func segmentChanged(sender:UISegmentedControl){
        
        if self.story?.storyMetadata?.viewType == ViewConterViewType.View,let counterViewLayoutObject = viewCounterViewStoryDict[.CounterView] {
            
            self.filpCollectionView()
            self.state = ViewState.loaded(data: counterViewLayoutObject)
            
        }else if self.story?.storyMetadata?.viewType == ViewConterViewType.CounterView,let counterViewLayoutObject = viewCounterViewStoryDict[.View]{
            
            self.filpCollectionView()
            self.state = ViewState.loaded(data: counterViewLayoutObject)
            
        }else{
            
            guard let linkedStoryID = self.story?.storyMetadata?.linkedStory?.story_content_id else{
                return
            }
            
            currentViewCounterStoryType = self.story?.storyMetadata?.viewType ?? .Unknown
            
            APIManager.shared.getStoryById(controller: self, storyId: linkedStoryID)
            
            self.filpCollectionView()
        }
        
    }
    
    func filpCollectionView(){
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        self.collectionView.reloadData()
        
        let flipDirection = (self.story?.storyMetadata?.viewType == ViewConterViewType.View) ?  UIViewAnimationOptions.transitionFlipFromRight : UIViewAnimationOptions.transitionFlipFromLeft
        
        UIView.transition(from: self.collectionView, to: self.collectionView, duration: 0.5, options: [flipDirection,.showHideTransitionViews], completion: nil)
    }
    
    override func reTryRequested() {
        APIManager.shared.getStoryBySlug(controller: self, storySlug: storySlug)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setSolidNavigationBar()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        setSolidNavigationBar()
    }
    
}

extension StoryDetailController: APIManagerDelegate {
    
    func didFailWithError(error: String) {
        print(error)
    }
    
    func engagmentLoaded() {
        if self.collectionView.numberOfSections > 0{
            
            let items = self.collectionView.numberOfItems(inSection: 0)
            
            
            if items > 0{
                
                if let socialShareIndex = self.storyDetailLayout[0].index(where: {$0.layoutType == storyDetailLayoutType.SocialShareCell}),
                    let socialShareCell = self.collectionView.cellForItem(at: IndexPath(item: socialShareIndex, section: 0)) as? SocialShareCell{
                    socialShareCell.configure(data: self.story)
                }
                
                //                self.collectionView.reloadItems(at: [IndexPath(item: items - 1, section: 0)])
            }
        }
    }
    
    func shouldReload(){
        
        self.collectionView.reloadData()
    }
    
    func resetData(){
        self.dataSource = nil
        self.story = nil
    }
}
extension StoryDetailController{
    
    func createNavigationBar(){
        view.addSubview(navigationBar)
        
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.delegate = self
        if #available(iOS 11, *) {
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
    }
}

extension StoryDetailController: UINavigationBarDelegate{
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

extension StoryDetailController:NavigationItemDelegate {
    func searchBarButtonPressed(){
        
    }
    func hamburgerBarButtonPressed(){
        
    }
}

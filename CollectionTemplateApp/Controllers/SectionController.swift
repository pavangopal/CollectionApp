//
//  SectionController.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/17/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import XLPagerTabStrip

class SectionController:BaseController {
    //MARK: - Views
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(hexString: "#F4F4F4")
        
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        return collectionView
        
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.gray]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Please wait ...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)
        
        return refreshControl
        
    }()
    
    lazy var navigationBar:CustomNavigationBar = {
        let navigationBar = CustomNavigationBar(delegate: self)
        navigationBar.setSolidColorNavigationBar()
        navigationBar.setBackNavigationBarButton()
        return navigationBar
    }()
    
    //MARK: - Variables
    
    var slug:String
    var dataSource:CollectionViewDataSource?
    
    var sectionViewModel:SectionViewModel! {
        didSet {

            sectionViewModel.state.bind = {[unowned self] (state:ViewState<Any>) in
                self.state = state
            }
        }
    }
    
    override var state: ViewState<Any>?{
        didSet{
            
            if refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            
            update()
            
            switch state! {
                
            case .loaded(let layoutArray):
                guard let layoutArray = layoutArray as? [[SectionLayout]] else{return}
                
                dataSource?.updateNextPage(layout: layoutArray)
                
            case .error(let message):
                
                errorView.displayErrorMessage(message: message)
                
                break
                
            default:
                break
            }
        }
    }
    
    
    //MARK: - Functions
    init(slug:String) {
        
        self.slug = slug
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        createNavigationBar()
        createViews()
        
        setupCollectionViewDataSource()
        self.sectionViewModel = SectionViewModel(slug: self.slug)
        self.sectionViewModel.startFetch()
    }
    
    private func createViews(){
        self.view.addSubview(collectionView)
        collectionView.anchor(navigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.refreshControl = refreshControl
        addStateHandlingView(in: self.view)
    }
    
    private func setupCollectionViewDataSource(){
        
        dataSource = CollectionViewDataSource(collectionView: collectionView, controllerDataSource: self)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
    }
    
    @objc func refreshData(sender:UIRefreshControl){
        if !Http.isInternetAvailable(){
            return
        }
        self.dataSource?.resetDataSource()
        self.sectionViewModel = SectionViewModel(slug: slug)
        self.sectionViewModel.startFetch()
    }
    
    override func reTryRequested() {
        //Retry only one api call
        if !Http.isInternetAvailable(){
            return
        }
        
        self.sectionViewModel.loadNext()
    }
    
   
}

extension SectionController: ControllerDataSourcing {
    func didSelectItem(sectionLayoutArray: [[SectionLayout]], indexPath: IndexPath) {

        let flatSectionArray = sectionLayoutArray.flatMap({$0})
        let currentIndex = flatSectionArray.firstIndex(where: {$0.story?.slug == sectionLayoutArray[indexPath.section][indexPath.row].story?.slug})
        let controller = StoryDetailPager(homeLayoutArray: flatSectionArray, currentIndex: currentIndex ?? 0, currentSlug: sectionLayoutArray[indexPath.section][indexPath.row].story?.slug ?? "")
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    func canLoadNextPage() -> Bool {
        return sectionViewModel.isMoreDataAvailable.value ?? false
    }
    
    func loadNextPage() {
        sectionViewModel.loadNext()
    }
    
}


extension SectionController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title:slug.capitalized, image:nil, highlightedImage: nil)
    }
}


extension SectionController {
    
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

extension SectionController: UINavigationBarDelegate{
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

extension SectionController: NavigationItemDelegate {
    func searchBarButtonPressed(){
        
    }
    func hamburgerBarButtonPressed(){
        
    }
}

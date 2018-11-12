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

class SectionController : BaseController {
    //MARK: - Views
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(hexString: "#F4F4F4")
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
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

    
    //MARK: - Variables
    
    var slug:String
    var dataSource:CollectionViewDataSource?
    var tabTitle: String?
    
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
    
    convenience init(menu:Menu){
        self.init(slug: menu.section_slug ?? "")
        
        self.tabTitle = menu.title?.capitalized ?? "Latest"
        
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
        print("self.slug: \(self.slug)")
        
        self.setupNavgationbar()
//        createNavigationBar()
        createViews()
        
        setupCollectionViewDataSource()
        self.sectionViewModel = SectionViewModel(slug: self.slug)
        self.sectionViewModel.startFetch()
        
    }
    
    private func createViews(){
        view.addSubview(collectionView)
        collectionView.fillSuperview()
//        collectionView.anchor(self.view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        collectionView.refreshControl = refreshControl
        collectionView.addSubview(refreshControl)
        addStateHandlingView(in: self.view)
        view.backgroundColor = .white
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
        
        return IndicatorInfo(title:tabTitle, image:nil, highlightedImage: nil)
    }
}


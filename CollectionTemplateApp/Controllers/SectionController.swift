//
//  SectionController.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/17/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

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
    
    //MARK: - Variables
    
    var slug:String
    var dataSource:CollectionViewDataSource?
    
    var tagViewModel:SectionViewModel! {
        didSet {

            tagViewModel.state.bind = {[unowned self] (state:ViewState<Any>) in
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
        
        createViews()
        setupCollectionViewDataSource()
        self.tagViewModel = SectionViewModel(slug: self.slug)
        self.tagViewModel.startFetch()
        
    }
    
    private func createViews(){
        self.view.addSubview(collectionView)
        collectionView.fillSuperview()
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
        self.tagViewModel = SectionViewModel(slug: slug)
        self.tagViewModel.startFetch()
    }
    
    override func reTryRequested() {
        //Retry only one api call
        if !Http.isInternetAvailable(){
            return
        }
        
        self.tagViewModel.loadNext()
    }
    
}

extension SectionController: ControllerDataSourcing {
    
    func canLoadNextPage() -> Bool {
        return tagViewModel.isMoreDataAvailable.value ?? false
    }
    
    func loadNextPage() {
        tagViewModel.loadNext()
    }
    
}


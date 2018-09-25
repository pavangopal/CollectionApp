//
//  SearchController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/12/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

enum searchLayoutType:String{
    case searchCell = "searchCell"
    
}

class SearchResult{
    
    var headline:String?
    var imageLink:String?
    var slug:String?
    var imageMeta:ImageMetaData?
    
}

class SearchController: BaseController {
    
    lazy var searchBar:UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.becomeFirstResponder()
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        searchBar.barTintColor = ThemeService.shared.theme.primarySectionColor
        searchBar.isTranslucent = true
        searchBar.searchBarStyle  = UISearchBarStyle.minimal
        searchBar.placeholder = "Search for"
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        return searchBar
    }()
    
    var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .white
        return collectionView
        
    }()
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(SearchController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        
        return refreshControl
    }()
    
    
    override var state: ViewState<Any>?{
        didSet{
            update()
            
            switch state! {
                
            case .error(let message):
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                    self.resetData()
                    self.collectionView.reloadData()
                }
                if storiesArray.count == 0{
                    self.errorView.displayErrorMessage(message: message)
                }else{
                    self.errorView.isHidden = true
                }
                
                
            case .loaded(let data):
                
                guard let tuple = data as? (count:NSNumber?,storyArray:[Story]?),let storyArray = tuple.storyArray,let count = tuple.count else{
                    return
                }
                
                if storyArray.count == 0{
                    shouldLoadMore = false
                }else{
                    self.offset +=  self.limit
                    shouldLoadMore = true
                }
                
                self.totalCount = count
                
                if self.storiesArray.count == 0 {
                    self.collectionView.reloadData()
                }
                
                if refreshControl.isRefreshing{
                    refreshControl.endRefreshing()
                    self.storiesArray = storyArray
                    self.collectionView.reloadData()
                }else{
                    self.collectionView.performBatchUpdates({
                        
                        var indexPathArray = [IndexPath]()
                        
                        let beforeCount = self.storiesArray.count
                        self.storiesArray.append(contentsOf: storyArray)
                        
                        for index in beforeCount..<self.storiesArray.count {
                            indexPathArray.append(IndexPath(item: index, section: 1))//first section
                        }
                        
                        self.collectionView.insertItems(at: indexPathArray)
                        
                        
                    }, completion: nil)
                }
                
            default:
                break
            }
        }
    }
    
    var searchActive : Bool = false
    var storiesArray:[Story] = []
    var sizingCells:[String:BaseCollectionCell] = [:]
    var totalCount: NSNumber?
    var offset:Int = 0
    var limit:Int = 20
    var shouldLoadMore = false
    var currentSearchString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addStateHandlingView(in: self.view)
        self.view.backgroundColor = .white

        view.addSubview(collectionView)
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.addSubview(refreshControl)
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchLayoutType.searchCell.rawValue)
        collectionView.register(LoadingCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing:LoadingCell.self))
        
        collectionView.register(cellClass: SearchCountCell.self)
        let searchCell = SearchCell.init(frame: CGRect.zero)
        searchCell.completion(MarginD(templet: .Default))
        sizingCells[searchLayoutType.searchCell.rawValue] = searchCell
        
 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.subviews.forEach({ (view) in
            if view.accessibilityIdentifier == "navigarionBottomLine"{
                view.backgroundColor = ThemeService.shared.theme.primarySectionColor
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.titleView = nil
        self.navigationController?.navigationBar.subviews.forEach({ (view) in
            if view.accessibilityIdentifier == "navigarionBottomLine"{
                view.backgroundColor = .white
            }
        })
    }
    
    func searchWithText(searchText:String?){
        
        if let searchKey = searchText, searchKey.count > 0{
            
            Quintype.api.search(searchBy: searchOption.key(string:searchKey), fields:nil, offset: offset, limit: 20, cache: cacheOption.none, Success: { (data) in
           
                let tuple:(count:NSNumber?,storyArray:[Story]?) = (count:data?.total,storyArray: data?.stories)
                self.state = ViewState.loaded(data: tuple)
                self.getUserEngagment(storyArray: data?.stories ?? [])
                
            }, Error: { (error) in
                
                self.state = ViewState.error(message: error ?? "")
                
            })
            
        }
        
    }
    
    override func reTryRequested() {
        self.resetData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.totalCount = nil
        offset = 0
        searchWithText(searchText: currentSearchString)
    }
}


extension SearchController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resetData()
        
        self.state = ViewState.loading
        searchActive = false;
        currentSearchString = searchBar.text
        searchWithText(searchText: currentSearchString)
        
    }
    
    func resetData() {
        self.storiesArray.removeAll()
        self.totalCount = nil
        self.offset = 0
        self.collectionView.reloadData()
    }
}
extension SearchController{
    func getUserEngagment(storyArray:[Story]){
        
//        DispatchQueue.global(qos: .background).async {
//            let userEngagmentManager = UserEngagmentApiManager()
//            
//            
//            let storyIdArray = storyArray.filter({$0.id != nil}).map({$0.id!})
//            
//            userEngagmentManager.getBulkEngagmentCount(storyIdArray: storyIdArray, completion: { (storyIdEngagmentDict) in
//                
//                for story in storyArray{
//                    innerLoop: for (storyId,engagment) in storyIdEngagmentDict{
//                        if story.id == storyId{
//                            story.engagment = engagment
//                            break innerLoop
//                        }
//                        
//                    }
//                    
//                }
//                
//                DispatchQueue.main.async {
//                    let visibleIndexPathArray = self.collectionView.indexPathsForVisibleItems
//                    self.collectionView.reloadItems(at: visibleIndexPathArray)
//                }
//                
//                
//            }) { (errorMessage) in
//                DispatchQueue.main.async {
//                    print(errorMessage)
//                }
//                
//            }
//        }
        
        
    }
}





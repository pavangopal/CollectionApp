//
//  AuthorController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/11/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class AuthorController: BaseController,AuthorApiMangerDelegate {
    
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white//UIColor(hexString: "#F4F4F4")
        return collectionView
        
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(AuthorController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    lazy var navigationBar:CustomNavigationBar = {
        let navigationBar = CustomNavigationBar(delegate: self)
        navigationBar.setSolidColorNavigationBar()
        navigationBar.setBackNavigationBarButton()
        return navigationBar
    }()
    
    var authorId:Int!
    
    var author:Author?{
        didSet{
            print("Author detail fetched")
            self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    var storiesArray:[Story] = []
    var apiManager = AuthorApiManger()
    var sizingCells:[String:BaseCollectionCell] = [:]
    var isMoreDataAvailable = false
    
    override var state: ViewState<Any>?{
        didSet {
            
            
            
            switch state! {
            case .loaded(let data):
                print("Author Stories fetched")
                
                guard let stories = data as? [Story] else{
                    return
                }
                
                if stories.count == 0{
                    isMoreDataAvailable = false
                }else{
                    isMoreDataAvailable = true
                }
                
                if refreshControl.isRefreshing{
                    refreshControl.endRefreshing()
                    self.storiesArray = stories
                    self.collectionView.reloadData()
                }else{
                    self.collectionView.performBatchUpdates({
                        
                        var indexPathArray = [IndexPath]()
                        
                        let beforeCount = self.storiesArray.count
                        self.storiesArray.append(contentsOf: stories)
                        
                        for index in beforeCount..<self.storiesArray.count {
                            indexPathArray.append(IndexPath(item: index, section: 1))//first section
                        }
                        
                        self.collectionView.insertItems(at: indexPathArray)
                        
                        
                    }, completion: nil)
                }
                
            case .error(let message):
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                    self.storiesArray.removeAll()
                    self.collectionView.reloadData()
                }
                
                if storiesArray.count == 0{
                    errorView.displayErrorMessage(message: message)
                }else{
                    errorView.isHidden = true
                }
                
            case .loading:
                self.update()
                
            default:
                break
                
            }
        }
    }
    
    required init(authorId:Int) {
        super.init()
        self.authorId = authorId
        Quintype.analytics.trackAuthorProfileVisit(authorId: authorId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigationBar()
        self.addStateHandlingView(in: self.view)
        
        self.view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        collectionView.anchor(navigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cells = [AutherHeaderCell.self,LeftImageListCell.self]
        
        for cell in cells {
            collectionView.register(cellClass: cell)
            let sizingCell = cell.self.init()
            sizingCells[cell.reuseIdentifier] = sizingCell
        }
        
        collectionView.register(LoadingCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing:LoadingCell.self))
        
        apiManager.apiDelegate = self
        
        self.state = .loading
        apiManager.getAuthorDetail(authorId: self.authorId)
        apiManager.getStoriesForAuthor(authorId: self.authorId, controller: self)
        
    }
    
    func didFetchAuthor(author:Author) {

        self.author = author
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
    func didFetchUserEngagment() {
        let visibleIndexPathArray = self.collectionView.indexPathsForVisibleItems
        self.collectionView.reloadItems(at: visibleIndexPathArray)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.apiManager.offset = 0
        apiManager.getAuthorDetail(authorId: self.authorId)
        apiManager.getStoriesForAuthor(authorId: self.authorId, controller: self)
        
    }
}

extension AuthorController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.storiesArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = collectionView.dequeueReusableCell(ofType: AutherHeaderCell.self, for: indexPath)
            cell.configure(data: self.author)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(ofType: LeftImageListCell.self, for: indexPath)
            cell.configure(data: self.storiesArray[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let targetSize =  CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        
        switch indexPath.section {
        case 0:
            
            let sizingCell = sizingCells["AutherHeaderCell"] as? AutherHeaderCell
            sizingCell?.configure(data:self.author)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            return calculatedSize!
            
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            self.navigateToStory(story: self.storiesArray[indexPath.row], indexPath: indexPath)
        default:
            break
        }
    }
    
    func navigateToStory(story:Story,indexPath:IndexPath){
        let slugArray = self.storiesArray.map({$0.slug ?? ""})
        let storyDetailPager = StoryDetailPager(slugArray: slugArray, currentIndex: indexPath.row)
        
        self.navigationController?.pushViewController(storyDetailPager, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionFooter:
            
            let loadingCell = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing:LoadingCell.self), for: indexPath) as! LoadingCell
            
            loadingCell.showAcitvityIndicator()
            return loadingCell
            
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        switch elementKind {
            
        case UICollectionElementKindSectionFooter:
            
            if indexPath.section == 1 && self.isMoreDataAvailable{
                self.getMoreData()
            }
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == 1 && self.isMoreDataAvailable{
            return CGSize(width: UIScreen.main.bounds.width, height: 80)
        }
        
        return .zero
    }
    
    func getMoreData(){
        apiManager.getStoriesForAuthor(authorId: self.authorId, controller: self)
    }
}

extension AuthorController{
    
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

extension AuthorController: UINavigationBarDelegate{
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

extension AuthorController: NavigationItemDelegate {
    func searchBarButtonPressed(){
        
    }
    func hamburgerBarButtonPressed(){
        
    }
}

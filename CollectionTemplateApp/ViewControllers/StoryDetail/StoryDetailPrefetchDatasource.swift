//
//  StoryDetailPrefetchDatasource.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 1/29/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

class      StoryDetailPrefetchDatasource:NSObject,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDataSourcePrefetching,UICollectionViewDelegateFlowLayout {
    
    var tableCollectionView: UICollectionView?
    //basic requirements
    var story:Story?
    weak  var collectionView:UICollectionView!
    weak var controller:BaseController!
    var layout : [[StoryDetailLayout]] = []
    
    //caching variables
    var jsEmbbedCellIdentifiers : [String] = []
    var youtubeCellIdentifiers:[String] = []
    
    var collapsedIndexPath: [IndexPath:Bool] = [:]
    
    var lazyLoadedCellHeight : [IndexPath:CGSize] = [:]
    var selectedIndexPath : IndexPath?
    
    var heightCache:[IndexPath:CGSize] = [:]
    
    var sizingCells:[String:BaseCollectionCell] = [:]
    
    var selectedOrder = SortingOrder.New
    let transition = Animator()
    
    
    var cachedHeightsForTableStoryElement:[IndexPath:CGFloat] = [:]
    static var COLLECTIONVIEW_OBS_CONTEXT:Int = 0
    
    
    //Call Backs to controllers
    public var selectedCallback : ((_ layout:[[StoryDetailLayout]],_ indexPath:IndexPath)->Void)?
    public var scrollViewDidScroll:((_ contentOffset:CGPoint) -> ())?
    
    var margin: MarginD!
    
    required init (layout:[[StoryDetailLayout]],story:Story,collectionview:UICollectionView,controller:BaseController,sizingCell:[String:BaseCollectionCell]? = nil,margin: MarginD){
        super.init()
        self.margin = margin
        self.heightCache = [:]
        self.story = story
        self.collectionView = collectionview
        self.controller = controller
        self.layout = layout
        
        if let sizingCells = sizingCell{
            self.sizingCells = sizingCells
        }else{
            self.registerCells()
        }
        
        //for Liveblog
        self.selectedOrder = (story.storyMetadata?.is_closed ?? false) ? SortingOrder.Old : SortingOrder.New
        
    }
    
    required init(layout:[[StoryDetailLayout]],story:Story,controller:BaseController,margin: MarginD) {
        self.margin = margin
        self.layout = layout
        self.story = story
        self.controller = controller
    }
    
    func registerCells(){
        //TODO: should be removed
        collectionView.register(BaseCollectionCell.self, forCellWithReuseIdentifier: String(describing:BaseCollectionCell.self))
        
        let storyTypeArray = Set(self.layout.flatMap({$0}).map({$0.layoutType}))
        
        var cells:[BaseCollectionCell.Type] = []
        
        for type in storyTypeArray{
            if let cell = NSObject.swiftClassFromString(className: type.rawValue) as? BaseCollectionCell.Type{
                cells.append(cell)
            }
        }
        
        cells.forEach { (cell) in
            collectionView.register(cellClass: cell)
            let cellD = cell.self.init()
            self.sizingCells[cell.reuseIdentifier] = cellD
        }
        
        collectionView.register(cellClass: TableStoryElement.self)
    }
    
    //MARK: CollectionView's DataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return layout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layout[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell?
        
        let cellType = layout[indexPath.section][indexPath.row].layoutType
        let storyElement = layout[indexPath.section][indexPath.row].storyElement
        
        if cellType == .StoryTextElementCell{
            cell = collectionView.dequeueReusableCell(ofType: StoryTextElementCell.self, for: indexPath)
            let currentCell = cell as? StoryTextElementCell
            
            currentCell?.configure(data: storyElement)
            
        }else{
            cell = collectionView.dequeueReusableCell(ofType: BaseCollectionCell.self, for: indexPath)
            cell?.contentView.backgroundColor = .red
            
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetSize = CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        
        let cellType = layout[indexPath.section][indexPath.row].layoutType
        let storyElement = layout[indexPath.section][indexPath.row].storyElement
        let sizingCell = sizingCells[cellType.rawValue]
        
        if cellType == .StoryTextElementCell{
            
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        }else{
            return CGSize(width: collectionView.bounds.width, height: 40)
        }
        
        
    }
    
    
    // MARK: UICollectionViewDataSourcePrefetching
    
    /// - Tag: Prefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
//        for indexPath in indexPaths {
//        }
    }
    
    /// - Tag: CancelPrefetching
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
//        for indexPath in indexPaths {
//            print(#function + "indexPath:\(indexPath)")
//        }
    }
}


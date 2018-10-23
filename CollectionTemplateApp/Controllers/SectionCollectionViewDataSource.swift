//
//  SectionCollectionViewDataSource.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

private protocol CollectionViewDataSourceModelling:class {
    associatedtype DataSource
    
    var sectionLayoutArray:[[SectionLayout]] {get set}
    var controllerDataSource:DataSource? {get set}
    var collectionView:UICollectionView? {get set}
    
    func updateNextPage(layout:[[SectionLayout]])
    func resetDataSource()
    
    init(collectionView:UICollectionView,controllerDataSource:DataSource)
    
}

class CollectionViewDataSource: NSObject,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout,
                                CollectionViewDataSourceModelling {
    
    typealias DataSource = ControllerDataSourcing
    
    var registeredCellIdentifiers: Set<String> = Set<String>()
    
    fileprivate var sectionLayoutArray:[[SectionLayout]] = []
    fileprivate weak var controllerDataSource:DataSource?
    fileprivate weak var collectionView:UICollectionView?
    
    required init(collectionView: UICollectionView, controllerDataSource: DataSource) {
        self.collectionView = collectionView
        self.controllerDataSource = controllerDataSource
    }
    
    //MARK: - DataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionLayoutArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionLayoutArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: BaseCollectionCell
        let layout = self.sectionLayoutArray[indexPath.section][indexPath.row]
        
        if !(registeredCellIdentifiers.contains(layout.homeCellType.rawValue)) {
            registeredCellIdentifiers.insert(layout.homeCellType.rawValue)
            collectionView.register(cellClass: layout.homeCellType.cell)
        }
        
        //Based on What data is passed to Config function
        //TODO: change different types of data to type Any
        
        switch layout.homeCellType {
            
        case .collectionTitleCell:
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as! BaseCollectionCell
            cell.configure(data: layout.data,associatedMetaData:layout.associatedMetaData)
            
        case .carousalContainerCell,.linerGalleryCarousalContainer:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as! BaseCollectionCell
            cell.delegate = self
            cell.configure(data: layout.carouselModel,associatedMetaData:layout.associatedMetaData)
            
        case .fourColumnGridCell,.imageTextDescriptionCell:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as! BaseCollectionCell
            cell.configure(data: layout.story,associatedMetaData:layout.associatedMetaData)
            
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as! BaseCollectionCell
            cell.configure(data: layout.storyViewModel,associatedMetaData:layout.associatedMetaData)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = self.sectionLayoutArray[indexPath.section][indexPath.row]
        let width = UIScreen.main.bounds.width - 30
        let targetSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        switch layout.homeCellType{
            
        case .collectionTitleCell:
            return CGSize(width: width, height: 50)
            
        case .fourColumnGridCell:
            return CGSize(width: width, height: 300)
            
        case .carousalContainerCell,.linerGalleryCarousalContainer:
            let size = CGSize(width: targetSize.width, height: (layout.carouselModel?.estimatedInnerCellHeight ?? 0) + CGFloat(20))
            return size
            
        default:
            return layout.storyViewModel?.preferredSize ?? .zero
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard  let layout = self.sectionLayoutArray[section].first else{
            return .zero
        }
        
        switch layout.collectionLayoutType ?? .UNKNOWN {
            
        case .FullscreenLinearGallerySlider:
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
            
        default:
            return UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        }
        
    }
}
//MARK: - Delegate methods

extension CollectionViewDataSource : UICollectionViewDelegate, BaseCollectionCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let collection = sectionLayoutArray[indexPath.section][indexPath.row].collection,let controller = controllerDataSource as? UIViewController{
            let sectionController = SectionController(slug: collection.slug ?? "")
            controller.navigationController?.pushViewController(sectionController, animated: true)
        }else{
            self.controllerDataSource?.didSelectItem(sectionLayoutArray: sectionLayoutArray, indexPath: indexPath)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
            
        case UICollectionElementKindSectionFooter:
            
            if indexPath.section == sectionLayoutArray.count - 1 && (controllerDataSource?.canLoadNextPage() ?? false) {
                controllerDataSource?.loadNextPage()
            }
            
        default:
            print("Should Never execute")
            break
        }
    }
    
    func didSelectCarousalStoryAtIndex(index: Int, storyArray: [StoryViewModel]) {
        if let sectionController = controllerDataSource as? UIViewController {
            let controller = StoryDetailPager(slugArray: storyArray.map({$0.storySlug ?? ""}), currentIndex: index)
            sectionController.navigationController?.pushViewController(controller, animated: true)
        }
//       self.controllerDataSource?.didSelectItem(sectionLayoutArray: sectionLayoutArray, indexPath: indexPath)
    }
    
    func didCalculateSize(indexPath:IndexPath,size:CGSize,elementType:storyDetailLayoutType){}
    func shouldNavigateTo(controller:UIViewController){}
}

//MARK: - Supplimentary View methods

extension CollectionViewDataSource{
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == sectionLayoutArray.count - 1 && (controllerDataSource?.canLoadNextPage() ?? false){
            return CGSize(width: UIScreen.main.bounds.width-30, height: 120)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if !(registeredCellIdentifiers.contains(LoadingCell.reuseIdentifier)) {
            registeredCellIdentifiers.insert(LoadingCell.reuseIdentifier)
            collectionView.register(LoadingCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: LoadingCell.reuseIdentifier)
        }
        
        switch kind {
            
        case UICollectionElementKindSectionFooter:
            
            let loadingCell = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing:LoadingCell.self), for: indexPath) as! LoadingCell
            
            loadingCell.showAcitvityIndicator()
            return loadingCell
            
        default:
            print("Should Never execute")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

//MARK: - DataManipulation methods

extension CollectionViewDataSource {
    
    public func updateNextPage(layout:[[SectionLayout]]){
        guard let collectionView = collectionView else{return}
        
        collectionView.performBatchUpdates({
            var indexPathArray = [IndexPath]()
            
            //section
            let beforeCount = sectionLayoutArray.count
            sectionLayoutArray.append(contentsOf: layout)
            
            for sectionIndex in beforeCount..<sectionLayoutArray.count {
                
                let sectionSet = IndexSet(integer: sectionIndex)
                collectionView.insertSections(sectionSet)
                
                for itemIndex in 0..<sectionLayoutArray[sectionIndex].count{
                    indexPathArray.append(IndexPath(item: itemIndex, section: sectionIndex))
                }
            }
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.insertItems(at: indexPathArray)
            
        }, completion: { (flag) in
            if flag{
                print("Completed")
            }else{
                print("Not - Completed")
            }
        })
    }
    
   public func resetDataSource(){
        sectionLayoutArray.removeAll()
        collectionView?.reloadData()
    }
}

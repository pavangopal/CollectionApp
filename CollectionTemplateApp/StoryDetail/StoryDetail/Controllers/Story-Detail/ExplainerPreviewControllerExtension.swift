//
//  ExplainerPreviewControllerExtension.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/24/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype

extension ExplainerPreviewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.layoutArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == indexCollectionView{
            let cell = collectionView.dequeueReusableCell(ofType: ExplainerCardIndexCell.self, for: indexPath)
            cell.completion(self.margin)
            cell.configure(index: indexPath.row, ishighlighted: currentCardIndex == indexPath.row,layout:self.layoutArray[indexPath.row], story:story)
            
            cell.indexButtonAction = {[weak self](index) -> () in
                self?.currentCardIndex = index
                self?.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
            
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(ofType: ExplainerPreviewCell.self, for: indexPath)
            cell.explainerCellDelegate = self
            cell.completion(self.margin)
            
            if #available(iOS 10.0, *) {
                cell.configure(dataSource: .none, animated: false)
            }else{
                cell.configureCell(layout: [self.layoutArray[indexPath.row]], story: story, controller: self)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == indexCollectionView{
            return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        }
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == indexCollectionView{
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == indexCollectionView{
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == indexCollectionView{
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets.zero
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        for cell in self.collectionView.visibleCells{
            
            self.oldInnerCollectionViewYContentOffset = 0
            
            if let indexPath = collectionView.indexPath(for: cell){
                
                currentCardIndex = indexPath.row
            }
        }
    }
}


extension ExplainerPreviewController:UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if #available(iOS 10.0, *){
            
            guard let cell = cell as? ExplainerPreviewCell else {
                return
            }
            
            let updateCellClouse:(StoryDetailDataSourceAndDelegate?)->() = {[unowned self] (dataSource) in
                cell.configure(dataSource: dataSource, animated: true)
                self.loadingOperations.removeValue(forKey: indexPath)
            }
            
            if let dataLoader = loadingOperations[indexPath]{
                if let dataSource = dataLoader.dataSource{
                    cell.configure(dataSource: dataSource,animated:false)
                    self.loadingOperations.removeValue(forKey: indexPath)
                }else{
                    dataLoader.loadingCompleteHandler = updateCellClouse
                }
            }else{
                
                let dataSource = StoryDetailDataSourceAndDelegate(layout: [self.layoutArray[indexPath.row]], story: self.story,controller:self)
                let dataLoader = DataLoadOperation(dataSource)
                
                dataLoader.loadingCompleteHandler = updateCellClouse
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if #available(iOS 10.0, *){
            if let dataLoader = loadingOperations[indexPath]{
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
                
            }
        }
    }
    
    @available(iOS 10.0, *)
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths{
            if let _ = loadingOperations[indexPath]{
                return
            }
            
            let dataSource = StoryDetailDataSourceAndDelegate(layout: [self.layoutArray[indexPath.row]], story: self.story,controller:self)
            let dataLoader = DataLoadOperation(dataSource)
            
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
            
        }
    }
    
    @available(iOS 10.0, *)
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}

extension ExplainerPreviewController:ExplainerPreviewCellDelegate{
    
    func innerCollectionViewDidScroll(contentOffset: CGPoint,scrollView:UIScrollView) {
        let offset = contentOffset.y
        
        if scrollView.contentSize.height < (collectionView.bounds.height + 150){
            
            if offset < 0{
                self.indexCollectionViewHeightConstraint?.constant = 100
                self.collectionViewTopConstraint?.constant = UIScreen.main.bounds.height - 150
                self.indexCollectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
            }else{
                return
            }
        }
        
        if offset < 0 {
            self.indexCollectionViewHeightConstraint?.constant = 100
            self.collectionViewTopConstraint?.constant = UIScreen.main.bounds.height - 150
            self.indexCollectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            return
        }
        
        if(self.oldInnerCollectionViewYContentOffset > scrollView.contentOffset.y) &&
            self.oldInnerCollectionViewYContentOffset < (scrollView.contentSize.height - scrollView.frame.height) {
            // move up
            
            if offset > 1{
                
                self.indexCollectionViewHeightConstraint?.constant = 100 - (min(50, offset))
                self.collectionViewTopConstraint?.constant = UIScreen.main.bounds.height - (self.indexCollectionViewHeightConstraint?.constant)! - 50
                self.indexCollectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
            }
            else if offset < 0{
                
                if self.oldInnerCollectionViewYContentOffset > 0{
                    self.indexCollectionViewHeightConstraint?.constant = 100
                    self.collectionViewTopConstraint?.constant = UIScreen.main.bounds.height - 150
                    self.indexCollectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }
            
        }else if (self.oldInnerCollectionViewYContentOffset < scrollView.contentOffset.y
            && scrollView.contentOffset.y > 0) {
            // move down
            
            if offset > 0{
                
//                if (self.indexCollectionViewHeightConstraint?.constant)! > 100 - (min(50, offset)){
                
                    self.indexCollectionViewHeightConstraint?.constant = 100 - (min(50, offset))
                    self.collectionViewTopConstraint?.constant = UIScreen.main.bounds.height - (self.indexCollectionViewHeightConstraint?.constant)!
                    self.indexCollectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    
//                }
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            
        }
        
        self.oldInnerCollectionViewYContentOffset = scrollView.contentOffset.y
        
    }
}





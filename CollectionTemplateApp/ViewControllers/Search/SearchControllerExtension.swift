//
//  SearchController1Extension.swift
//  CoreApp-iOS
//
//  Created by Albin CR on 2/14/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//
import Quintype

extension SearchController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell?
        
        switch indexPath.section {
        case 0:
            
            cell = collectionView.dequeueReusableCell(ofType: SearchCountCell.self, for: indexPath)
            let currentCell = cell as? SearchCountCell
            
            currentCell?.configure(data: self.totalCount)
            return cell!
            
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchLayoutType.searchCell.rawValue, for: indexPath)
            let currentCell = cell as? SearchCell
                        
            currentCell?.configure(data: self.storiesArray[indexPath.row])
            return cell!
        }
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return storiesArray.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            
            return CGSize(width: collectionView.bounds.width, height: 50)
            
        default:
            let targetSize =  CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
            let sizingCell:BaseCollectionCell?
            sizingCell = sizingCells[searchLayoutType.searchCell.rawValue]
            sizingCell?.configure(data: storiesArray[indexPath.row])
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            return calculatedSize!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        let slugArrray = storiesArray.map({$0.slug ?? ""})
        Quintype.analytics.trackSearchItemClick(storySlug:slugArrray[indexPath.row] ?? AnalyticKeys.events.unknown.rawValue)
        let storyDetailPager = StoryDetailPager(slugArray: slugArrray, currentIndex: indexPath.row)
        
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
            
            if indexPath.section == 1 && self.shouldLoadMore{
                self.searchWithText(searchText: self.currentSearchString)
            }
            
        default:
            break
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section ==  1 && self.shouldLoadMore{
            return CGSize(width: UIScreen.main.bounds.width, height: 80)
        }
        
        return .zero
        
    }
    
    func tracker(){
        
        Quintype.analytics.trackPageViewSearchResults()

    }
    
    
}

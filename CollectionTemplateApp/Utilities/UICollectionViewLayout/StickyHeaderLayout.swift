//
//  StickyHeadersCollectionViewFlowLayout.swift
//  StickyHeaders
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit

class StickyHeadersCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Collection View Flow Layout Methods
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Helpers
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                // Add Layout Attributes
                newLayoutAttributes.append(layoutAttributesSet)
            }
            
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
            newLayoutAttributes.append(sectionAttributes)
        }
        
        return newLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        
        guard let collectionView = collectionView else { return layoutAttributes }
        
        // Helpers
        let contentOffsetY = collectionView.contentOffset.y

        var newRect = CGRect.zero
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationBarHeight:CGFloat = statusBarHeight + 44
        
        if indexPath == IndexPath(item: 0, section: 0){
            if collectionView.contentOffset.y > (layoutAttributes.bounds.height - navigationBarHeight){
                
                newRect = CGRect(x: 0, y: contentOffsetY, width: layoutAttributes.frame.width, height: navigationBarHeight)
                
            }else{
                newRect = CGRect(x: 0, y: contentOffsetY, width: layoutAttributes.frame.width, height: layoutAttributes.bounds.height-contentOffsetY)
            }
            
        }else{
            newRect = CGRect(x: 10, y: layoutAttributes.frame.origin.y+layoutAttributes.bounds.height, width: layoutAttributes.frame.width, height: layoutAttributes.frame.height)
        }
        
        layoutAttributes.frame = newRect
        return layoutAttributes
    }
}

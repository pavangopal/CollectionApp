//
//  CoverFlowCollectionViewLayout.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/31/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit

public class CoverFlowCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var lastCollectionViewSize: CGSize = .zero
    
    public var scalingOffset: CGFloat = 200 //for offsets >= scalingOffset scale factor is minimumScaleFactor
    public var minimumScaleFactor: CGFloat = 0.7
    public var scaleItems: Bool = true
    
    
    static func configureLayout(collectionView:UICollectionView,itemSize: CGSize, minimumLineSpacing: CGFloat) -> CoverFlowCollectionViewLayout {
        
        let layout = CoverFlowCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.collectionViewLayout = layout
        return layout
    }
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        guard let collectionView = collectionView else{return}
        
        let currentCollectionViewSize = collectionView.bounds.size
        
        if !currentCollectionViewSize.equalTo(lastCollectionViewSize){
            self.configureInset()
            lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    
    
    private func configureInset() -> Void {
        guard let collectionView = collectionView else{return}
        
        let inset = collectionView.bounds.size.width / 2 - itemSize.width / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionView.contentOffset = CGPoint(x: -inset, y: 0)
        
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else {return proposedContentOffset}
        
        let collectionViewSize = collectionView.bounds.size
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        guard let layoutAttributes = layoutAttributesForElements(in: proposedRect)else{
            return proposedContentOffset
        }
        
        var candidateAttributes:UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width/2
        
        for attributes in layoutAttributes{
            if attributes.representedElementCategory != .cell{
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes!.center.x - collectionView.bounds.size.width/2
        
        let offset = newOffsetX - collectionView.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = itemSize.width + minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
        
        
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) ->
        Bool {
            return true
    }
    
    
    public override func layoutAttributesForElements(in rect: CGRect) ->
        [UICollectionViewLayoutAttributes]? {
            
            
            if !scaleItems || collectionView == nil{
                return super.layoutAttributesForElements(in: rect)
            }
            
            let superAttributes = super.layoutAttributesForElements(in: rect)
            
            if superAttributes == nil{
                return nil
            }
            
            let contentOffset = collectionView!.contentOffset
            let size = collectionView!.bounds.size
            let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
            let visibleCenterX = visibleRect.midX
            var newAttributesArray = [UICollectionViewLayoutAttributes]()
            
            superAttributes?.forEach({ (attribute) in
                let newAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
                newAttributesArray.append(newAttribute)
                let distanceFromCenter = visibleCenterX - newAttribute.center.x
                let absDistanceFromCenter = min(abs(distanceFromCenter), scalingOffset)
                let scale = absDistanceFromCenter * (minimumScaleFactor - 1)/scalingOffset + 1
                newAttribute.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            })
            
            return newAttributesArray
    }
    
}


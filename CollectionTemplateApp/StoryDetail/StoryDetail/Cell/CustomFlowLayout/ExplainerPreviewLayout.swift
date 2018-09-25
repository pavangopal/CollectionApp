//
//  ExplainerPreviewLayout.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/27/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class ExplainerPreviewLayout:UICollectionViewLayout{
    
    var CELL_WIDTH:Double = Double(UIScreen.main.bounds.width)
    var CELL_HEIGHT:Double = 40
    var cellAttrsDictionary = Dictionary<IndexPath,UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    var layout:[[StoryDetailLayout]] = []
    
    var sizingCells:[String:BaseCollectionCell] = [:]
    var story:Story?
    
    var jsEmbbedCellIdentifiers : [String] = []
    var youtubeCellIdentifiers:[String] = []
    
    var collapsedIndexPath: [IndexPath:Bool] = [:]
    var jsEmbbedCell : [IndexPath:JSEmbedCell] = [:]
    
    var jsEmbedCellHeight : [IndexPath:CGSize] = [:]
    var cachedHeight : [IndexPath:CGSize] = [:]
    var twitterCellheight :[IndexPath:CGSize] = [:]
    
    var needsReloading = false
    var scrollingPoint:[Int:CGPoint] = [:]
    var currentIndexPath: IndexPath?
    public  var contentSizeForSection:[Int:CGSize] = [:]
    var section = 0
    
    override var collectionViewContentSize: CGSize{
        get{
            
            return contentSize
        }
    }
    
    
    override func prepare() {
        if let dataSource = self.collectionView?.dataSource as? StoryDetailDataSourceAndDelegate{
            self.sizingCells = dataSource.sizingCells
        }
        
        // Cycle through each section of the data source.
        
        var maxHeight:Double = 0
        var sectionHeight:Double = 0
        let contentWidth = Double(collectionView!.numberOfSections) * CELL_WIDTH
        
        if collectionView?.numberOfSections > 0 {
            for section in 0...collectionView!.numberOfSections-1 {
                
                let xPos = Double(section) * CELL_WIDTH
                var yPos:Double = 0
                
                sectionHeight = 0
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItems(inSection: section) > 0 {
                    for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = IndexPath(item: item, section: section)
                        
                        if let dataSource = self.collectionView?.dataSource as? StoryDetailDataSourceAndDelegate{
                            CELL_HEIGHT =  Double(dataSource.collectionView(self.collectionView!, layout: self, sizeForItemAt: cellIndex).height)
                        }
                        
                        sectionHeight += CELL_HEIGHT
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        
                        yPos += CELL_HEIGHT
                        
                        
                        // Save the attributes.
                        cellAttrsDictionary[cellIndex] = cellAttributes
                        
                    }
                }
                
                scrollingPoint[section] = CGPoint(x: xPos, y: sectionHeight)
                
                if sectionHeight > maxHeight{
                    maxHeight = sectionHeight
                }
                
                self.contentSizeForSection[section] = CGSize(width: contentWidth, height: sectionHeight)
            }
        }
        
        // Update content size.
        self.contentSize = CGSize(width: contentWidth, height: maxHeight)
        
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cellAttrsDictionary[indexPath]
    }
    
    //    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    //        return true
    //    }
    
    var mostRecentOffset : CGPoint = CGPoint()
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if proposedContentOffset.y < mostRecentOffset.y{
            print("Up")
        }else if  proposedContentOffset.y > mostRecentOffset.y{
            print("Down")
        }else{
            if let cv = self.collectionView {
                
                let cvBounds = cv.bounds
                let halfWidth = cvBounds.size.width * 0.5;
                
                var candidateAttributes:UICollectionViewLayoutAttributes?
                
                
                if let _ = self.layoutAttributesForElements(in: cvBounds) {
                    
                    if proposedContentOffset.x < mostRecentOffset.x{
                        //scrolling Left
                        let previousIndexPath =  self.collectionView?.indexPathForItem(at: CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y))
                        
                        if let previousIndexPathD = previousIndexPath{
                            candidateAttributes = self.layoutAttributesForItem(at: previousIndexPathD)
                        }
                        
                    }else if proposedContentOffset.x > mostRecentOffset.x{
                        //scrolling right
                        let nextIndexPath = self.collectionView?.indexPathForItem(at: CGPoint(x: proposedContentOffset.x + 375, y: proposedContentOffset.y))
                        
                        if let nextIndexpathD = nextIndexPath {
                            candidateAttributes = self.layoutAttributesForItem(at: nextIndexpathD)
                        }
                    }
                }
                
                guard let _ = candidateAttributes else {
                    return mostRecentOffset
                }
                
                // Beautification step , I don't know why it works!
                if(proposedContentOffset.x == -(cv.contentInset.left)) {
                    return proposedContentOffset
                }
                
                mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: 0)
                return mostRecentOffset
                
            }
        }
        

        
        
        // fallback
        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return mostRecentOffset
    }
    
}

//
//  LinerGalleryCarousalContainer.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/31/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class LinerGalleryCarousalContainer: BaseCollectionCell {
    
    lazy var collectionView:UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = CoverFlowCollectionViewLayout.configureLayout(collectionView:collectionView,itemSize: CGSize(width: 175, height: 260), minimumLineSpacing: 0)
        
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellClass: LinearGallerySliderCell.self)
        
        
        let inset = UIScreen.main.bounds.width / 2 - 175 / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionView.contentOffset = CGPoint(x: -inset, y: 0)
        
        return collectionView
    }()
    
    var carouselModel:CarouselModel?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var timer:Timer?
    var currentStoryIndex = -1
    var currentPage:Int = 0
    var pageWidth: CGFloat {
        return 175
    }
    
    override func setUpViews(){
        contentView.addSubview(collectionView)
        collectionView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func configure(data: Any?,associatedMetaData:AssociatedMetadata?) {
        
        guard let carousel = data as? CarouselModel,carousel.storyViewModel.count > 0 else{return}
        
        carouselModel = carousel
        
        if carousel.storyViewModel.count > 1 {
            shouldPlayMovement()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        carouselModel = nil
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}


extension LinerGalleryCarousalContainer : UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselModel?.storyViewModel.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch carouselModel?.layoutType ?? HomeCellType.imageTextCell {
            
        case .linearGallerySliderCell:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.linearGallerySliderCell.rawValue, for: indexPath) as? LinearGallerySliderCell
            
            cell?.configure(data: carouselModel?.storyViewModel[indexPath.row],associatedMetaData:carouselModel?.associatedMetaData)
            
            return cell!
            
        default:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.imageTextCell.rawValue, for: indexPath) as? ImageTextCell
            
            cell?.configure(data: carouselModel?.storyViewModel[indexPath.row],associatedMetaData:carouselModel?.associatedMetaData)
            
            return cell!
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectCarousalStoryAtIndex(index: indexPath.row, storyArray: self.carouselModel?.storyViewModel ?? [])
    }
}

extension LinerGalleryCarousalContainer {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            
            currentStoryIndex = indexPath.row
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        shouldPauseMovement()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.shouldPlayMovement()
        }
        
    }
    
    func shouldPauseMovement(){
        if !isMovementPaused(){
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    func shouldPlayMovement(){
        if isMovementPaused(){
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.shouldRotate), userInfo: nil, repeats: true)
        }
    }
    
    func isMovementPaused() -> Bool{
        
        if let _ = timer{
            return false
        }else{
            return true
        }
    }
    
    @objc func shouldRotate(){
        
        currentStoryIndex += 1
        
        if currentStoryIndex <  carouselModel?.storyViewModel.count ?? 0 {
            scrollToPage(pageNumber: currentStoryIndex, animation: true)
            
        }else{
            
            currentStoryIndex = 0
            scrollToPage(pageNumber: currentStoryIndex, animation: false)
            
        }
    }
    
    func scrollToPage(pageNumber:Int,animation:Bool){
        
        let pageOffset = CGFloat(pageNumber) * pageWidth - collectionView.contentInset.left
        self.collectionView.setContentOffset(CGPoint(x: pageOffset, y: 0), animated: animation)
        self.currentPage = pageNumber
    }
    
}



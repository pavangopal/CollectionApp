//
//  CarousalContainerCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class CarousalContainerCell: BaseCollectionCell {
    
    lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(hexString: "#F5F5F5")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellClass: ImageTextCell.self)
        collectionView.register(cellClass: FullImageSliderCell.self)
        collectionView.register(cellClass: SimpleSliderCell.self)
        collectionView.register(cellClass: LinearGallerySliderCell.self)
        
        return collectionView
    }()
    
    var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        
        pageControl.hidesForSinglePage = false
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        return pageControl
    }()
    
    var carouselModel:CarouselModel?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var timer:Timer?
    var currentStoryIndex = -1 {
        didSet{
            pageControl.currentPage = currentStoryIndex
        }
    }
    
    override func setupViews() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        collectionView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        pageControl.anchor(collectionView.bottomAnchor, left: nil, bottom: contentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        pageControl.anchorCenterXToSuperview()
        
    }
    
    override func configure(data: Any?,associatedMetaData:AssociatedMetadata?) {
        
        guard let carousel = data as? CarouselModel,carousel.storyViewModel.count > 0 else{return}
        
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: contentView.bounds.width, height: carousel.estimatedInnerCellHeight)
        pageControl.numberOfPages = carousel.storyViewModel.count
        carouselModel = carousel
        
        if carousel.storyViewModel.count > 1 && (associatedMetaData?.enable_auto_play ?? false) {
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


extension CarousalContainerCell : UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselModel?.storyViewModel.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch carouselModel?.layoutType ?? HomeCellType.ImageTextCell {
            
        case .FullImageSliderCell:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.FullImageSliderCell.rawValue, for: indexPath) as? FullImageSliderCell
            cell?.configure(data: carouselModel?.storyViewModel[indexPath.row], associatedMetaData: carouselModel?.associatedMetaData)
            
            return cell!
        
        case .SimpleSliderCell:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.SimpleSliderCell.rawValue, for: indexPath) as? SimpleSliderCell
            
            let tuple:(collectionName:String?,story:StoryViewModel?) = (collectionName:carouselModel?.collectionName,story:carouselModel?.storyViewModel[indexPath.row])
            cell?.configure(data: tuple,associatedMetaData:carouselModel?.associatedMetaData)
            
            return cell!
            
        case .LinearGallerySliderCell:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.LinearGallerySliderCell.rawValue, for: indexPath) as? LinearGallerySliderCell
            
            cell?.configure(data: carouselModel?.storyViewModel[indexPath.row],associatedMetaData:carouselModel?.associatedMetaData)
            
            return cell!
            
        default:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.ImageTextCell.rawValue, for: indexPath) as? ImageTextCell
            
            cell?.configure(data: carouselModel?.storyViewModel[indexPath.row], associatedMetaData: carouselModel?.associatedMetaData)
            
            return cell!
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
}

extension CarousalContainerCell {
    
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
            
            collectionView.scrollToItem(at: IndexPath(item: currentStoryIndex, section: 0), at: .left, animated: true)
        }else{
            
            currentStoryIndex = 0
            
            collectionView.scrollToItem(at: IndexPath(item: currentStoryIndex, section: 0), at: .left, animated: false)
            
        }
    }
    
}

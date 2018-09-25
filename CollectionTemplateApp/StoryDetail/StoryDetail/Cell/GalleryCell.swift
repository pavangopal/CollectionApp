//
//  GalleryCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/3/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol  GalleryCellDelegate :class {
    func didTapGalleryImage(at index:Int,storyElement:CardStoryElement,currentIndexPath:IndexPath)
}

class GalleryCell: BaseCollectionCell {
    
    weak var galleryDelegate:GalleryCellDelegate?
    
    private var currentIndexPath: IndexPath?
    
    var collectionView: UICollectionView = {
        let layout = CenterSnapFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = UIScrollViewDecelerationRateFast
        return view
    }()
    
    var cardElement:CardStoryElement?
    var imageArray:[GalleryImage] = []{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func setUpViews(){
        super.setUpViews()
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        
        let storyTemplet = self.margin.storyTemplet
        
        let leftInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 5 : 0
        let rightInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 10 : 0
        
        let view = self.contentView
        
        collectionView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : UIColor(hexString:"#f9f9f9").withAlphaComponent(0.4)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        collectionView.register(cellClass: GalleryImageCell.self)
        
        collectionView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: leftInset, bottomConstant: self.margin.Bottom, rightConstant: rightInset, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func configure(data: Any?, indexPath: IndexPath, status: Bool) {
        
        guard let cardElement = data as? CardStoryElement else {
            return
        }
        
        self.cardElement = cardElement
        
        self.currentIndexPath = indexPath
        
        self.imageArray =  cardElement.galleryImageArray
        
    }
    
}

extension GalleryCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(ofType: GalleryImageCell.self, for: indexPath)
        
        if indexPath.row < imageArray.count{
            imageCell.completion(self.margin)
            imageCell.configure(data: imageArray[indexPath.row])
        }
        
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let unwrappedCurrentIndexPath = currentIndexPath{
            self.galleryDelegate?.didTapGalleryImage(at: indexPath.row,storyElement:self.cardElement!,currentIndexPath:unwrappedCurrentIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let storyTemplet = self.margin.storyTemplet
        
        if storyTemplet == .LiveBlog{
            return CGSize(width: collectionView.bounds.width - 60, height: 235)
        }else{
            return CGSize(width: collectionView.bounds.width - 40, height: 235)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}


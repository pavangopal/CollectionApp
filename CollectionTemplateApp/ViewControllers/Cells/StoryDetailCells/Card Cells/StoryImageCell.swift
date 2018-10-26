//
//  StoryImageCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/30/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher


class StoryImageCell: BaseCollectionCell {
    
    var extraHeightForParallax:CGFloat = 30
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var imageTitleTextview:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        view.attributedText = nil
        view.textAlignment = .center
        return view
    }()
    
    var _centerYConstraint:NSLayoutConstraint?
    var centerYConstraint:NSLayoutConstraint{
        get{
            if _centerYConstraint != nil{
                return _centerYConstraint!
            }
            self._centerYConstraint = NSLayoutConstraint(item: self.imageView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
            self._centerYConstraint!.priority = UILayoutPriority(rawValue: 999)
            self.contentView.addConstraint(_centerYConstraint!)
            return _centerYConstraint!
        }
        
        set{
            self._centerYConstraint = newValue
        }
    }
    
    var imageContainerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var _imageViewContainerHeightConstraint:NSLayoutConstraint?
    var imageViewContainerHeightConstraint:NSLayoutConstraint{
        get{
            if _imageViewContainerHeightConstraint != nil{
                return _imageViewContainerHeightConstraint!
            }
            self._imageViewContainerHeightConstraint = NSLayoutConstraint(item: self.imageContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
            _imageViewContainerHeightConstraint!.priority = UILayoutPriority(rawValue: 999)
            self.imageContainerView.addConstraint(_imageViewContainerHeightConstraint!)
            
            return _imageViewContainerHeightConstraint!
        }
        set{
            self._imageViewContainerHeightConstraint = newValue
        }
    }
    
    var _imageViewHeightConstraint:NSLayoutConstraint?
    var imageViewHeightConstraint:NSLayoutConstraint{
        get{
            if _imageViewHeightConstraint != nil{
                return _imageViewHeightConstraint!
            }
            
            self._imageViewHeightConstraint = NSLayoutConstraint.init(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
            
            self._imageViewHeightConstraint!.priority = UILayoutPriority(rawValue: 999)
            self.imageView.addConstraint(_imageViewHeightConstraint!)
            
            return _imageViewHeightConstraint!
        }
        set{
            self._imageViewHeightConstraint = newValue
        }
    }
    
    var parallaxOffset: CGFloat = 0{
        didSet{
            centerYConstraint.constant = parallaxOffset
        }
    }
    
    
    override func setUpViews(){
        super.setUpViews()
        
        let storyTemplet = self.margin.storyTemplet
        let leftInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 5 : 0
        let rightInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 10 : 0
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        imageTitleTextview.backgroundColor = contentView.backgroundColor
        
        contentView.clipsToBounds = true
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        contentView.addSubview(imageTitleTextview)
        
        imageContainerView.clipsToBounds = true
        
        if (self.margin.storyTemplet == .LongForm){
            centerYConstraint.constant = 0
        }
        
        imageContainerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView.anchor(nil, left: imageContainerView.leftAnchor, bottom: nil, right: imageContainerView.rightAnchor, topConstant: 0, leftConstant: leftInset, bottomConstant: 0, rightConstant: rightInset, widthConstant: 0, heightConstant: 0)
        
        imageTitleTextview.anchor(imageContainerView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 4, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        imageView.backgroundColor = UIColor.randomColor().withAlphaComponent(0.2)
        imageTitleTextview.delegate = self
    }
    
    
    override func configure(data:Any?){
        guard let storyElement = data as? CardStoryElement else{
            return
        }
        
        imageTitleTextview.setText(storyElement.displayText)
        
        
        if let imageS3Key = storyElement.image_s3_key{
            let imageSize = self.calculateImageSize(metadata: storyElement.hero_image_metadata)
            
            self.imageViewHeightConstraint.constant = imageSize.height
            
            let reductionFactorForParallaxScrolling = (self.margin.storyTemplet == .LongForm) ? (0.20 * imageSize.height) : 0
            
            self.imageViewContainerHeightConstraint.constant = imageSize.height - reductionFactorForParallaxScrolling
            
            imageView.loadImage(imageMetaData: storyElement.hero_image_metadata, imageS3Key: imageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))

        }
    }
}

extension StoryImageCell{
    
    func calculateImageSize(metadata:ImageMetaData?) -> CGSize{
        
        let storyTemplet = self.margin.storyTemplet
        let leftInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 5 : 0
        let rightInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 10 : 0
        
        let widthDimension2 = UIScreen.main.bounds.size.width - 20 - leftInset - rightInset
        
        guard metadata != nil else {
            return CGSize.init(width: widthDimension2, height: (widthDimension2 * 3.0/4.0))
        }
        
        if let width = metadata?.width, metadata!.height != nil{
            let widthDimenstion1 = CGFloat(width.floatValue)
            let heightDimension1 = CGFloat((metadata?.height!.floatValue)!)
            
            
            let heightDimenstion2 = widthDimension2 * heightDimension1/widthDimenstion1
            return CGSize.init(width: widthDimension2, height: heightDimenstion2)
        }
        
        return CGSize.init(width: widthDimension2, height: widthDimension2 * 3.0/4.0)
    }
    
    func updateParallaxOffet(collectionViewBounds:CGRect){
        
        let center = CGPoint(x: collectionViewBounds.midX, y: collectionViewBounds.midY)
        let offsetFromCenter = CGPoint(x: center.x - self.center.x, y: center.y - self.center.y)
        
        let textviewHeight = imageTitleTextview.frame.size.height
        
        let maxVerticalOffset  = (collectionViewBounds.height/2) + (self.bounds.height/2)
        let scaleFactor = 40 / maxVerticalOffset
        
        parallaxOffset = -((offsetFromCenter.y * scaleFactor) + textviewHeight - 10)
        
    }
    
}

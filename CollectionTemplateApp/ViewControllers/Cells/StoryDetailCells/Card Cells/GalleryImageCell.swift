//
//  GalleryImageCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/4/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.

import UIKit
import Quintype
import Kingfisher


class GalleryImageCell: BaseCollectionCell {
    
    
    var backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        view.lineBreakMode = .byTruncatingTail
        return view
    }()
  
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
    
    override func setUpViews(){
        
        let storyTemplet = self.margin.storyTemplet
        
        if storyTemplet != .LiveBlog{
            super.setUpViews()
        }
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        imageTitleTextview.backgroundColor = contentView.backgroundColor
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(imageView)
        contentView.addSubview(imageTitleTextview)
        
        
        backgroundImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: imageTitleTextview.topAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageTitleTextview.anchor(imageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 4, leftConstant: self.margin.Left, bottomConstant: 4, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        
        backgroundImageView.addBlur(style: .extraLight)
        imageTitleTextview.delegate = self
    }
    
    
    override func configure(data:Any?){
       if let metaData = data as? GalleryImage{
            imageView.contentMode = .scaleAspectFit
            adjustTextBasedHeight(storyElementTitle: metaData.imageDescription,attributtion: nil)
            
            if let imageS3Key = metaData.image{
                let imageSize = CGSize(width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 40)
                
                self.imageViewHeightConstraint.constant = imageSize.height

                imageView.loadImage(imageMetaData: metaData.imageMeta, imageS3Key: imageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
                
                backgroundImageView.loadImage(imageMetaData: metaData.imageMeta, imageS3Key: imageS3Key, targetSize: imageSize ,placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
                
            }
        }
    }
    
    func adjustTextBasedHeight(storyElementTitle:String?,attributtion:String?){
        
        let textColor = self.getTextColorForTemplet()
        
        let titleAttributtes = textOption.imageElementText(color:textColor).textAttributtes
        
        let titleAttributtedString = Helper.getAttributtedString(for: storyElementTitle, textOption: titleAttributtes)
        
        imageTitleTextview.setText(titleAttributtedString)
   
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        imageTitleTextview.attributedText = nil
        
    }
}

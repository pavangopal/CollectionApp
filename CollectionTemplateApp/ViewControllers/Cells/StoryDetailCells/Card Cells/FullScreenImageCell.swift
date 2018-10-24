//
//  FullScreenImageCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/6/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher


class FullScreenImageCell: BaseCollectionCell {
    
    let imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let imageCaptionContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    
    var imageTitleTextview:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.backgroundColor = .clear
        view.setBasicProperties()
        view.attributedText = nil
        view.textAlignment = .center
        return view
    }()
    
    var imageAttributionTextview:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.attributedText = nil
        view.backgroundColor = .clear
        view.setBasicProperties()
        view.textAlignment = .center
        return view
    }()
    
    var _imageTitleTextviewHeightConstraint:NSLayoutConstraint?
    var imageTitleTextviewHeightConstraint:NSLayoutConstraint{
        get{
            
            if _imageTitleTextviewHeightConstraint != nil{
                return _imageTitleTextviewHeightConstraint!
            }
            
            self._imageTitleTextviewHeightConstraint = NSLayoutConstraint.init(item: self.imageTitleTextview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
            self._imageTitleTextviewHeightConstraint!.priority = UILayoutPriority(rawValue: 999)
            self.imageTitleTextview.addConstraint(_imageTitleTextviewHeightConstraint!)
            return _imageTitleTextviewHeightConstraint!
        }
        set{
            self._imageTitleTextviewHeightConstraint = newValue
        }
    }
    
    var _imageAttributionTextviewHeightConstraint:NSLayoutConstraint?
    var imageAttributionTextviewHeightConstraint:NSLayoutConstraint{
        get{
            if _imageAttributionTextviewHeightConstraint != nil{
                return _imageAttributionTextviewHeightConstraint!
            }
            
            self._imageAttributionTextviewHeightConstraint = NSLayoutConstraint.init(item: self.imageAttributionTextview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
            self._imageAttributionTextviewHeightConstraint!.priority = UILayoutPriority(rawValue: 999)
            self.imageAttributionTextview.addConstraint(_imageAttributionTextviewHeightConstraint!)
            return _imageAttributionTextviewHeightConstraint!
        }
        set{
            self._imageAttributionTextviewHeightConstraint = newValue
        }
    }
    
    override func setUpViews(){
         
        contentView.backgroundColor = .black
        
        contentView.addSubview(imageView)
        contentView.addSubview(imageCaptionContainerView)
        imageCaptionContainerView.addSubview(imageTitleTextview)
        imageCaptionContainerView.addSubview(imageAttributionTextview)
        
        imageView.fillSuperview()
        
        imageCaptionContainerView.anchor(nil, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageTitleTextview.anchor(imageCaptionContainerView.topAnchor, left: imageCaptionContainerView.leftAnchor, bottom: nil, right: imageCaptionContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        imageAttributionTextview.anchor(imageTitleTextview.bottomAnchor, left: imageCaptionContainerView.leftAnchor, bottom: imageCaptionContainerView.bottomAnchor, right: imageCaptionContainerView.rightAnchor, topConstant: self.margin.Top, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        imageTitleTextview.delegate = self
        imageAttributionTextview.delegate = self
    }
    
    override func configure(data:Any?){
        if let storyElement = data as? CardStoryElement {
            
            adjustTextBasedHeight(imageTitle: storyElement.title,imageAttribution: storyElement.image_attribution)
            
            if let imageS3Key = storyElement.image_s3_key{
                
                imageView.loadImage(imageMetaData: storyElement.hero_image_metadata, imageS3Key: imageS3Key, targetSize: nil, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
            }
        }
        
    }
    
    func adjustTextBasedHeight(imageTitle:String?,imageAttribution:String?){
        
        let titleAttributtes = textOption.imageElementText(color:.white).textAttributtes
        let attributionAttributes = textOption.imageElementAttribution(color:.white).textAttributtes
        
        let titleAttributtedString = Helper.getAttributtedString(for: imageTitle, textOption: titleAttributtes)
        let attributtionString = Helper.getAttributtedString(for: imageAttribution, textOption: attributionAttributes)
        
        let finalAttributtedString = Helper.combineAttributedStrings(str1: titleAttributtedString, str2: attributtionString, seperator: "<br>",alignment: .center)
        
        imageTitleTextview.setText(finalAttributtedString)
        imageCaptionContainerView.isHidden = (titleAttributtedString == nil && attributtionString == nil)
    }
    
    //Important
    override func prepareForReuse() {
        adjustAnchorPoint()
        layer.transform = CATransform3DIdentity
        imageView.image = nil
    }
}





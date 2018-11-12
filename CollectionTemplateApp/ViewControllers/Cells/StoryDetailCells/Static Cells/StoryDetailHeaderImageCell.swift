//
//  StoryDetailHeaderImageCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher


class StoryDetailHeaderImageCell: BaseCollectionCell {
    
    var heroImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var heroImageCaptionContainerView:UIView = {
        var view = UIView()
        return view
    }()
    
    var imageCaptionTextView:TTTAttributedLabel = {
        let textView = TTTAttributedLabel(frame: .zero)
        
        textView.textAlignment = .right
        textView.isHidden = false
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.setBasicProperties()
        
        return textView
    }()
    
    var imageContainerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var imageViewHeightConstraint:NSLayoutConstraint?
    var heroImageCaptionContainerViewBottomConstraint:NSLayoutConstraint?
    
    let blurView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        return blurView
    }()
    
    override func setUpViews(){
        
        contentView.addSubview(imageContainerView)
        
        imageContainerView.addSubview(heroImageView)
        contentView.clipsToBounds = true
        
        contentView.addSubview(heroImageCaptionContainerView)
        contentView.addSubview(blurView)
        contentView.bringSubview(toFront: blurView)
        heroImageCaptionContainerView.addSubview(imageCaptionTextView)
        
        //Constraints
        imageContainerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        heroImageView.anchor(imageContainerView.topAnchor, left: imageContainerView.leftAnchor, bottom: imageContainerView.bottomAnchor, right: imageContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        heroImageCaptionContainerView.anchor(nil, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        heroImageCaptionContainerViewBottomConstraint = heroImageCaptionContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        heroImageCaptionContainerViewBottomConstraint?.isActive = true
        
        imageCaptionTextView.anchor(heroImageCaptionContainerView.topAnchor, left: heroImageCaptionContainerView.leftAnchor, bottom: heroImageCaptionContainerView.bottomAnchor, right: heroImageCaptionContainerView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
        //Only done here for fixed Elements else should be done in configure
        self.imageViewHeightConstraint = self.heroImageView.heightAnchor.constraint(equalToConstant: 250)
        self.imageViewHeightConstraint?.priority = UILayoutPriority.defaultLow
        
        heroImageCaptionContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        imageCaptionTextView.delegate = self
        
        
        blurView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        blurView.alpha = 0
    }
    
    override func configure(data:Any?){
        
        guard let story = data as? Story else{
            return
        }
        
        if let heroImageS3Key = story.hero_image_s3_key{
            if let _ = story.hero_image_metadata?.height{
                let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
                self.imageViewHeightConstraint?.constant = 250
                
                heroImageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
            }else{
                
                self.imageViewHeightConstraint?.constant = 0
                
            }
        }
        
        let titleAttributtes = textOption.imageElementText(color:.white).textAttributtes
        let attributionAttributes = textOption.imageElementAttribution(color:.white).textAttributtes
        
        let titleAttributtedString = Helper.getAttributtedString(for: story.hero_image_caption, textOption: titleAttributtes)
        let attributtionString = Helper.getAttributtedString(for: story.hero_image_attribution, textOption: attributionAttributes)
        
        let finalAttributtedString = Helper.combineAttributedStrings(str1: titleAttributtedString, str2: attributtionString, seperator: "<br>",alignment: .left)
        
        if finalAttributtedString.length > 0{
            imageCaptionTextView.setText(finalAttributtedString)
            heroImageCaptionContainerView.isHidden = false
        }else{
            heroImageCaptionContainerView.isHidden = true
        }
        
        
    }
    
    override func prepareForReuse() {
        self.heroImageView.image = nil
    }
    
}

extension StoryDetailHeaderImageCell{
    
    func updateParallaxOffet(collectionViewBounds:CGRect){
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationBarHeight = statusBarHeight + 44
        let yOffset = collectionViewBounds.origin.y + navigationBarHeight
        
        if yOffset > 0 && yOffset < navigationBarHeight {
            heroImageCaptionContainerViewBottomConstraint?.constant = ((yOffset * 0.9))
            
        }else if yOffset <= 0 {
            heroImageCaptionContainerViewBottomConstraint?.constant = 0
            
            let bounceProgress = min(1, abs(yOffset) / (bounds.height))
            
            let scalingFactor = 1 + min(log(bounceProgress + 1), 2)
            
            heroImageView.transform = CGAffineTransform(scaleX: scalingFactor, y: scalingFactor)
        }
        
        blurView.alpha = min(1, abs(yOffset)/bounds.height)//100
        heroImageCaptionContainerView.alpha = 1 - (abs(yOffset)/(bounds.height))
    }
}

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
    
    var imageInfoButton:UIButton = {
        let button = UIButton()
        
        button.setImage(AssetImage.InfoIcon.image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return button
    }()
    
    var imageCaptionTextView:TTTAttributedLabel = {
        let textView = TTTAttributedLabel(frame: .zero)
        
        textView.textAlignment = .right
        textView.isHidden = true
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.setBasicProperties()
        
        return textView
    }()
    
    var _centerYConstraint:NSLayoutConstraint?
    var centerYConstraint:NSLayoutConstraint{
        get{
            if _centerYConstraint != nil{
                return _centerYConstraint!
            }
            self._centerYConstraint = NSLayoutConstraint(item: self.heroImageView, attribute: .centerY, relatedBy: .equal, toItem: self.imageContainerView, attribute: .centerY, multiplier: 1, constant: 0)
            self.contentView.addConstraint(_centerYConstraint!)
            return _centerYConstraint!
        }
        
        set{
            self._centerYConstraint = newValue
        }
    }
    
    
    var parallaxOffset: CGFloat = 0{
        didSet{
            centerYConstraint.constant = parallaxOffset
        }
    }
    
    
    var imageContainerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var imageViewHeightConstraint:NSLayoutConstraint?
    
    
    override func setUpViews(){
        
        contentView.addSubview(imageContainerView)
        
        imageContainerView.addSubview(heroImageView)
        contentView.clipsToBounds = true
        
        contentView.addSubview(heroImageCaptionContainerView)
        heroImageCaptionContainerView.addSubview(imageCaptionTextView)
        heroImageCaptionContainerView.addSubview(imageInfoButton)
        
        //Constraints
        imageContainerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        heroImageView.anchor(nil, left: imageContainerView.leftAnchor, bottom: nil, right: imageContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        centerYConstraint.constant = 0
        
        heroImageCaptionContainerView.anchor(nil, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageCaptionTextView.anchor(heroImageCaptionContainerView.topAnchor, left: heroImageCaptionContainerView.leftAnchor, bottom: heroImageCaptionContainerView.bottomAnchor, right: heroImageCaptionContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        imageInfoButton.anchor(nil, left: nil, bottom: heroImageCaptionContainerView.bottomAnchor, right: heroImageCaptionContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 35, heightConstant: 35)
        
        
        //Only done here for fixed Elements else should be done in configure
        self.imageViewHeightConstraint = self.heroImageView.heightAnchor.constraint(equalToConstant: 200)
        self.imageViewHeightConstraint?.isActive = true
        self.imageContainerView.heightAnchor.constraint(equalTo: self.heroImageView.heightAnchor).isActive = true
        
        heroImageCaptionContainerView.backgroundColor = .clear
        self.addEvenListeners()
        imageCaptionTextView.delegate = self
        
    }
    
    override func configure(data:Any?){
        
        guard let story = data as? Story else{
            return
        }
        
        if let heroImageS3Key = story.hero_image_s3_key{
            if let _ = story.hero_image_metadata?.height{
                let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
                self.imageViewHeightConstraint?.constant = 200
                
                heroImageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
            }else{
                
                self.imageViewHeightConstraint?.constant = 0
                
            }
        }
        
        imageCaptionTextView.setText(story.imageAttributtedCaptionText)
        
    }
    
    override func prepareForReuse() {
        self.heroImageView.image = nil
    }
    
}

extension StoryDetailHeaderImageCell{
    
    private func addEvenListeners(){
        
        imageInfoButton.addTarget(self, action: #selector(toggleImageCaption(sender:)), for: .touchUpInside)
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(hideImageCaption(sender:)))
        imageCaptionTextView.addGestureRecognizer(tapGuesture)
    }
    
    @objc func hideImageCaption(sender:UITapGestureRecognizer){
        imageCaptionTextView.isHidden = true
        imageInfoButton.isHidden = false
        heroImageCaptionContainerView.backgroundColor = .clear
    }
    
    @objc func toggleImageCaption(sender:UIButton){
        self.imageCaptionTextView.isHidden = false
        self.imageInfoButton.isHidden = true
        heroImageCaptionContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func updateParallaxOffet(collectionViewBounds:CGRect){
        
        if collectionViewBounds.origin.y > 0{
            parallaxOffset = collectionViewBounds.origin.y
        }else{
            parallaxOffset = 0
        }
    }
}

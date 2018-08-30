//
//  ImageStoryListCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ImageStoryListCell: BaseCollectionCell {
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var stackView : MDStackView!
    
    
    override func setupViews() {
        contentView.clipsToBounds = true
        
        stackView = MDStackView(metaData: nil)
        
        contentView.addSubview(stackView)
        contentView.addSubview(imageView)
        imageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.bottom, relatedBy: .greaterThanOrEqual, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        self.contentView.addConstraint(bottomConstraint)
        
        stackView.anchor(contentView.topAnchor, left: imageView.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0 )
        
    }
    
    override func configure(data:Any?){
        
        guard let story = data as? Story else{
            return
        }
        
        if let heroImageS3Key = story.hero_image_s3_key {
            
            let imageSize = CGSize(width: UIScreen.main.bounds.width-30, height: 200)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: nil)
        }
        
        stackView.headlineLabel.text = story.headline?.trim()
    
        
        stackView.sectionNameLabel.text = story.sections.first?.display_name ?? story.sections.first?.name ?? ""
        
        stackView.authorNameLabel.text = story.authors.first?.name ?? ""
        
        stackView.publishTimeLabel.text = (story.first_published_at?.convertTimeStampToDate ?? "" ).trim()
        
    }
}

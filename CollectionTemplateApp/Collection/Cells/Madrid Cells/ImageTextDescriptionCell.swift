//
//  ImageTextDescriptionCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ImageTextDescriptionCell: BaseCollectionCell {
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var stackView:MDStackView!
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(containerView)
        containerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        
        stackView = MDStackView()
        
        containerView.addSubview(imageView)
        containerView.addSubview(stackView)
        
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
        
        stackView.anchor(imageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let bottomConstraint = NSLayoutConstraint.init(item: containerView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(bottomConstraint)
    }
    
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        
        guard let story = data as? Story else{
            return
        }
        
        self.stackView.updateViewFor(associatedMetaData: associatedMetaData)
        
        if let heroImageS3Key = story.hero_image_s3_key {
            
            let imageSize = CGSize(width: UIScreen.main.bounds.width-30, height: 200)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: nil)
        }
        
        stackView.headlineLabel.text = story.headline ?? ""
        stackView.subHeadlineLabel.text = story.subheadline?.trim()
        
        if story.story_template == StoryTemplet.Review {
            stackView.ratingView.isHidden = false
            stackView.ratingView.rating = story.storyMetadata?.review_rating?.value ?? 0.0
        }else{
            stackView.ratingView.isHidden = true
        }
        
        stackView.sectionNameLabel.text = story.sections.first?.display_name ?? story.sections.first?.name ?? ""
        
        stackView.authorNameLabel.text = story.author_name ?? ""
        
        if let imageString = story.authors.first?.avatar_url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let imageURL = URL(string:"\(imageString)"){
            
            self.stackView.authorImageView.kf.setImage(with: imageURL, completionHandler: { [weak self] (image, error, cachetype, url) in
                guard let selfD = self else{return}
                
                selfD.stackView.authorImageView.image = image
            })
        }
        
        self.stackView.publishTimeLabel.text = (story.first_published_at?.convertTimeStampToDate ?? "" ).trim()
        
        
    }
    
    
}

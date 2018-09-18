//
//  ImageStoryListswift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ImageStoryListCardCell: BaseCollectionCell {
    
    var containerView:UIView = {
       let view = UIView()
        return view
    }()
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var stackView : MDStackView!
    
    
    override func setupViews() {
        super.setupViews()
        
        contentView.clipsToBounds = true
        
        stackView = MDStackView()
//        stackView.sectionNameLabel.isHidden = true
//        stackView.sectionUnderLineView.isHidden = true

        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(imageView)
        
        containerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 175, heightConstant: 131)
        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.bottom, relatedBy: .greaterThanOrEqual, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        self.contentView.addConstraint(bottomConstraint)
        
        stackView.anchor(containerView.topAnchor, left: imageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0 )
        
        let stackViewbottomConstraint = NSLayoutConstraint.init(item: containerView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(stackViewbottomConstraint)
    }
    
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        
        guard let story = data as? Story else{
            return
        }
        self.stackView.updateViewFor(associatedMetaData: associatedMetaData)
        
        if story.story_template == StoryTemplet.Review {
            stackView.ratingView.isHidden = false
            stackView.ratingView.rating = story.storyMetadata?.review_rating?.value ?? 0.0
        }else{
            stackView.ratingView.isHidden = true
        }
        
        if let heroImageS3Key = story.hero_image_s3_key {
            
            let imageSize = CGSize(width: 175, height: 131)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: nil)
        }
        
        stackView.headlineLabel.text = story.headline?.trim()
    
        
        stackView.sectionNameLabel.text = story.sections.first?.display_name ?? story.sections.first?.name ?? ""
        
        stackView.authorNameLabel.text = story.author_name ?? ""
        
        stackView.publishTimeLabel.text = (story.first_published_at?.convertTimeStampToDate ?? "" ).trim()
        
    }
}

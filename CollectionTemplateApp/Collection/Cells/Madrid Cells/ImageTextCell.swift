//
//  ImageTextCell.swift
//  MediaOne
//
//  Created by Pavan Gopal on 8/10/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ImageTextCell: BaseCollectionCell {
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    var stackView:MDStackView!
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = .red
        
        if stackView != nil{
            print("stackview is not nil")
            return
        }
        stackView = MDStackView(metaData: nil)
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(stackView)
        
        imageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 175)
        
        stackView.anchor(imageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

    override func configure(data:Any?){
        
        guard let story = data as? Story else{
            return
        }
        
        if let heroImageS3Key = story.hero_image_s3_key {
            
            let imageSize = CGSize(width: UIScreen.main.bounds.width-30, height: 200)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: nil)
        }
        
        stackView.headlineLabel.text = story.headline ?? ""
        //        stackView.subHeadlineLabel.text = story.subheadline?.trim()
        
//        if story.story_template == StoryTemplet.Review {
//            stackView.ratingView.isHidden = false
//            stackView.ratingView.rating = story.storyMetadata?.review_rating?.value ?? 0.0
//        }else{
//            stackView.ratingView.isHidden = true
//        }
        
        stackView.sectionNameLabel.text = story.sections.first?.display_name ?? story.sections.first?.name ?? ""
        
        stackView.authorNameLabel.text = story.authors.first?.name ?? ""
        
        if let imageString = story.authors.first?.avatar_url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let imageURL = URL(string:"\(imageString)"){
            
            self.stackView.authorImageView.kf.setImage(with: imageURL, completionHandler: { [weak self] (image, error, cachetype, url) in
                guard let selfD = self else{return}
                
                //                selfD.stackView.authorImageView.isHidden = false
                selfD.stackView.authorImageView.image = image
            })
        }else{
            //            stackView.authorImageView.isHidden = true
        }
        
        self.stackView.publishTimeLabel.text = (story.first_published_at?.convertTimeStampToDate ?? "" ).trim()
        
    }
    
    
}

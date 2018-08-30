//
//  StoryListCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class StoryListCell: BaseCollectionCell {
 
    var stackView:MDStackView!
    
    override func setupViews() {
//        super.setupViews()
        stackView = MDStackView(metaData: nil)
        contentView.addSubview(stackView)
//        stackView?.fillSuperview()
        stackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    override func configure(data:Any?){
        
        guard let story = data as? Story else{
            return
        }
        
        stackView.headlineLabel.text = story.headline?.trim()
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

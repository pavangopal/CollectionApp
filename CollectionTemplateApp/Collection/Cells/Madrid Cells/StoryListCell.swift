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
    var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#D8D8D8")
        return view
    }()
    
    override func setupViews() {
//        super.setupViews()
        self.contentView.backgroundColor = UIColor(hexString: "#F5F5F5")
        stackView = MDStackView()
        contentView.addSubview(stackView)
        contentView.addSubview(lineView)
        
        stackView.sectionNameLabel.isHidden = true
        stackView.sectionUnderLineView.isHidden = true
        stackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let bottomConstraint = NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(bottomConstraint)
        
        lineView.anchor(nil, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
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
        
        stackView.headlineLabel.text = story.headline?.trim()
       
        
        stackView.sectionNameLabel.text = story.sections.first?.display_name ?? story.sections.first?.name ?? ""
        
        stackView.authorNameLabel.text = story.author_name ?? "" 
        
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

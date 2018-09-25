//
//  ImageStoryListCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/2/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ImageStoryListCell: BaseCollectionCell {
    
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
    
    var timestampLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.font = FontService.shared.homeTimestampFont
        label.setProperties()
        
        return label
    }()
    
    
    override func setUpViews(){ 
//        super.setUpViews()
        
        contentView.clipsToBounds = true
        
        stackView = MDStackView()

        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(imageView)
        containerView.addSubview(timestampLabel)
        
        stackView.publishTimeLabel.isHidden = true
        stackView.sectionNameLabel.textColor = .black
        stackView.sectionNameLabel.backgroundColor = .clear
        stackView.sectionUnderLineView.isHidden = false
        stackView.sectionUnderLineView.backgroundColor = .black
        
        containerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 95, heightConstant: 95)
        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.bottom, relatedBy: .greaterThanOrEqual, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        self.contentView.addConstraint(bottomConstraint)
        
        stackView.anchor(containerView.topAnchor, left: imageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0 )
        
        timestampLabel.anchor(stackView.bottomAnchor, left: imageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let timestampLabelBottomConstraint = NSLayoutConstraint.init(item: containerView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: timestampLabel, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(timestampLabelBottomConstraint)
        
        
    }
    
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        guard let storyViewModel = data as? StoryViewModel else{
            return
        }
        
        imageView.loadImageFromUrl(url: storyViewModel.imageURl)
        
        stackView.config(storyViewModel: storyViewModel)

    }
}

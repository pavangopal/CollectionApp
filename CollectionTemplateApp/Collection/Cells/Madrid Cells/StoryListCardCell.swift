//
//  StoryListCardCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/6/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class StoryListCardCell: BaseCollectionCell {
    
    var stackView:MDStackView!
    
    override func setupViews() {
                super.setupViews()
        self.contentView.backgroundColor = .white
        stackView = MDStackView()
        contentView.addSubview(stackView)
        
        stackView.sectionNameLabel.isHidden = true
        stackView.sectionUnderLineView.isHidden = true
        stackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let bottomConstraint = NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(bottomConstraint)

    }
    
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        guard let storyViewModel = data as? StoryViewModel else{
            return
        }
        
        stackView.config(storyViewModel: storyViewModel)
    }
}

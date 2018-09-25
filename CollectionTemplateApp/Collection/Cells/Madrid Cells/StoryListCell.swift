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
        guard let storyViewModel = data as? StoryViewModel else{
            return
        }
        
        stackView.config(storyViewModel: storyViewModel)
        
    }
    
    
}

//
//  LinearGallerySliderCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/31/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class LinearGallerySliderCell: BaseCollectionCell {
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var imageView:UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    var headlineLabel: TTTAttributedLabel = {
       let label = TTTAttributedLabel(frame: .zero)
        label.font = FontService.shared.homeHeadlineRegular
        label.textColor = .white
        label.textAlignment = .center
        label.setProperties()
        return label
    }()
    
    override func setUpViews(){ 
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(headlineLabel)
        
        containerView.fillSuperview()
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 175, heightConstant: 120)
        
        headlineLabel.anchor(imageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let bottomContraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: headlineLabel, attribute: .bottom, multiplier: 1, constant: -10)
        
        contentView.addConstraint(bottomContraint)
    }
    
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        guard let storyViewModel = data as? StoryViewModel else{
            return
        }
        
        imageView.loadImageFromUrl(url: storyViewModel.heroImageURl)
        headlineLabel.attributedText = storyViewModel.headline
    }
    
}

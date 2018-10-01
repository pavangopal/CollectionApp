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
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var stackView:MDStackView!
    
    override func setUpViews(){ 
        super.setUpViews()
        
        contentView.addSubview(containerView)
        containerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        
        stackView = MDStackView()
        
        containerView.addSubview(imageView)
        containerView.addSubview(stackView)
        let imageHeight = (bounds.width*HomeCellType.ImageTextCell.aspectRatio)
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: imageHeight)
        
        stackView.anchor(imageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let bottomConstraint = NSLayoutConstraint.init(item: containerView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(bottomConstraint)
    }
    
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        guard let storyViewModel = data as? StoryViewModel else{
            return
        }
        
        imageView.loadImageFromUrl(url: storyViewModel.heroImageURl)
        
        stackView.config(storyViewModel: storyViewModel)

    }
  
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        //diff on associatedmetadata and reset to ui to default
//
//    }
    
}

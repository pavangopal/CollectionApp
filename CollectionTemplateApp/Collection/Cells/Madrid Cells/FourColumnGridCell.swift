//
//  FourColumnGridCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/20/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class FourColumnGridCell: BaseCollectionCell {
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var sectionNameLabel: InsetLabel = {
        let label = InsetLabel()
        label.backgroundColor = .black
        label.alpha = 0.7
        label.textColor = .white
        label.insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    var storyTitleContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var headlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.textColor = .white
        label.setProperties()
        label.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        return label
    }()
    
    var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(sectionNameLabel)
        containerView.addSubview(storyTitleContainerView)
        storyTitleContainerView.addSubview(headlineLabel)
        
        containerView.fillSuperview()
        
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 180)
        
        sectionNameLabel.anchor(nil, left: containerView.leftAnchor, bottom: imageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 15, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        storyTitleContainerView.anchor(imageView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 120)
        
        headlineLabel.anchor(storyTitleContainerView.topAnchor, left: storyTitleContainerView.leftAnchor, bottom: storyTitleContainerView.bottomAnchor, right: storyTitleContainerView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        styleUIFor(metaData: nil)
    }

    
    override func configure(data: Any?) {
        guard let story = data as? Story else {return}
        
        if let heroImageS3Key = story.hero_image_s3_key{
            
            let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: nil)
        }
        
        headlineLabel.text = story.headline ?? ""
        sectionNameLabel.text = story.sections.first?.display_name ?? story.sections.first?.name ?? ""
        
    }
    
    
    private func styleUIFor(metaData:AssociatedMetadata?) {
        if metaData?.theme == .Dark{
            headlineLabel.backgroundColor = .black
            storyTitleContainerView.backgroundColor = .black
            headlineLabel.textColor = .white
        }else{
            headlineLabel.backgroundColor = .white
            storyTitleContainerView.backgroundColor = .white
            headlineLabel.textColor = .black
        }
    }
}


















//
//  FullImageSliderCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/22/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class FullImageSliderCell: BaseCollectionCell {
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var stackView:MDStackView!
    
    override func setUpViews(){ 
        super.setUpViews()
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        stackView = MDStackView()
        stackView.headlineLabel.textColor = .white
        stackView.authorNameLabel.textColor = .white
        stackView.sectionUnderLineView.isHidden = true
        stackView.publishTimeLabel.textColor = .white
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(stackView)
        
        imageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView.applyGradient(colors: [UIColor.clear,UIColor.black], locations: nil, startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 1, y: 1),frame:CGRect(x: 0, y: 0, width:
            screenWidth, height: 450))
        
        stackView.anchor(nil, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
   
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        guard let storyViewModel = data as? StoryViewModel else{
            return
        }
        
        imageView.loadImageFromUrl(url: storyViewModel.heroImageURl)
        
        stackView.config(storyViewModel: storyViewModel)
      
    }
    
}

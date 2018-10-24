//
//  ExplainerHeaderImageCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/22/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher

class ExplainerHeaderImageCell: BaseCollectionCell {
 
    var backgroundContainerView:UIView = {
        let view = UIView()
        
        return view
    }()
    
    var backgroundImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var cirlceView:GradientView = {
        let view = GradientView()
        view.mode = .radial
        return view
    }()
    
    var innerCircleImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var explainedLabel:InsetLabel = {
        let label = InsetLabel()
        label.backgroundColor = .black
        label.insets = UIEdgeInsets(top: 5 , left: 5, bottom: 5, right: 5)
        label.font = FontService.shared.listCellStoryHeadlineFont
        label.textColor = .white
        label.text = "Explained"
        return label
    }()
    
    var cardsCountLabel:InsetLabel = {
        let label = InsetLabel()
        label.insets = UIEdgeInsets(top: 5 , left: 5, bottom: 5, right: 5)
        label.backgroundColor = .black
        label.font = FontService.shared.listCellEngagmentFont
        label.textColor = .white
        
        return label
    }()
    
    var centerYConstraint: NSLayoutConstraint?
    
    var headerTransform = CATransform3DIdentity
    
    var parallaxOffset: CGFloat = 0{
        didSet{
            centerYConstraint?.constant = parallaxOffset
        }
    }
    
    override func setUpViews(){
        
        contentView.clipsToBounds = true
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(backgroundContainerView)
        
        contentView.addSubview(cirlceView)
        cirlceView.addSubview(innerCircleImageView)
        
        contentView.addSubview(explainedLabel)
        contentView.addSubview(cardsCountLabel)
        
        backgroundContainerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        backgroundContainerView.addBlur(style: .dark)
        
        
        backgroundImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        //        centerYConstraint = backgroundImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        //        centerYConstraint?.isActive = true
        
        cirlceView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth * 0.90, heightConstant: screenWidth * 0.90)
        cirlceView.anchorCenterYToSuperview(constant: 30)
        cirlceView.anchorCenterXToSuperview()
        cirlceView.layer.cornerRadius = (screenWidth * 0.90)/2
        cirlceView.clipsToBounds = true
//        cirlceView.colors = [margin.storySectionColor.primaryColor,margin.storySectionColor.darkColor]
        
        innerCircleImageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: (screenWidth * 0.70) - 20, heightConstant: (screenWidth * 0.70) - 20)
        innerCircleImageView.anchorCenterYToSuperview(constant: 0)
        innerCircleImageView.anchorCenterXToSuperview()
        innerCircleImageView.layer.cornerRadius = ((screenWidth * 0.70) - 20)/2
        innerCircleImageView.clipsToBounds = true
        
        explainedLabel.anchorCenterXToSuperview()
        
        cardsCountLabel.anchor(explainedLabel.bottomAnchor, left: nil, bottom: contentView.bottomAnchor, right: nil, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        cardsCountLabel.anchorCenterXToSuperview()
        explainedLabel.adjustAnchorPoint(CGPoint(x: 0.5, y: 0.4))
        
        self.explainedLabel.transform = CGAffineTransform(rotationAngle: -0.1)
        
    }
    
    override func configure(data: Any?) {
        guard let story = data as? Story else{
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let hasSummaryElement = story.cards.flatMap({$0.story_elements}).contains(where: {$0.subtype == storySubType.summery.rawValue})
            
            DispatchQueue.main.async {
                if hasSummaryElement{
                    self.cardsCountLabel.text = "in \(story.cards.count - 1) cards"
                }else{
                    self.cardsCountLabel.text = "in \(story.cards.count) cards"
                }
            }
        }
        
        if let heroImageS3Key = story.hero_image_s3_key{
            
            backgroundImageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: nil, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
            innerCircleImageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: CGSize(width: ((screenWidth * 0.70) - 20), height: ((screenWidth * 0.70) - 20)), placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
            
        }
    }
    
    func updateParallaxOffet(collectionViewBounds:CGRect){
        
        if collectionViewBounds.origin.y > 0{
            
            parallaxOffset = collectionViewBounds.origin.y
            
        }else{
        
            parallaxOffset = 0
        }
    }
    
}

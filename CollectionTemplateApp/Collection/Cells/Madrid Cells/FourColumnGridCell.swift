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
        label.font = FontService.shared.homeSectionFont
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
//        label.textColor = .white
        label.font = FontService.shared.homeHeadlineRegular
        label.setProperties()
        return label
    }()
    
    var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var ratingView:FloatRatingView = {
        let ratingView = FloatRatingView()
        ratingView.isHidden = true
        ratingView.clipsToBounds = true
        ratingView.maxRating = 5
        ratingView.minRating = 0
        ratingView.fullImage = AssetImage.FullStarRating.image
        ratingView.emptyImage = AssetImage.EmptyStarRating.image
        ratingView.editable = false
        ratingView.type = FloatRatingView.FloatRatingViewType.halfRatings
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    var ratingViewHeightConstraint:NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(sectionNameLabel)
        containerView.addSubview(storyTitleContainerView)
        storyTitleContainerView.addSubview(headlineLabel)
        
        containerView.addSubview(ratingView)
        
        containerView.fillSuperview()
        
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 180)
        
        sectionNameLabel.anchor(nil, left: containerView.leftAnchor, bottom: imageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 15, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        storyTitleContainerView.anchor(imageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        headlineLabel.anchor(storyTitleContainerView.topAnchor, left: storyTitleContainerView.leftAnchor, bottom: storyTitleContainerView.bottomAnchor, right: storyTitleContainerView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        ratingView.anchor(storyTitleContainerView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 0)
        ratingViewHeightConstraint = ratingView.heightAnchor.constraint(equalToConstant: 20)
        ratingViewHeightConstraint?.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: ratingView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(bottomConstraint)
        
    }
    
    
    override func configure(data: Any?,associatedMetaData:AssociatedMetadata?) {
        guard let story = data as? Story else {return}
        
        
        if let heroImageS3Key = story.hero_image_s3_key{
            
            let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: nil)
        }
        
        
        if story.story_template == StoryTemplet.Review {
            ratingViewHeightConstraint?.constant = 20
            ratingView.isHidden = false
            ratingView.rating = story.storyMetadata?.review_rating?.value ?? 0.0
        }else{
            ratingViewHeightConstraint?.constant = 0
            ratingView.isHidden = true
        }
        
//        headlineLabel.text = story.headline ?? ""
        sectionNameLabel.text = story.sections.first?.display_name ?? story.sections.first?.name ?? ""
        
        styleUIFor(metaData: associatedMetaData,story:story)
    }
    
    
    private func styleUIFor(metaData:AssociatedMetadata?,story:Story) {
        if metaData?.theme == .Dark{
            contentView.backgroundColor = .black
            headlineLabel.backgroundColor = .black
            storyTitleContainerView.backgroundColor = .black
            let attributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:FontService.shared.homeHeadlineRegular]
            let healineString = NSAttributedString(string: story.headline ?? "", attributes: attributes)
            headlineLabel.attributedText = healineString
//            headlineLabel.textColor = .white
        }else{
            contentView.backgroundColor = .white
            headlineLabel.backgroundColor = .white
            storyTitleContainerView.backgroundColor = .white
//            headlineLabel.textColor = .black
            let attributes = [NSAttributedStringKey.foregroundColor : UIColor.black,NSAttributedStringKey.font:FontService.shared.homeHeadlineRegular]
            let healineString = NSAttributedString(string: story.headline ?? "", attributes: attributes)
            headlineLabel.attributedText = healineString
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        headlineLabel.textColor = .black
//    }
}


















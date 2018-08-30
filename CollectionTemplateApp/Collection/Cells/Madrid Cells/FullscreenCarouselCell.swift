//
//  FullscreenCarouselCell.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher

class FullscreenCarouselCell: BaseCollectionCell {
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var sectionLabel:InsetLabel = {
        let label = InsetLabel()
        label.setBasicProperties()
        label.insets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)

        return label
    }()
    
    var titleTextView:UITextView = {
        let textView = UITextView()
        
        textView.setBasicProperties()
        textView.textContainer.lineBreakMode = .byTruncatingTail

        return textView
    }()
    
    var authortextView: UITextView = {
        let textView = UITextView()
        textView.setBasicProperties()
        return textView
    }()
    
    var dateLabel: InsetLabel = {
        let label = InsetLabel()
        label.setBasicProperties()
        return label
    }()
    
    var videoIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true

        return imageView
    }()
    
    var authorImageView:UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    var authorImageViewWidthConstraint:NSLayoutConstraint?
    var lineWidth:CGFloat = 0
    
    override func setupViews() {
        super.setupViews()
        
        containerView.clipsToBounds = true
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(imageView)
        imageView.addSubview(videoIconImageView)
        
        containerView.addSubview(sectionLabel)
        
        containerView.addSubview(titleTextView)
        containerView.addSubview(authortextView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(authorImageView)
        
        containerView.fillSuperview()
        
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        videoIconImageView.anchorCenterSuperview()
        
        sectionLabel.anchor(imageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: defaultPadding, bottomConstant: 0, rightConstant: 0 , widthConstant: 0, heightConstant: 30)
        
        titleTextView.anchor(sectionLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: defaultPadding, leftConstant: defaultPadding, bottomConstant: defaultPadding, rightConstant: defaultPadding, widthConstant: 0, heightConstant: 75)
        
        authorImageView.anchor(titleTextView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: defaultPadding, leftConstant: defaultPadding, bottomConstant: 16, rightConstant: defaultPadding, widthConstant: 0, heightConstant: 50)
        
        authorImageViewWidthConstraint = authorImageView.widthAnchor.constraint(equalToConstant: 0)
        authorImageViewWidthConstraint?.priority = UILayoutPriority.init(999)
        authorImageViewWidthConstraint?.isActive = true
        
        authortextView.anchor(authorImageView.topAnchor, left: authorImageView.rightAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: defaultPadding, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        dateLabel.anchor(authortextView.bottomAnchor, left: authortextView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
  
    
    override func configure(data:Any?){
        
        guard let story = data as? Story else{
            return
        }
        
        if let heroImageS3Key = story.hero_image_s3_key{
            
            let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: nil, animation: ImageTransition.fade(0.2))
        }
        
        titleTextView.text = story.headline
        
        if let storySection = story.sections[0].display_name{
            self.sectionLabel.text = storySection
            
        }
        
        if let authorName = story.authors.first?.name{
            self.authortextView.text = authorName
            
        }
        
        if let imageString = story.authors.first?.avatar_url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let imageURL = URL(string:"\(imageString)"){
            authorImageViewWidthConstraint?.constant = 50
            self.authorImageView.kf.setImage(with: imageURL, completionHandler: { [weak self] (image, error, cachetype, url) in
                guard let selfD = self else{return}
                
                    selfD.authorImageView.image = image
                
            })
        }else{
            authorImageViewWidthConstraint?.constant = 0
            
        }
        
        if let publishedDate = story.first_published_at{ self.dateLabel.text = publishedDate.convertTimeStampToDate }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoIconImageView.isHidden = true
    }
    
    
}

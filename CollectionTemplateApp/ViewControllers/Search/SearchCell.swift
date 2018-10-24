//
//  SearchCell.swift
//  CoreApp-iOS
//
//  Created by Albin CR on 2/14/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher

class SearchCell: BaseCollectionCell {
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var topLine:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    var imageView:UIImageView = {
        let view = UIImageView()
        view.image = AssetImage.ImagePlaceHolder.image
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var photoIconImageView:UIImageView = {
        let view = UIImageView()
        view.image = AssetImage.PhotoBlack.image
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var storyHeadelineTextView:UITextView = {
        let textView = UITextView()
        textView.setBasicProperties()
        textView.dataDetectorTypes = []
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    var authorTimestampLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = FontService.shared.searchScreenAuthorTimeStampFont
        label.textColor = UIColor.darkGray
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var videoIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = AssetImage.PlayCircle.image
        return imageView
    }()
    
    var engagmentLabel:InsetLabel = {
        let label = InsetLabel()
        label.backgroundColor = ThemeService.shared.theme.primaryQuintColor
        label.font = FontService.shared.listCellEngagmentFont
        label.textColor = ThemeService.shared.theme.primaryTextColor
        
        label.insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return label
    }()
    
    var imageWidthConstraint:NSLayoutConstraint?
    var storyTemplate:StoryTemplet?
    var authorAndImageTopConstraint: NSLayoutConstraint?
    var authorAndTextViewTopConstraint: NSLayoutConstraint?
    var imageViewLeadingConstraint:NSLayoutConstraint?
    
    override func setUpViews(){
        
        contentView.addSubview(containerView)
        containerView.clipsToBounds = true
        
        containerView.addSubview(topLine)
        containerView.addSubview(imageView)
        imageView.addSubview(videoIconImageView)
        imageView.addSubview(photoIconImageView)
        containerView.addSubview(storyHeadelineTextView)
        containerView.addSubview(authorTimestampLabel)
        
        containerView.addSubview(engagmentLabel)
        
        containerView.fillSuperview()
        
        topLine.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 2)
        
        imageView.anchor(containerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        
        imageViewLeadingConstraint = imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15)
        imageViewLeadingConstraint?.priority = UILayoutPriority(rawValue: 999)
        imageViewLeadingConstraint?.isActive = true
        
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 120)
        imageWidthConstraint?.priority = UILayoutPriority(rawValue: 999)
        imageWidthConstraint?.isActive = true
        
        storyHeadelineTextView.anchor(containerView.topAnchor, left: imageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        authorAndTextViewTopConstraint = authorTimestampLabel.topAnchor.constraint(equalTo: storyHeadelineTextView.bottomAnchor, constant: 10)
        
        authorAndTextViewTopConstraint?.priority = UILayoutPriority.init(999)
        
        authorAndTextViewTopConstraint?.isActive = true
        
        authorAndImageTopConstraint =  authorTimestampLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        
        authorAndImageTopConstraint?.priority = UILayoutPriority.defaultLow
        
        authorAndImageTopConstraint?.isActive = true
        
        authorTimestampLabel.anchor(nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 15, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        engagmentLabel.anchor(nil, left: nil, bottom: authorTimestampLabel.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        videoIconImageView.anchorCenterSuperview()
        photoIconImageView.anchor(nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        
    }
    
    override func configure(data: Any?) {
        
        guard let story = data as? Story else {
            return
        }
        
        self.updateUIBasedOnTemplet(story: story)
        
        let textColor = ThemeService.shared.theme.listCellTextColor
        let headlineString = Helper.getAttributtedString(for: story.headline, textOption: textOption.searchTitle(color: textColor).textAttributtes)
        
        let displayString = self.prependSectionNameToHeadline(story: story, attributtedString: headlineString)
        
        storyHeadelineTextView.attributedText = displayString
        
        self.showAuthorAndTimeStamp(story: story)
        
        if let engagmentCount = story.engagment?.engagmentCount,engagmentCount > 999{
            let doubleValue = (Double(engagmentCount)/1000.0)
            let displayValue =  String(format:"%.1f", doubleValue)
            engagmentLabel.text = "\(displayValue)K"
            engagmentLabel.isHidden = false
        }else{
            engagmentLabel.isHidden = true
        }
        
    }
    
    func showImage(story:Story){
        
        if let heroImageS3Key = story.hero_image_s3_key{
            
            let imageSize = CGSize(width: 120, height: 80)
            imageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))

        }
        
    }
    
    func showAuthorAndTimeStamp(story:Story){
        if let authorName = story.author_name?.uppercased() {
            var authorTimeStampText = authorName
            if let publishedAtString = story.published_at?.convertTimeStampToDate {
                authorTimeStampText = authorTimeStampText + " | " + publishedAtString
            }
            self.authorTimestampLabel.text = authorTimeStampText
            
        }else if let publishedAtString = story.published_at?.convertTimeStampToDate {
            self.authorTimestampLabel.text = publishedAtString
        }
        
    }
    
    func updateUIBasedOnTemplet(story:Story){
        
        let sectionColor = ThemeService.shared.theme.primarySectionColor
        
//        self.topLine.applyGradient(colors: [sectionColor.primaryColor,sectionColor.lightColor], locations: nil, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0), frame: CGRect(x: 0, y: 0, width: screenWidth, height: 2))
        
        guard let storyTempletD = story.story_template else {
            self.imageWidthConstraint?.constant = 0
            return
        }
        
        switch storyTempletD {
            
        case .Photo:
            
            self.imageWidthConstraint?.constant = 120
            self.showImage(story: story)
            videoIconImageView.isHidden = true
            
            authorAndImageTopConstraint?.isActive = true
            authorAndTextViewTopConstraint?.isActive = false
            imageViewLeadingConstraint?.constant = 15
            photoIconImageView.isHidden = false
            
        case .Video:
            photoIconImageView.isHidden = true
            self.imageWidthConstraint?.constant = 120
            self.showImage(story: story)
            videoIconImageView.isHidden = false
            authorAndImageTopConstraint?.isActive = true
            authorAndTextViewTopConstraint?.isActive = false
            imageViewLeadingConstraint?.constant = 15
            
        default:
            photoIconImageView.isHidden = true
            authorAndImageTopConstraint?.isActive = false
            authorAndTextViewTopConstraint?.isActive = true
            videoIconImageView.isHidden = true
            self.imageWidthConstraint?.constant = 0
            imageViewLeadingConstraint?.constant = 5
        }
    }
    
    private func prependSectionNameToHeadline(story:Story,attributtedString:NSAttributedString?)->NSMutableAttributedString?{
        
        guard let unwrappedAttributtedString = attributtedString else {
            return nil
        }
        
        
        let headlineMutableAttributtedStirng = NSMutableAttributedString(attributedString:unwrappedAttributtedString)
        
        if let sectionName = story.sections.first?.name{
            
            let sectionColor = ThemeService.shared.theme.primarySectionColor
            let sectionNameString = sectionName.uppercased() + "  "
            
            let finalAttributtedStringWithSectionName = Helper.getPlainAttributtedString(string: sectionNameString, font: FontService.shared.searchScreenSectionFont, textColor: sectionColor)
            finalAttributtedStringWithSectionName.append(headlineMutableAttributtedStirng)
            return finalAttributtedStringWithSectionName
            
        }else{
            return headlineMutableAttributtedStirng
        }
        
        
        
    }
    
    override func prepareForReuse() {
        videoIconImageView.isHidden = true
    }
    
}

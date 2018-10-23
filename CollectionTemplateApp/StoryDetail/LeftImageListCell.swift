//
//  LeftImageListCell.swift
//  TheQuint-Staging
//
//  Created by Albin.git on 2/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//


import UIKit
import Quintype
import Kingfisher

class LeftImageListCell: BaseCollectionCell {
    
    
    let coverView:UIView = {
        
        let view = UIView()
        return view
        
    }()
    
    let mainImage:UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    var storyTitleTextView:UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = FontService.shared.getCorrectedFont(fontName: FontFamilyName.CooperHewittSemibold.rawValue, size: 18)
        textView.setBasicProperties()
        textView.textContainer.lineBreakMode = .byTruncatingTail
        
        return textView
    }()

    
    var engagmentLabel:InsetLabel = {
        let label = InsetLabel()
        label.backgroundColor = ThemeService.shared.theme.primaryQuintColor
        label.font = FontService.shared.listCellEngagmentFont
        label.textColor = ThemeService.shared.theme.primaryTextColor
        
        label.insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return label
    }()
    
    var videoIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = AssetImage.PlayCircle.image
        return imageView
    }()
    
    var sponsoredLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.numberOfLines = 1
        label.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
        label.textColor = ThemeService.shared.theme.primaryTextColor
        label.font = FontService.shared.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 13.0)
        
        return label
    }()
    
    var sectionSlug:String?
    let gifImageView = UIImageView(frame: CGRect(x: 0, y: 4, width: 13, height: 13))
    var textColor = ThemeService.shared.theme.listCellTextColor
    
    override func setUpViews() {
        contentView.backgroundColor = .white
        let view = contentView
        
        view.addSubview(coverView)
        coverView.addSubview(mainImage)
        coverView.addSubview(storyTitleTextView)
        coverView.addSubview(sponsoredLabel)
        coverView.addSubview(engagmentLabel)
        mainImage.addSubview(videoIconImageView)
        
        videoIconImageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        videoIconImageView.anchorCenterSuperview()
        
        coverView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        mainImage.anchor(coverView.topAnchor, left: coverView.leftAnchor, bottom: coverView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120 , heightConstant: 80)
        
        storyTitleTextView.anchor(coverView.topAnchor, left: mainImage.rightAnchor, bottom: nil, right: coverView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        engagmentLabel.anchor(nil, left: nil, bottom: coverView.bottomAnchor, right: coverView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        sponsoredLabel.anchor(storyTitleTextView.bottomAnchor, left: storyTitleTextView.leftAnchor, bottom: coverView.bottomAnchor, right: storyTitleTextView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        sponsoredLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        setupTheme()
        self.storyTitleTextView.addSubview(gifImageView)
    }
    
    func setupTheme(){
        
        storyTitleTextView.font = FontService.shared.getCorrectedFont(fontName: FontFamilyName.CooperHewittSemibold.rawValue, size: 18)
        engagmentLabel.backgroundColor = ThemeService.shared.theme.primaryQuintColor
    }
    
    
    override func configure(data: Any?) {
        
        guard let story = data as? Story else {
            return
        }
        
        
        
        self.updateCellColor()
        
        if let heroImageS3Key = story.hero_image_s3_key{
            
            let imageSize = CGSize(width: 120, height: 80)
            mainImage.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2), success: {
                if story.story_template == StoryTemplet.Video {
                    self.videoIconImageView.isHidden = false
                }else{
                    self.videoIconImageView.isHidden = true
                }
            })
        }
        
        let disPlayString = Helper.getAttributtedString(for: story.headline, textOption: textOption.leftRightImageCellHeadlineFont(color: textColor).textAttributtes)
        
        if (story.story_template == .LiveBlog && !(story.storyMetadata?.is_closed ?? false)){
            //if live blog is closed dont show the gif image
            gifImageView.isHidden = false
            let titleWithAttachment = attachImageToTextView(attributtedString: disPlayString)
            storyTitleTextView.attributedText = titleWithAttachment
            updateCellColor()
        }else{
            gifImageView.isHidden = true
            storyTitleTextView.attributedText = disPlayString
            updateCellColor()
        }
        
        if let engagmentCount = story.engagment?.engagmentCount,engagmentCount > 999{
            let doubleValue = (Double(engagmentCount)/1000.0)
            let displayValue =  String(format:"%.1f", doubleValue)
            engagmentLabel.text = "\(displayValue)K"
            engagmentLabel.isHidden = false
        }else{
            engagmentLabel.isHidden = true
        }
        if let _ = story.storyMetadata?.sponsored_by{
            sponsoredLabel.text = "SPONSORED"
        }else{
            sponsoredLabel.text = nil
        }
    }
    
    func updateCellColor(){
        
        switch sectionSlug ?? "" {
            
        case "neon":
            self.contentView.backgroundColor = UIColor(hexString: "#00012e")
            storyTitleTextView.textColor = .white
            
            
        case "videos":
            contentView.backgroundColor = ThemeService.shared.theme.defaultDarkBackGroundColor
            storyTitleTextView.textColor = .white
            
            
        default:
            self.contentView.backgroundColor = .white
            storyTitleTextView.textColor = textColor
            
        }
    }
    
    private func attachImageToTextView(attributtedString:NSAttributedString?)->NSMutableAttributedString?{
        
        guard let unwrappedAttributtedString = attributtedString else {
            return nil
        }
        
        let displayString = NSMutableAttributedString(attributedString: unwrappedAttributtedString)
        let textAttachment = NSTextAttachment()
        
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 17, height: 15)
        
        
        gifImageView.image?.withRenderingMode(.alwaysTemplate)
        
        
//        gifImageView.kf.setImage(with: Bundle.main.url(forResource: "liveblog", withExtension: "gif")!)
        
        let imageAttrachmentString =  NSAttributedString(attachment: textAttachment)
        let finalAttributtedStringWithImage = NSMutableAttributedString(attributedString:imageAttrachmentString)
        
        let staticString = "LIVE "
        
        let separatorAttributtes = Helper.getPlainAttributtedString(string: staticString, font: FontService.shared.primaryBoldFont, textColor: UIColor(hexString:"#23e8bc"))
        
        finalAttributtedStringWithImage.append(separatorAttributtes)
        finalAttributtedStringWithImage.append(displayString)
        
        return finalAttributtedStringWithImage
        
    }
    
    override func prepareForReuse() {
        videoIconImageView.isHidden = true
        sponsoredLabel.text = nil
        
    }
}

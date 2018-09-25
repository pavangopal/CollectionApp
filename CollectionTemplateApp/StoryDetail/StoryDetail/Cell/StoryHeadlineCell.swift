//
//  StoryHeadlineCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/28/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher

class StoryHeadlineCell: BaseCollectionCell {
    var gradianView:UIView = {
        let view = UIView()
        return view
    }()
    
    var headlineTextView:UITextView = {
        let textView = UITextView()
        textView.font = FontService.shared.storyHeadlineFont
        textView.textColor = ThemeService.shared.theme.primaryTextColor
        textView.setBasicProperties()
        
        return textView
    }()
    
    var iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 4, width: 20, height: 20))
    
    public override func setUpViews(){
        
        //layout views
        contentView.backgroundColor = (margin.storyTemplet == .LiveBlog || margin.storyTemplet == .Video || margin.storyTemplet == .Explainer) ?  UIColor(hexString:"#333333") : .white
        
        headlineTextView.backgroundColor = .clear
        
        contentView.addSubview(headlineTextView)
        
        headlineTextView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: margin.Top, leftConstant: margin.Left, bottomConstant: margin.Bottom, rightConstant: padding, widthConstant: 0, heightConstant: 0)
        
        self.headlineTextView.addSubview(imageView)
    }
    
    override func configure(data: Any?) {
        
        guard let story = data as? Story else{
            return
        }
        
        imageView.image = nil
        
        var textColor = ThemeService.shared.theme.primarySectionColor
        
        
//        if (self.margin.storyTemplet == .LiveBlog) || (self.margin.storyTemplet == .Video){
//            textColor = .white
//        }else if (self.margin.storyTemplet == .Explainer){
//            textColor = ParentSectionColor.videos.primaryColor
//        }else if self.margin.storySectionColor == ParentSectionColor.UNKNOWN{
//            textColor = ThemeService.shared.theme.darkPurpleColor
//        }
        
        
        
        var storyHeadline = story.headline
        
        if story.story_template == StoryTemplet.Review,let storyHeadlineD = storyHeadline{
            storyHeadline = "Review: " + storyHeadlineD
        }
        
        let disPlayString = Helper.getAttributtedString(for: storyHeadline, textOption: textOption.headline(color: textColor).textAttributtes)
        
//        if (self.margin.storyTemplet == .Video){
//            contentView.applyGradient(colors: [ThemeService.shared.theme.primarySectionColor,ThemeService.shared.theme.primarySectionColor,self.margin.storySectionColor.lightColor], locations: nil, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
//        }
        
        if (self.margin.storyTemplet == .LiveBlog && !(story.storyMetadata?.is_closed ?? false)){
            //if live blog is closed dont show the gif image 
            headlineTextView.attributedText = attachImageToTextView(attributtedString: disPlayString)
            imageView.isHidden = false
        }else if (self.margin.storyTemplet == .Photo){
            headlineTextView.attributedText = prefixPhotoIcon(attributtedString: disPlayString)
            imageView.isHidden = false
        }else{
            headlineTextView.attributedText = disPlayString
            imageView.isHidden = true
        }
  
    }
    
    private func attachImageToTextView(attributtedString:NSAttributedString?)->NSMutableAttributedString?{
        
        guard let unwrappedAttributtedString = attributtedString else {
            return nil
        }
        
        let displayString = NSMutableAttributedString(attributedString:unwrappedAttributtedString)
        let textAttachment = NSTextAttachment()
        
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        imageView.image?.withRenderingMode(.alwaysTemplate)

        
        imageView.kf.setImage(with: Bundle.main.url(forResource: "liveblog", withExtension: "gif")!)
        
        let imageAttrachmentString =  NSAttributedString(attachment: textAttachment)
        let finalAttributtedStringWithImage = NSMutableAttributedString(attributedString:imageAttrachmentString)
        
        let staticString = " LIVE "
        
        let separatorAttributtes = Helper.getPlainAttributtedString(string: staticString, font: FontService.shared.primaryBoldFont, textColor: UIColor(hexString:"#23e8bc"))
        
        finalAttributtedStringWithImage.append(separatorAttributtes)
        finalAttributtedStringWithImage.append(displayString)
        
        return finalAttributtedStringWithImage
        
    }
    
    private func prefixPhotoIcon(attributtedString:NSAttributedString?)->NSMutableAttributedString?{
        
        guard let unwrappedAttributtedString = attributtedString else {
            return nil
        }
        
        let displayString = NSMutableAttributedString(attributedString:unwrappedAttributtedString)
        let textAttachment = NSTextAttachment()
        
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        imageView.image = AssetImage.PhotoWhite.image
        
        let imageAttrachmentString =  NSAttributedString(attachment: textAttachment)
        let finalAttributtedStringWithImage = NSMutableAttributedString(attributedString:imageAttrachmentString)
        
        let staticString = " "
        
        let separatorAttributtes = Helper.getPlainAttributtedString(string: staticString, font: FontService.shared.primaryBoldFont, textColor: UIColor(hexString:"#23e8bc"))
        
        finalAttributtedStringWithImage.append(separatorAttributtes)
        finalAttributtedStringWithImage.append(displayString)
        
        return finalAttributtedStringWithImage
        
    }
    
}

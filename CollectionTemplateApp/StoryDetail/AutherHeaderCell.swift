//
//  AutherHeaderCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/11/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class AutherHeaderCell: BaseCollectionCell {
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    var topStaticView:UIView = {
        let view = UIView()
        view.backgroundColor = ThemeService.shared.theme.primarySectionColor
        return view
    }()
    
    var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetImage.AuthorIcon.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var autherNameTextView:UITextView = {
        let textView = UITextView()
        
        textView.setBasicProperties()
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    var autherTwitterHandlerlabel:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        view.font = FontService.shared.blockQuoteAttributionFont
        view.textAlignment = .center
        return view
    }()
    
    var authorBioDescription: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.setBasicProperties()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    override func setUpViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(topStaticView)
        containerView.addSubview(authorImageView)
        containerView.addSubview(autherNameTextView)
        containerView.addSubview(autherTwitterHandlerlabel)
        containerView.addSubview(authorBioDescription)
        
        containerView.fillSuperview()
        
        topStaticView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        authorImageView.anchor(containerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth*0.40, heightConstant: screenWidth*0.40)
        authorImageView.anchorCenterXToSuperview()
        
        authorImageView.layer.cornerRadius = (screenWidth*0.40)/2
        authorImageView.clipsToBounds = true
        
        autherNameTextView.anchor(authorImageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        autherTwitterHandlerlabel.anchor(autherNameTextView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 5, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        authorBioDescription.anchor(autherTwitterHandlerlabel.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 10, leftConstant: 15, bottomConstant: 15, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        autherTwitterHandlerlabel.delegate = self
        authorBioDescription.delegate = self
    }
    
    
    override func configure(data: Any?) {
        
        guard let author = data as? Author else {
            return
        }
        
        if let imageString = author.avatar_url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let imageURL = URL(string:"\(imageString)"){
            
            self.authorImageView.kf.setImage(with: imageURL, placeholder: AssetImage.ImagePlaceHolder.image, options: nil, progressBlock: nil, completionHandler: { [weak self] (image, error, cachetype, url) in
                guard let selfD = self else{return}
                if error != nil{
                    selfD.authorImageView.image = AssetImage.AuthorIcon.image
                }else{
                    selfD.authorImageView.image = image
                    
                }
            })
        }else{
            self.authorImageView.image = AssetImage.AuthorIcon.image
        }
        
        self.setNameAndTwitterHandlerText(author: author)
        
        let bioAttributes = textOption.authorBio(color: ThemeService.shared.theme.primaryTextColor).textAttributtes
        let bioAttributtedString = Helper.getAttributtedString(for: author.bio, textOption: bioAttributes)
        
        self.authorBioDescription.setText(bioAttributtedString)
        
        addTwitterLink(author: author)
    }
    
    func setNameAndTwitterHandlerText(author:Author){
        
        let nameAttributes = textOption.titleElement(color: ThemeService.shared.theme.primaryTextColor).textAttributtes
        let roleAttributes = textOption.blockQuoteAttributtion(color:.lightGray).textAttributtes
        
        let nameAttributtedString = Helper.getAttributtedString(for: author.name, textOption: nameAttributes)
        let roleString = Helper.getAttributtedString(for: "AUTHOR", textOption: roleAttributes)
        
        
        let finalAttributtedString = Helper.combineAttributedStrings(str1: nameAttributtedString, str2: roleString, seperator: "<br>")
        
        self.autherNameTextView.attributedText = finalAttributtedString
        
        autherNameTextView.textAlignment = .center
    }
    
    func addTwitterLink(author:Author){
        if let twitterHandler = author.twitter_handle {
            
            if let url = URL(string:twitterHandler){
                let lastPathComp = url.lastPathComponent
                
                if lastPathComp.contains("@"){
                    autherTwitterHandlerlabel.text = lastPathComp.uppercased()
                }else{
                    autherTwitterHandlerlabel.text = "@" + lastPathComp.uppercased()
                }
                
                let urlString = "https://twitter.com/\(lastPathComp)"
                let labelString = autherTwitterHandlerlabel.text ?? ""
                let twitterHandlerNsString = labelString as NSString
                
                if let url = URL(string:urlString){
                    let range = twitterHandlerNsString.range(of: labelString)
                    autherTwitterHandlerlabel.addLink(to: url, with: range)
                }
            }
        }
        
    }
    
}

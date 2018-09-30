//
//  StoryHeader.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/26/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

class StoryHeadlineCell: BaseCollectionCell {
    lazy var sectionStackView = SectionStackView(frame: .zero)
    lazy var headlineSubHealineStackView = HeadlineSubHealineStackView(frame: .zero)
    lazy var authorStackView = AuthorStackView(frame: .zero)
    lazy var containerView = UIView(frame: .zero)
    
    var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = ThemeService.shared.theme.defaultLightGreyColor
        return view
    }()
    
    override func setUpViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(sectionStackView)
        containerView.addSubview(headlineSubHealineStackView)
        containerView.addSubview(authorStackView)
//        containerView.addSubview(lineView)
        
        containerView.fillSuperview()
        
        sectionStackView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        headlineSubHealineStackView.anchor(sectionStackView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        authorStackView.anchor(headlineSubHealineStackView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)

//        lineView.anchor(nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 1)
    }
    
    override func configure(data: Any?) {
        
        guard let story = data as? Story else{return}
        
        headlineSubHealineStackView.configData(headline: NSAttributedString(string: story.headline ?? "", attributes: [NSAttributedStringKey.font : FontService.shared.storyHeadlineFont,NSAttributedStringKey.foregroundColor:ThemeService.shared.theme.primaryTextColor]), subheadline: NSAttributedString(string: story.subheadline ?? "", attributes: [NSAttributedStringKey.font : FontService.shared.homeSubHeadlineRegular,NSAttributedStringKey.foregroundColor:ThemeService.shared.theme.primaryTextColor]))
        
        sectionStackView.sectionNameLabel.attributedText = NSAttributedString(string: story.sections.first?.display_name ?? "", attributes: [NSAttributedStringKey.font : FontService.shared.homeSectionFont,NSAttributedStringKey.foregroundColor:ThemeService.shared.theme.primaryTextColor])
        
        authorStackView.authorNameLabel.text = story.author_name
        authorStackView.publishTimeLabel.text = story.published_at?.convertTimeStampToDate
    }
    
}

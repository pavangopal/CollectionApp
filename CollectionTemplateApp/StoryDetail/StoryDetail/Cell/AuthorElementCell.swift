//
//  SocialElementCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/28/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol AuthorElementCellDelegate {
    func authorPressedAt(index:Int)
}

class AuthorElementCell: BaseCollectionCell {
    
    var authorDelegate:AuthorElementCellDelegate?
    
    var authorNamesContainer:UIView = {
        let view = UIView()
        
        return view
    }()
    
    var publishedAtLabel:UILabel = {
        let label = UILabel()
        label.font = FontService.shared.storyPostedTimeFont
        
        return label
    }()
    
    var sectionButton:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontService.shared.storyDetailAuthorFont
        return button
    }()
    
    var readTimeLabel:UILabel = {
        let label = UILabel()
        label.font = FontService.shared.storySectionFont
        return label
    }()
    
    var usableWidth:CGFloat = 0
    var yPos:CGFloat =  0{
        didSet{
            if yPos > oldValue{
                xPos = -5
            }
        }
    }
    
    var xPos:CGFloat = -5
    let buttonSpacing:CGFloat = 5
    let totalButtonInset:CGFloat = 0
    let tagButtonHeight:CGFloat = 25
    let buttonBorderWidth:CGFloat = 0
    
    var authorContainerViewHeightConstraint:NSLayoutConstraint?
    
    override func setUpViews(){
//        super.setUpViews()
        
        contentView.backgroundColor = (self.margin.storyTemplet == .LiveBlog || self.margin.storyTemplet == .Video || (self.margin.storyTemplet == .Explainer)) ?  UIColor(hexString:"#333333") : .white
        
        contentView.addSubview(authorNamesContainer)
        contentView.addSubview(publishedAtLabel)
        contentView.addSubview(readTimeLabel)
        contentView.addSubview(sectionButton)
        
        authorNamesContainer.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: 0, heightConstant: 0)
        
        authorContainerViewHeightConstraint = authorNamesContainer.heightAnchor.constraint(equalToConstant: 0)
        authorContainerViewHeightConstraint?.priority = UILayoutPriority.defaultLow
        authorContainerViewHeightConstraint?.isActive = true
            
        sectionButton.anchor(contentView.topAnchor, left: authorNamesContainer.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 4, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: 0, heightConstant: 30)
        
        publishedAtLabel.anchor(authorNamesContainer.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 4, leftConstant: padding, bottomConstant: padding, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        readTimeLabel.anchor(sectionButton.bottomAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: padding, rightConstant: padding, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func configure(data: Any?) {
        
        guard let story = data as? Story  else{
            
            return
        }
        
        
        addAuthors(story: story)
        
        if let publishedAt = story.published_at?.convertToDate as NSDate?{
            
            publishedAtLabel.text = Helper.timeAgoSinceDate(date: publishedAt, numericDates: true)
        }
        
        if story.sections.count > 0{
            let sectionName = story.sections[0].display_name ?? ""
            sectionButton.setTitle(sectionName.uppercased(), for: .normal)
            sectionButton.setTitleColor(ThemeService.shared.theme.primarySectionColor, for: .normal)
        }
        
        readTimeLabel.text = story.storyReadTime ?? ""
        
        if (self.margin.storyTemplet == .LiveBlog || self.margin.storyTemplet == .Video){
            readTimeLabel.textColor = .white
            publishedAtLabel.textColor = .white
            sectionButton.setTitleColor(.white, for: .normal)
        }
        
        else{
            readTimeLabel.textColor = ThemeService.shared.theme.primaryTextColor
            publishedAtLabel.textColor = ThemeService.shared.theme.primaryTextColor
        }
        
        if self.margin.storyTemplet == .LiveBlog{
            sectionButton.setTitleColor(ThemeService.shared.theme.liveblogSectionColor, for: .normal)
        }
    }
    
    
}

//MARK:- Events Handler functions

extension AuthorElementCell{
    
    func addAuthors(story:Story) {
        self.resetData()
        
        let verticalButtonSpacing = tagButtonHeight + buttonSpacing
        var totalViewHeight:CGFloat = verticalButtonSpacing
        
        if story.authors.count == 0{
            
            let authorName = (story.author_name ?? story.assignee_name ?? "")
            
            let button = configureAuthorButton(authorName: authorName.uppercased())
            button.tag = 0
            
            layoutTags(index: 0, button: button, authorName: authorName.uppercased())
            
        }else{
            let sectionName = story.sections[0].display_name?.uppercased()
            let sectionWidth = (sectionName?.getWidthOfString(with: FontService.shared.storyDetailAuthorFont)) ?? 0
            
            //to test multiple authors
//            var tempAuthors:[Author] = []
//            tempAuthors.append(contentsOf: story.authors)
//            tempAuthors.append(contentsOf: story.authors)
//            tempAuthors.append(contentsOf: story.authors)
            
            for (index,author) in story.authors.enumerated(){
                let isLastElement = (index == story.authors.count - 1)
                
                let authorName = author.name?.uppercased()
                let button = configureAuthorButton(authorName: authorName)
                let authorNameWidth = (authorName?.getWidthOfString(with: (button.titleLabel?.font)!)) ?? 0
                let buttonWidth = authorNameWidth + totalButtonInset + buttonBorderWidth + 5
                
                button.tag = index
                
                if (usableWidth < screenWidth - 30 - sectionWidth) && (usableWidth + buttonWidth < screenWidth - 30 - sectionWidth) {
                    
                    usableWidth = usableWidth + buttonWidth + buttonSpacing
                    layoutTags(index: index, button: button, authorName: authorName ?? "",isLastElement:isLastElement)
                    xPos = xPos + buttonWidth + buttonSpacing
                    
                }else{
                    
                    totalViewHeight = totalViewHeight + verticalButtonSpacing
                    usableWidth = buttonWidth + buttonSpacing
                    yPos =  yPos + tagButtonHeight
                    xPos = -5
                    
                    layoutTags(index: index, button: button, authorName: authorName ?? "",isLastElement:isLastElement)
                    xPos = xPos + buttonWidth + buttonSpacing
                    
                }
            }
        }
        
        authorNamesContainer.translatesAutoresizingMaskIntoConstraints = false
        
        authorContainerViewHeightConstraint?.constant = yPos + 30
        authorContainerViewHeightConstraint?.priority = UILayoutPriority.init(999)
        
    }
    
    func layoutTags(index:Int,button:UIButton,authorName:String,isLastElement:Bool? = false){
        
        let view = self.authorNamesContainer
        
        let buttonWidth = authorName.getWidthOfString(with: (button.titleLabel?.font)!)  + totalButtonInset + buttonBorderWidth + 10
        
        if isLastElement!{
            
            view.addSubview(button)
            
            let topConstrain = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: yPos)
            
            let letfConstrain = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: xPos)
            
            let bottomConstrain  = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            bottomConstrain.priority = UILayoutPriority(rawValue: 750)
            
            let widthConstarin = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: buttonWidth)
            
            let heightConstarin = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: tagButtonHeight)
            
            view.addConstraints([topConstrain,letfConstrain,bottomConstrain,widthConstarin,heightConstarin])
            
            
        }else{
            
            view.addSubview(button)
            
            let topConstrain = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: yPos)
            
            let letfConstrain = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: xPos)
            
            let widthConstarin = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: buttonWidth)
            
            let heightConstarin = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: tagButtonHeight)
            
            view.addConstraints([topConstrain,letfConstrain,widthConstarin,heightConstarin])
            
        }
    }
    
    
    func configureAuthorButton(authorName:String?) -> UIButton{
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0.1, left: 0, bottom: 0.1, right: 0)
        button.titleLabel?.font = FontService.shared.storyDetailAuthorFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(authorName ?? nil, for: .normal)
        
        if (self.margin.storyTemplet == .LiveBlog) || (self.margin.storyTemplet == .Video){
            
            button.setTitleColor(.white, for: .normal)
            
        }else if (self.margin.storyTemplet == .Explainer){
            
            button.setTitleColor(ThemeService.shared.theme.primarySectionColor, for: .normal)
            
        }else{
            button.setTitleColor(.black, for: .normal)
            
        }
        button.addTarget(self, action: #selector(authorButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }
    
    
    @objc func authorButtonPressed(sender:UIButton){
        print(#function)
        print("Author at index: \(sender.tag) pressed")
        
        self.authorDelegate?.authorPressedAt(index: sender.tag)
    }
    
    func resetData(){
        usableWidth = 0
        yPos = 0
        
        xPos = -5
       let _ = self.authorNamesContainer.subviews.map({$0.removeFromSuperview()})
        
        authorContainerViewHeightConstraint?.constant = 0
//        authorContainerViewHeightConstraint?.priority = UILayoutPriority.defaultLow
        authorContainerViewHeightConstraint?.priority = UILayoutPriority.init(999)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetData()
       
    }
    
}

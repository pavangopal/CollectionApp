//
//  StoryDetailstagElementCell.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/30/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Quintype

class StoryDetailsTagElementCell: BaseCollectionCell {
    
    var tagButton:[UIButton] = []
    
    var usableWidth:CGFloat = 0
    var yPos:CGFloat =  15
    var xPos:CGFloat = 15
    let buttonSpacing:CGFloat = 10
    let totalButtonInset:CGFloat = 10
    let tagButtonHeight:CGFloat = 30
    let buttonBorderWidth:CGFloat = 3
    
    var tagLabel:UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .white
        return label
        
    }()

    var tags:[Tag] = []
    
    var created:Bool = false
    
    override func configure(data: Any?) {
        
        let story = data as? Story
        
        if !created {
            if let tags = story?.tags{
                self.tags = tags
            }
            
            setUpViews()
            created = true
        }
        
    }
    
    
    
    func layoutTags(index:Int,button:UIButton,tag:String){
        
        let view = self.contentView

        let buttonWidth = tag.getWidthOfString(with: UIFont.systemFont(ofSize: 12))  + totalButtonInset + buttonBorderWidth + 10
        
        if index == tags.count - 1{
            
            view.addSubview(button)
            
            let topConstrain = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: yPos)
            
            let letfConstrain = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: xPos)
            
            let bottomConstrain  = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -20)
            
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
    
    override func setUpViews() {
        super.setUpViews()
        

        
        let view = self.contentView
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let verticalButtonSpacing = tagButtonHeight + buttonSpacing
        var totalViewHeight:CGFloat = verticalButtonSpacing
        
        for (index,tag) in tags.enumerated(){
            
            let buttonWidth = (tag.name?.getWidthOfString(with: UIFont.systemFont(ofSize:12)))! + totalButtonInset + buttonBorderWidth + 5
            let button = TagButton(frame: .zero)
            
            button.titleLabel?.font = FontService.shared.tagFont
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(tag.name, for: .normal)
            button.tag = index
            
            button.addTarget(self, action: #selector(tagButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            button.isUserInteractionEnabled = true
            tagButton.append(button)
            if (usableWidth < screenWidth - 20) && (usableWidth + buttonWidth < screenWidth - 20) {
                
                usableWidth = usableWidth + buttonWidth + buttonSpacing
                layoutTags(index: index, button: button, tag: tag.name!)
                xPos = xPos + buttonWidth + buttonSpacing
                
            }else{
                
                totalViewHeight = totalViewHeight + verticalButtonSpacing
                usableWidth = buttonWidth + buttonSpacing
                yPos =  yPos + tagButtonHeight + buttonSpacing
                xPos = 15
                layoutTags(index: index, button: button, tag: tag.name!)
                xPos = xPos + buttonWidth + buttonSpacing
                
            }
        }
    }
    
    
    
    @objc func tagButtonAction(sender:UIButton){
        
        if let tabBarController = self.window?.rootViewController as? CustomTabBarController {
            
            if let navigationController = tabBarController.selectedViewController as? UINavigationController{

                if let tag = tags[sender.tag].name{
                    let tagPageController = TagController(tagSlug: tag)
                    tracker(tag: tag)
                    navigationController.pushViewController(tagPageController, animated: true)
                }
            }
            
        }
        
    }
    
    func tracker(tag:String){
        
//        GoogleAnalytics.Track(with: .tag, event: .tagClicked)
//        GoogleAnalytics.Track(with: .tag, value: tag)
    }
    
 
}

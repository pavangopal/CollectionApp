//
//  StorySnapshotCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/30/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class StorySummaryCell: BaseCollectionCell {
    
    var snapShotHeaderView:UIView = {
        let view = UIView()
        view.backgroundColor = ThemeService.shared.theme.primaryColor
        return view
    }()
    
    var snapShotTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Summary"
        label.textColor = .white
        return label
    }()
    
    var dropDownButton:UIButton = {
        let button = UIButton()
        let upImage = AssetImage.upArrow.image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let downImage = AssetImage.downArrow.image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(upImage, for: .normal)
        button.setImage(downImage, for: .selected)
        button.tintColor = .white
        return button
    }()
    
    var textView: TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        return view
    }()
    
    var containerView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F5F5F5")
        return view
    }()
    
    var indexPath:IndexPath?
   
    override func setUpViews(){
        super.setUpViews()
        
        contentView.backgroundColor = .white
//        textView.backgroundColor = contentView.backgroundColor
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(snapShotHeaderView)
        snapShotHeaderView.addSubview(snapShotTitleLabel)
        
        containerView.addSubview(dropDownButton)
        containerView.addSubview(textView)
        
        containerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        snapShotHeaderView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 34)
        
        snapShotTitleLabel.anchor(containerView.topAnchor, left: snapShotHeaderView.leftAnchor, bottom: snapShotHeaderView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        dropDownButton.anchor(snapShotHeaderView.topAnchor, left: snapShotTitleLabel.rightAnchor, bottom: nil, right: snapShotHeaderView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 30, heightConstant: 30)
        
        textView.anchor(snapShotHeaderView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 10, leftConstant: self.margin.Left, bottomConstant: 10, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        textView.delegate = self
    }
    
    override func configure(data: Any?) {
        
        if let unwrappedIndexpath = indexPath{
            self.dottedLineView.isHidden = (unwrappedIndexpath.section == 1) //Dont show the dotted line for First section summary element
        }
        
        guard let storyElement = data as? CardStoryElement else{
            return
        }
        
        
        
        textView.setText(storyElement.displayText)
    }
}






//
//  QuestionElementCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/2/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class QuestionElementCell: BaseCollectionCell {
    
    var questionIconImage:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.clipsToBounds = true
        view.image = AssetImage.quintLogoOLD.image
        return view
    }()
    
    
    var questionTextView:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        view.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    
    var leftArrowImage:UIImageView = {
        let leftArrowImage = UIImageView()
        leftArrowImage.contentMode = .scaleAspectFill
        
        leftArrowImage.image = AssetImage.LeftArrowIcon.image.withRenderingMode(.alwaysTemplate)
        return leftArrowImage
    }()
    
    
    override func setUpViews(){
        super.setUpViews()
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        questionTextView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(questionIconImage)
        
        contentView.addSubview(questionTextView)
        
        contentView.addSubview(leftArrowImage)
        
        questionIconImage.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        
        leftArrowImage.anchor(questionIconImage.topAnchor, left: questionIconImage.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 20)
        
        questionTextView.anchor(contentView.topAnchor, left: leftArrowImage.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: -4, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        
        questionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        questionTextView.delegate = self
        
        questionIconImage.layer.cornerRadius = (35)/2
        
    }
    
    override func configure(data: Any?) {
        
        guard let storyElement = data as? CardStoryElement  else {
            return
        }
        
        leftArrowImage.tintColor = ThemeService.shared.theme.primarySectionColor
        
        questionTextView.backgroundColor = ThemeService.shared.theme.primarySectionColor
        
        questionTextView.setText(storyElement.displayText)
        
        
    }
}

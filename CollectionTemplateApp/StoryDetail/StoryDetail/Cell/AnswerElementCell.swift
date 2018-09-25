//
//  AnswerElementCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/2/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class AnswerElementCell: BaseCollectionCell {
    
    var answerIconImage:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.image = AssetImage.quintLogoOLD.image
        view.clipsToBounds = true
        return view
    }()
    
    
    var answerTextView:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        view.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    var rightArrowImage:UIImageView = {
        let rightArrowImage = UIImageView()
        rightArrowImage.contentMode = .scaleAspectFill
        rightArrowImage.image = AssetImage.RightArrowIcon.image.withRenderingMode(.alwaysTemplate)
        return rightArrowImage
    }()
    
    override func setUpViews(){
        super.setUpViews()
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        answerTextView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(answerIconImage)
        contentView.addSubview(answerTextView)
        contentView.addSubview(rightArrowImage)
        
        answerIconImage.anchor(contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: 0, bottomConstant: 0, rightConstant: self.margin.Right, widthConstant: 35, heightConstant: 35)
        
        rightArrowImage.anchor(answerIconImage.topAnchor, left: nil, bottom: nil, right: answerIconImage.leftAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 15, heightConstant: 20)
        
        answerTextView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: rightArrowImage.leftAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: -4, widthConstant: 0, heightConstant: 0)
        
        answerTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        answerTextView.delegate = self
        
        answerIconImage.layer.cornerRadius = (35)/2
    }
    
    override func configure(data: Any?) {
        
        guard let storyElement = data as? CardStoryElement  else {
            return
        }
        
        rightArrowImage.tintColor = UIColor(hexString:"F4F4F4")
        answerTextView.backgroundColor = UIColor(hexString:"F4F4F4")
        answerTextView.setText(storyElement.displayText)
    }
}

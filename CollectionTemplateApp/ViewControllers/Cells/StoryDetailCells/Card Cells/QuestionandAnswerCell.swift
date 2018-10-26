//
//  QuestionandAnswerCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/2/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class QuestionandAnswerCell: BaseCollectionCell {
    
    var questionIconImage:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.clipsToBounds = true
        view.image = AssetImage.quintLogoOLD.image
        return view
    }()
    
    var answerIconImage:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.image = AssetImage.quintLogoOLD.image
        view.clipsToBounds = true
        return view
    }()
    
    var questionTextView:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        view.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return view
    }()
    
    var answerTextView:TTTAttributedLabel = {
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
    
    var rightArrowImage:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = AssetImage.RightArrowIcon.image.withRenderingMode(.alwaysTemplate)
        return view
    }()
    
    var questionIconHeightConstraint : NSLayoutConstraint?
    var answerIconHeightConstraint : NSLayoutConstraint?
    
    var questionTextElementHeightConstraint : NSLayoutConstraint?
    var answerTextElementHeightConstraint : NSLayoutConstraint?
    
    override func setUpViews(){
        super.setUpViews()
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        questionTextView.backgroundColor = contentView.backgroundColor
        answerTextView.backgroundColor = contentView.backgroundColor
        
        contentView.addSubview(questionIconImage)
        contentView.addSubview(answerIconImage)
        contentView.addSubview(questionTextView)
        contentView.addSubview(answerTextView)
        
        contentView.addSubview(leftArrowImage)
        contentView.addSubview(rightArrowImage)
        
        
        questionIconImage.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 0)
        
        leftArrowImage.anchor(questionIconImage.topAnchor, left: questionIconImage.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 0)
        
        questionIconHeightConstraint = questionIconImage.heightAnchor.constraint(equalToConstant: 35)
        questionIconHeightConstraint?.isActive = true
        leftArrowImage.heightAnchor.constraint(equalTo: questionIconImage.heightAnchor, multiplier: 0.6).isActive = true
        
        let leftArrowImageEqualHeightConstraint = NSLayoutConstraint(item: leftArrowImage, attribute: .height, relatedBy: .equal, toItem: questionIconImage, attribute: .height, multiplier: 0.6, constant: 0)
        self.contentView.addConstraint(leftArrowImageEqualHeightConstraint)
        
        questionTextView.anchor(contentView.topAnchor, left: leftArrowImage.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: -4, bottomConstant: 0, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        
        questionTextElementHeightConstraint = questionTextView.heightAnchor.constraint(equalToConstant: 0)
        questionTextElementHeightConstraint?.priority = .defaultLow
        questionTextElementHeightConstraint?.isActive = true
        
        answerIconImage.anchor(questionTextView.bottomAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: padding, leftConstant: 0, bottomConstant: 0, rightConstant: self.margin.Right, widthConstant: 35, heightConstant: 0)
        
        rightArrowImage.anchor(answerIconImage.topAnchor, left: nil, bottom: nil, right: answerIconImage.leftAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 15, heightConstant: 0)
        
        answerIconHeightConstraint = answerIconImage.heightAnchor.constraint(equalToConstant: 35)
        answerIconHeightConstraint?.isActive = true
        
        let rightArrowImageEqualHeightConstraint = NSLayoutConstraint(item: rightArrowImage, attribute: .height, relatedBy: .equal, toItem: answerIconImage, attribute: .height, multiplier: 0.6, constant: 0)
        self.contentView.addConstraint(rightArrowImageEqualHeightConstraint)
        
        answerTextView.anchor(questionTextView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: rightArrowImage.leftAnchor, topConstant: padding, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: -4, widthConstant: 0, heightConstant: 0)
        
        answerTextElementHeightConstraint = answerTextView.heightAnchor.constraint(equalToConstant: 0)
        answerTextElementHeightConstraint?.priority = .defaultLow
        answerTextElementHeightConstraint?.isActive = true
        
        questionTextView.delegate = self
        answerTextView.delegate = self
        
        questionIconImage.layer.cornerRadius = (questionIconHeightConstraint?.constant ?? 0)/2
        answerIconImage.layer.cornerRadius = (answerIconHeightConstraint?.constant ?? 0)/2
    }
    
    override func configure(data: Any?) {
        
        guard let storyElement = data as? CardStoryElement  else {
            return
        }
        
        leftArrowImage.tintColor = ThemeService.shared.theme.primarySectionColor
        rightArrowImage.tintColor = UIColor(hexString:"F4F4F4")
        
        questionTextView.backgroundColor = ThemeService.shared.theme.primarySectionColor
        answerTextView.backgroundColor = UIColor(hexString:"F4F4F4")
        
        let questionElementAttributtes = textOption.questionElement(color: .white).textAttributtes
        
        if let questionAttributtedString = Helper.getAttributtedString(for: storyElement.metadata?.question, textOption: questionElementAttributtes){
//            questionTextView.attributedText = questionAttributtedString
            questionTextView.setText(questionAttributtedString)
            updateQuestionElement(shouldShow: true)
        }else{
            updateQuestionElement(shouldShow: false)
        }
        
        if let answerText = storyElement.displayText{
//            answerTextView.attributedText = answerText
            answerTextView.setText(answerText)
            updateAnswerElement(shouldShow: true)
        }else{
            updateAnswerElement(shouldShow: false)
        }
    }
    
    func updateQuestionElement(shouldShow:Bool){
        if shouldShow{
            questionIconHeightConstraint?.constant = 35
            questionTextElementHeightConstraint?.priority = .defaultLow
            self.leftArrowImage.isHidden = false
        }else{
            questionTextView.attributedText = nil
            questionIconHeightConstraint?.constant = 0
            self.leftArrowImage.isHidden = true
            questionTextElementHeightConstraint?.priority = .defaultHigh
        }
    }
    
    func updateAnswerElement(shouldShow:Bool){
        if shouldShow{
            self.answerIconHeightConstraint?.constant = 35
            answerTextElementHeightConstraint?.priority = .defaultLow
            self.rightArrowImage.isHidden = false
        }else{
            self.rightArrowImage.isHidden = true
            answerTextView.attributedText = nil
            self.answerIconHeightConstraint?.constant = 0
            answerTextElementHeightConstraint?.priority = .defaultHigh
        }
    }
}


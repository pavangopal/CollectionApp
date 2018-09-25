//
//  ExplainerTitleCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/23/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ExplainerTitleCell: BaseCollectionCell {
    
    var indexLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var titleTextView:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.isUserInteractionEnabled = false
        view.setBasicProperties()
        return view
    }()
    
    var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return  view
    }()
    
    var indicatorImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = AssetImage.Arrow.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ThemeService.shared.theme.primaryTextColor
        
        return imageView
    }()
    
    var TitleIndex = 1
    
    override func setUpViews(){
        super.setUpViews()
        
        self.contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        
        contentView.addSubview(titleTextView)
        contentView.addSubview(lineView)
        contentView.addSubview(indexLabel)
        contentView.addSubview(indicatorImageView)
        
        titleTextView.anchor(contentView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        indicatorImageView.anchor(nil, left: titleTextView.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: self.margin.Right, widthConstant: 18, heightConstant: 18)
        
        indicatorImageView.anchorCenterYToSuperview()
        
        indexLabel.anchor(titleTextView.topAnchor, left: contentView.leftAnchor, bottom: titleTextView.bottomAnchor, right: titleTextView.leftAnchor, topConstant: 0, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: self.margin.Left, widthConstant: 0, heightConstant: 0)
        titleTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        indexLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        lineView.anchor(titleTextView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 20, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 1)
        titleTextView.delegate = self
    }
    
    func configure(headline:String?,element:CardStoryElement?,index:Int){
        
        var textColor = ThemeService.shared.theme.primaryTextColor
        
        
        if index == 0{
            lineView.backgroundColor = .white
            indicatorImageView.isHidden = true
            
            let disPlayString = Helper.getAttributtedString(for: headline ?? "", textOption: textOption.headline(color: textColor).textAttributtes)
            titleTextView.setText(disPlayString)
            indexLabel.attributedText = nil
            
        }else{
            
            indicatorImageView.isHidden = false
            
            let indexAttributtedString = Helper.getAttributtedString(for: "\(index)", textOption: textOption.explainerTitleIndexFont(color: ThemeService.shared.theme.primaryTextColor).textAttributtes)
            
            if let storyElement = element{
                titleTextView.setText(storyElement.displayText)
            }
            
            indexLabel.attributedText = indexAttributtedString
        }
    }
}

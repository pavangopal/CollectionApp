//
//  BlurbElementCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/2/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class BlurbElementCell: BaseCollectionCell {
    
    var textView:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        
        return view
    }()
    
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
 
    override func setUpViews(){
        super.setUpViews()
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        textView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(lineView)
        contentView.addSubview(textView)
        
        textView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left + 5, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        
       lineView.anchor(textView.topAnchor, left: contentView.leftAnchor, bottom: textView.bottomAnchor, right: nil, topConstant: 10, leftConstant: self.margin.Left - 5, bottomConstant: self.margin.Bottom, rightConstant: 0, widthConstant: 3, heightConstant: 0)
        textView.delegate = self
    }
    
    override func configure(data: Any?) {
        guard let storyElement = data as? CardStoryElement else{
            return
        }
        
        lineView.backgroundColor = ThemeService.shared.theme.primarySectionColor
        
        textView.setText(storyElement.displayText)
    }
    
}

//
//  TitleElementCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/8/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class TitleElementCell: BaseCollectionCell {
    
    var titleTextView:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        return view
    }()
    
    override func setUpViews(){
        super.setUpViews()
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        titleTextView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(titleTextView)
        
        titleTextView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        titleTextView.delegate = self
    }
    
    override func configure(data: Any?) {
        guard let storyElement = data as? CardStoryElement else{
            return
        }
        titleTextView.setText(storyElement.displayText)
    }
}

//
//  BlockQuoteCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/2/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class BlockQuoteCell: BaseCollectionCell {
    
    var textView:TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        
        view.setBasicProperties()
        
        return view
    }()

    
    override func setUpViews(){
        super.setUpViews()
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        textView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(textView)
        
        textView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant:0)
        
        textView.delegate = self
    }
    
    override func configure(data: Any?) {
        guard let textElement = data as? CardStoryElement else {
            return
        }
        
        textView.setText(textElement.displayText)
    }
  
}

//
//  AlsoReadCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/10/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


protocol AlsoReadCellDelegate:class {
    func alsoReadElementPressed(storyElement:CardStoryElement)
}

class AlsoReadCell: BaseCollectionCell {
    
    var textView :TTTAttributedLabel = {
        let textView = TTTAttributedLabel(frame: .zero)
        textView.setBasicProperties()
        return textView
    }()
    
    weak var alsoReadDelegate:AlsoReadCellDelegate?
    var storyElement:CardStoryElement?
    
    override func setUpViews(){
        super.setUpViews()
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        textView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(textView)
        
        textView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.textViewTapped))
        textView.addGestureRecognizer(tapGuesture)
        textView.delegate = self
        
    }
    
    @objc func textViewTapped() {
        if let storyElementD = storyElement{
            alsoReadDelegate?.alsoReadElementPressed(storyElement:storyElementD)
        }
    }
    
    override func configure(data: Any?) {
        guard let storyElement = data as? CardStoryElement else{
            return
        }
        self.storyElement = storyElement
        textView.setText(storyElement.displayText)
        
    }
}

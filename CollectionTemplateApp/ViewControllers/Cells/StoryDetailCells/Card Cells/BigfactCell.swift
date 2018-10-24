//
//  BigfactCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/2/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class BigfactCell: BaseCollectionCell {
    
    var textView : TTTAttributedLabel = {
       let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        return view
    }()
    
    var imageView :UIImageView = {
       let view = UIImageView()
        view.backgroundColor = UIColor(hexString: "#333333")
        view.contentMode = .center
        view.image = AssetImage.BigFact.image
        
        return view
    }()
    
    override func setUpViews(){
        super.setUpViews()
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video) ?  UIColor(hexString:"#333333") : .white
        textView.backgroundColor = contentView.backgroundColor
        contentView.addSubview(imageView)
        contentView.addSubview(textView)
        
        imageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        textView.anchor(contentView.topAnchor, left: imageView.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: 8, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        textView.delegate = self
    }
    
    override func configure(data: Any?) {
        guard let cardElement = data as? CardStoryElement else{
            return
        }
        
        textView.setText(cardElement.displayText)
    }
    
}

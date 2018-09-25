//
//  KeyEventCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/8/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class KeyEventCell: BaseCollectionCell {
    
    var timeStampContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString:"#333333")
        return view
    }()
    
    var timeStampLabel:InsetLabel = {
        let label = InsetLabel(frame: .zero)
        label.font = FontService.shared.storyKeyEventFont
        label.insets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        label.textColor = .white
        label.backgroundColor = UIColor(hexString:"#333333")
        return label
    }()
    
    var timeStampIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetImage.KeyEventCircle.image
        return imageView
    }()
    
    var keyEventLabel:InsetLabel = {
        let label = InsetLabel()
        label.font = FontService.shared.storyKeyEventFont
        label.textColor = .white
        label.text = "KEY EVENT"
        label.backgroundColor = UIColor(hexString: "#36E7BC")
        label.insets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        return label
    }()
    
    override func setUpViews(){
        
        
        contentView.addSubview(timeStampContainerView)
        timeStampContainerView.addSubview(timeStampIcon)
        timeStampContainerView.addSubview(timeStampLabel)
        contentView.addSubview(keyEventLabel)
        
        timeStampContainerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: -15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        timeStampIcon.anchor(nil, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: -2.5, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        
        timeStampIcon.anchorCenterYToSuperview()
        
        timeStampLabel.anchor(timeStampContainerView.topAnchor, left: timeStampIcon.rightAnchor, bottom: timeStampContainerView.bottomAnchor, right: timeStampContainerView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        keyEventLabel.anchor(contentView.topAnchor, left: timeStampLabel.rightAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func configure(data: Any?) {
        guard let card = data as? Card else{
            return
        }
        
        timeStampLabel.text = card.card_added_at?.convertTimeStampToDate ?? ""
        let isKeyEvent = card.metadata?.metaAttributes?.key_event ?? false
        
        keyEventLabel.isHidden = !(isKeyEvent)
        
    }
}

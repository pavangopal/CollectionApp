//
//  CollectionTitleCell.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class CollectionTitleCell: BaseCollectionCell {
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F5F5F5")
        return view
    }()
    
    
    var collectionTitleLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = FontService.shared.collectionTitleFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.insets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
//        label.font = FontService.sharedInstance.fonts.headingFont
        return label
    }()
    
    var underLineView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.blue
//        view.backgroundColor = ThemeService.sharedInstance.theme.primaryColor
        return view
    }()
    
    
    override func setupViews() {
        super.setupViews()

        contentView.addSubview(containerView)
        
        contentView.backgroundColor = .white
        
        containerView.addSubview(collectionTitleLabel)
        containerView.addSubview(underLineView)
        
        containerView.fillSuperview()
        
        collectionTitleLabel.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 15, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        contentView.addConstraint(NSLayoutConstraint(item: collectionTitleLabel, attribute: NSLayoutAttribute.trailing, relatedBy: .lessThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -20))
        
        underLineView.anchor(collectionTitleLabel.bottomAnchor, left: collectionTitleLabel.leftAnchor, bottom: nil, right: collectionTitleLabel.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 2)
    }
    
    override func configure(data: Any?,associatedMetaData:AssociatedMetadata?) {
        
        guard let collectionName = data as? String else{
            return
        }
        
        collectionTitleLabel.text = collectionName.capitalized
        
    }
    
}







//
//  MenuCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/28/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class MenuCell: BaseCollectionCell {
    
    var menuTitleLabel: InsetLabel = {
        let label = InsetLabel()
        label.insets = UIEdgeInsets(top: 8, left: 8, bottom: 10, right: 8)
        label.textAlignment = .center
        label.textColor = .white
        label.font = FontService.shared.getCorrectedFont(fontName: FontFamilyName.OswaldRegular.rawValue, size: 26)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var imageViewIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let backGroundView = UIView()
    
    var menu:Menu!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = ThemeService.shared.theme.primarySectionColor
        self.contentView.addSubview(imageViewIcon)
        self.contentView.addSubview(menuTitleLabel)
        
        menuTitleLabel.fillSuperview()
        
        imageViewIcon.anchorCenterSuperview()
        imageViewIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuTitleLabel.textColor = .white
        imageViewIcon.isHighlighted = false
    }
}


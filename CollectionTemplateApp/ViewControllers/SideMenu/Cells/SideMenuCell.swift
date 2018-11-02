//
//  SideMenuCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/21/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class SideMenuCell: UITableViewCell {

    var menuTitleLabel: InsetLabel = {
       let label = InsetLabel()
        label.insets = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 8)
        label.textAlignment = .left
        label.textColor = ThemeService.shared.theme.primaryTextColor
        label.font = FontService.shared.getCorrectedFont(fontName: FontFamilyName.OswaldRegular.rawValue, size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var imageViewIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let backGroundView = UIView()
    
    var menu:Menu!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        separatorInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)
        contentView.backgroundColor = .white
        contentView.addSubview(imageViewIcon)
        contentView.addSubview(menuTitleLabel)
        
        menuTitleLabel.fillSuperview()
        
        imageViewIcon.anchorCenterSuperview()
       imageViewIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(menu:Menu) {
        self.menu = menu
        
        if let colorD = self.menu.data?.color {
            backGroundView.backgroundColor = UIColor(hexString: colorD)
        }else{
            backGroundView.backgroundColor = ThemeService.shared.theme.primarySectionColor
        }

        self.selectedBackgroundView = backGroundView
        
        self.menuTitleLabel.text = menu.title?.uppercased()
        
    }
    

}





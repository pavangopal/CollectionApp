//
//  ParentMenuCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/29/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol ParentMenuCellDelegate:class{
    func shouldToggle(headerView:ParentMenuCell,sectionIndex:Int)
    
}

class ParentMenuCell: UITableViewCell {
    
    var menuTitleLabel: InsetLabel = {
        let label = InsetLabel()
        label.insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        label.textColor = ThemeService.shared.theme.primaryTextColor
        label.font = FontService.shared.getCorrectedFont(fontName: FontFamilyName.OswaldRegular.rawValue, size: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var arrowButton:UIButton = {
        let button = UIButton()
        let image = AssetImage.upArrow.image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = ThemeService.shared.theme.primaryTextColor
        
        return button
    }()
    
    weak var delegate:ParentMenuCellDelegate?
    var menu: SideMenuViewModel?
    var section:Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(menuTitleLabel)
        contentView.addSubview(arrowButton)
        
        menuTitleLabel.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        arrowButton.anchor(nil, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        arrowButton.anchorCenterYToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(menu:SideMenuViewModel?,sectionIndex:Int) {
        
        guard let menu = menu else{return}
        self.menu = menu
        self.menuTitleLabel.text = menu.parentMenu?.title?.uppercased()
        
        arrowButton.isHidden = menu.subMenus.count <= 0
        self.section = sectionIndex
        arrowButton.rotate(menu.isCollapsed ? 0.0 : .pi)
        arrowButton.addTarget(self, action: #selector(shouldToggle(_:)), for: .touchUpInside)
       
    }
    
    
    @objc func shouldToggle(_ sender:UIButton){
        delegate?.shouldToggle(headerView: self, sectionIndex:self.section)
    }

    
    func setCollapsed(collapsed: Bool) {
        arrowButton.rotate(collapsed ? 0.0 : .pi)
    }
}

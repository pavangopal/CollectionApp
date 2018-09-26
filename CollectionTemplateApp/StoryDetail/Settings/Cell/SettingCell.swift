//
//  SettingCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/13/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import UserNotifications

class SettingCell: UITableViewCell {
    
    var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = ThemeService.shared.theme.primaryTextColor
        label.font = FontService.shared.storyTextElementFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var itemSubTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = ThemeService.shared.theme.primaryTextColor
        label.font = FontService.shared.searchScreenAuthorTimeStampFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
   
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(itemTitleLabel)
        self.contentView.addSubview(itemSubTitleLabel)
        
        itemTitleLabel.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
//        itemTitleLabel.setContentHuggingPriority(.required, for: .vertical)
        itemSubTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        itemSubTitleLabel.anchor(itemTitleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 2, leftConstant: 15, bottomConstant: 5, rightConstant: 15, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(settingItem:SettingsItem) {
        
        itemTitleLabel.text = settingItem.displayString
        itemSubTitleLabel.text = settingItem.subTitleString
        
        
        switch settingItem {
        case .Notification:
            
            if !UIApplication.shared.isRegisteredForRemoteNotifications{
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (setting) in
                    DispatchQueue.main.async {
                        if setting.authorizationStatus != .denied{
                            self.accessoryType = .checkmark
                        }else{
                            self.accessoryType = .disclosureIndicator
                        }
                    }
                    
                })
            }else{
                self.accessoryType = .checkmark
            }
            
        case .High:
            
            if ThemeService.shared.imageQuality == .High{
                self.accessoryType = .checkmark
            }else{
             self.accessoryType = .none
            }
            
        case .Medium:
            
            if ThemeService.shared.imageQuality == .Medium{
                self.accessoryType = .checkmark
            }else{
                self.accessoryType = .none
            }
            
        case .Low:
            
            if ThemeService.shared.imageQuality == .Low{
                self.accessoryType = .checkmark
            }else{
                self.accessoryType = .none
            }
            
        case .Version:
            
            self.accessoryType = .none
            
            
        default:
            self.accessoryType = .disclosureIndicator
        }
    }
    
}

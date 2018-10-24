//
//  DashboardCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/9/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit

class DashboardCell: BaseCollectionCell {
    
    var label:UILabel = {
       let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    

    override func setUpViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(label)
        label.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)

    }
    
    
    override func configure(data: Any?) {
        
    }

    
}

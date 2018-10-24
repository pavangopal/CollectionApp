//
//  SearchCountCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/12/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit

class SearchCountCell: BaseCollectionCell {

    var countLabel:UILabel = {
       let label = UILabel()
        label.font = FontService.shared.alsoReadElementFont
        return label
    }()
    
    override func setUpViews() {
        contentView.addSubview(countLabel)
        countLabel.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override func configure(data: Any?) {
        guard let count = data as? NSNumber else {
            return
        }
        
        countLabel.text = "\(count.intValue) results found"
    }

}

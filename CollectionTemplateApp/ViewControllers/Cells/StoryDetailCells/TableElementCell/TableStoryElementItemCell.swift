//
//  TableStoryElementItemCell.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 20/06/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit

class TableStoryElementItemCell: UICollectionViewCell {
    var data:Any!
    var hasPerformedConstraints:Bool = false
    var displayLabel:UILabel = {
        let dLabel = UILabel.init()
        dLabel.translatesAutoresizingMaskIntoConstraints = false
        dLabel.numberOfLines = 0
        dLabel.font = UIFont.systemFont(ofSize: 12)
        return dLabel
    }()
    
    override func updateConstraints() {
        if !hasPerformedConstraints{
        
            createConstraints()
            hasPerformedConstraints = !hasPerformedConstraints
        }
        super.updateConstraints()
    }
    
    func createConstraints(){
        self.contentView.addSubview(displayLabel)
        displayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        displayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        displayLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        displayLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
    }
    
    func configure(inputData:Any){
        self.data = inputData
        self.displayLabel.text = inputData as? String
    }
}

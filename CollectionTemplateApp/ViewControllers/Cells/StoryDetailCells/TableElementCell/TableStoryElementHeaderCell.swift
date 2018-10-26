//
//  TableStoryElementHeaderCell.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 21/06/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit

class TableStoryElementHeaderCell: UICollectionViewCell {
    var data:Any!
    var hasPerformedConstraints:Bool = false
    var displayLabel:UILabel = {
        let dLabel = UILabel.init()
        dLabel.translatesAutoresizingMaskIntoConstraints = false
        dLabel.numberOfLines = 5
        dLabel.textAlignment = .center
        dLabel.font = UIFont.boldSystemFont(ofSize: 12)
        return dLabel
    }()
    
    var horizontalLine:UIView = {
     let view = UIView()
        return view
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
        self.contentView.addSubview(horizontalLine)
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

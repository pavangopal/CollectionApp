//
//  StoryCardsSorterCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/8/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit

enum SortingOrder{
    case New
    case Old
}

protocol StoryCardsSorterCellDelegate:class {
    func sortElements(order:SortingOrder)
}

class StoryCardsSorterCell: BaseCollectionCell {
    
    
    var newestButton:UIButton = {
        let button = UIButton()
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.masksToBounds = false
        
        button.setTitle("NEWEST FIRST", for: .normal)
        button.titleLabel?.font = FontService.shared.sorterElementFont
        return button
    }()
    
    var oldestButton:UIButton = {
        let button = UIButton()
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.masksToBounds = false
        
        button.setTitle("OLDEST FIRST", for: .normal)
        button.titleLabel?.font = FontService.shared.sorterElementFont
        return button
    }()
    
    weak var sortingDelegate: StoryCardsSorterCellDelegate?
    
    override func setUpViews(){
    
        //        contentView.backgroundColor = .white
        
        contentView.addSubview(newestButton)
        contentView.addSubview(oldestButton)
        
        newestButton.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 20, leftConstant: 16, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        oldestButton.anchor(contentView.topAnchor, left: newestButton.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 20, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        
        contentView.addConstraint(NSLayoutConstraint(item: oldestButton, attribute: .width, relatedBy: .equal, toItem: newestButton, attribute: .width, multiplier: 1, constant: 0))
        
        newestButton.addTarget(self, action: #selector(self.newestButtonPressed(sender:)), for: .touchUpInside)
        oldestButton.addTarget(self, action: #selector(self.oldestButtonPressed(sender:)), for: .touchUpInside)
        
        updateButtonUI(for: .New)
    }
    
    override func configure(data: Any?) {
        guard let selectedOrder = data as? SortingOrder else{
            return
        }
        
        self.updateButtonUI(for: selectedOrder)
    }
    
    @objc func newestButtonPressed(sender:UIButton){
        self.updateButtonUI(for: .New)
        self.sortingDelegate?.sortElements(order: .New)
        
    }
    
    @objc func oldestButtonPressed(sender:UIButton){
        
        self.updateButtonUI(for: .Old)
        self.sortingDelegate?.sortElements(order: .Old)
        
    }
    
    func updateButtonUI(`for` selectedOrder:SortingOrder){
        switch selectedOrder {
            
        case .New:
            
            newestButton.backgroundColor = UIColor(hexString: "#7C17B0")
            oldestButton.backgroundColor = UIColor(hexString: "#FFFFFF")
            
            newestButton.setTitleColor(.white, for: .normal)
            oldestButton.setTitleColor(UIColor(hexString:"#555555"), for: .normal)
            
        case .Old:
            
            newestButton.backgroundColor = UIColor(hexString: "#FFFFFF")
            oldestButton.backgroundColor = UIColor(hexString: "#7C17B0")
            
            newestButton.setTitleColor(UIColor(hexString:"#555555"), for: .normal)
            oldestButton.setTitleColor(.white, for: .normal)
        }
    }
    
}


//
//  TableStoryElementTopHeaderCell.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 21/06/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit

class TableStoryElementTopHeaderCell: UICollectionViewCell {
    var hasPerformedLayout:Bool = false
    var prevButton:UIButton = {
        let prevBtn = UIButton.init(type: .custom)
        prevBtn.setTitle("Pre", for: .normal)
        
//        prevBtn.imageView?.contentMode = .scaleAspectFit
//        prevBtn.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        prevBtn.translatesAutoresizingMaskIntoConstraints = false
        prevBtn.backgroundColor = UIColor.blue
        return prevBtn
    }()
    
    var searchTF:UITextField = {
        let searchField = UITextField.init()
        searchField.borderStyle = .roundedRect
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        searchField.placeholder = "Search"
        return searchField
    }()
    
    var nextButton:UIButton = {
        let nextBtn = UIButton.init(type: .custom)
        nextBtn.setTitle("Next", for: .normal)
//        nextBtn.imageView?.contentMode = .scaleAspectFit
//        nextBtn.setImage(#imageLiteral(resourceName: "forwardArrow"), for: .normal)
        
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.backgroundColor = UIColor.blue
        return nextBtn
    }()
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let viewBelongNextBtn = self.nextButton.hitTest(self.nextButton.convert(point, from: self), with: event){
            return viewBelongNextBtn
        }
        else if let viewBelongToPrevBtn = self.prevButton.hitTest(self.prevButton.convert(point, from: self), with: event){
            return viewBelongToPrevBtn
        }
        else if let viewBelongTF = self.searchTF.hitTest(self.searchTF.convert(point, from: self), with: event){
            return viewBelongTF
        }
        
        return super.hitTest(point, with: event)
    }
    
    override func updateConstraints() {
        if !hasPerformedLayout{
            hasPerformedLayout = !hasPerformedLayout
            createConstraints()
        }
        super.updateConstraints()
    }
    
    func createConstraints(){
        self.contentView.addSubview(self.prevButton)
        self.contentView.addSubview(self.nextButton)
        self.contentView.addSubview(self.searchTF)
        
        prevButton.anchor(self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 40, heightConstant: 0)
        
        searchTF.anchor(contentView.topAnchor, left: prevButton.rightAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        nextButton.anchor(self.contentView.topAnchor, left: searchTF.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 40, heightConstant: 0)
       
    }
}



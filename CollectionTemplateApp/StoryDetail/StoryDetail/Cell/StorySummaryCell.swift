//
//  StorySnapshotCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/30/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class StorySummaryCell: BaseCollectionCell {
    
    var snapShotHeaderView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FDBE2D")
        return view
    }()
    
    var snapShotTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Snapshot"
        return label
    }()
    
    var dropDownButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#333333")
        button.setImage(AssetImage.crossIcon.image, for: .normal)
        

        return button
    }()
    
    var textView: TTTAttributedLabel = {
        let view = TTTAttributedLabel(frame: .zero)
        view.setBasicProperties()
        return view
    }()

    var indexPath:IndexPath?
   
    override func setUpViews(){
        super.setUpViews()
        
        contentView.backgroundColor = .white
        textView.backgroundColor = contentView.backgroundColor
        
        contentView.addSubview(snapShotHeaderView)
        snapShotHeaderView.addSubview(snapShotTitleLabel)
        
        contentView.addSubview(dropDownButton)
        contentView.addSubview(textView)
        
        snapShotHeaderView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 34)
        
        snapShotTitleLabel.anchor(contentView.topAnchor, left: snapShotHeaderView.leftAnchor, bottom: snapShotHeaderView.bottomAnchor, right: snapShotHeaderView.rightAnchor, topConstant: 0, leftConstant: 35, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        dropDownButton.anchor(snapShotHeaderView.topAnchor, left: snapShotHeaderView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: -5, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        textView.anchor(snapShotHeaderView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        textView.delegate = self
    }
    
    override func configure(data: Any?) {
        
        if let unwrappedIndexpath = indexPath{
            self.dottedLineView.isHidden = (unwrappedIndexpath.section == 1) //Dont show the dotted line for First section summary element
        }
        
        guard let storyElement = data as? CardStoryElement else{
            return
        }
        
        textView.setText(storyElement.displayText)
    }
}






//

//  SimpleSliderCell.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class SimpleSliderCell: BaseCollectionCell {
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var collectionTitleLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.font = FontService.shared.collectionTitleFont
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines  = 1
        label.lineBreakMode = .byTruncatingTail
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    var storyHeadlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.setProperties()
        label.font = FontService.shared.homeHeadlineRegular
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    var readStoryButton:UIButton = {
       let button = UIButton()
        button.titleLabel?.font = FontService.shared.getCorrectedFont(fontName: FontFamilyName.LatoRegular.rawValue, size: 18.0)
        
        button.setTitle("READ STORY", for: .normal)
        button.clipsToBounds = true
        button.cornerRadius = 25
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    var coverView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#0e316c")
        view.alpha = 0.6
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        readStoryButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        readStoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let stackView = UIStackView(arrangedSubviews: [collectionTitleLabel,storyHeadlineLabel,readStoryButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(imageView)
        contentView.addSubview(coverView)
        contentView.addSubview(stackView)
        
        imageView.fillSuperview()
        coverView.fillSuperview()
        
        stackView.anchorCenterXToSuperview()
        stackView.anchorCenterYToSuperview()
        stackView.anchor(nil, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        
        let topConstraint = NSLayoutConstraint.init(item: stackView, attribute: .top, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: contentView, attribute: .top, multiplier: 1, constant: 20)
        contentView.addConstraint(topConstraint)
        let bottomConstraint = NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: -20)
        contentView.addConstraint(bottomConstraint)
        
        readStoryButton.addTarget(self, action: #selector(self.readStoryButtonPressed), for: .touchUpInside)
    }
    
    override func configure(data: Any?,associatedMetaData:AssociatedMetadata?) {
        
        guard let collectionTitleStoryTuple = data as? (String?,StoryViewModel?),let collectionName = collectionTitleStoryTuple.0,let story = collectionTitleStoryTuple.1 else{return}
        
        collectionTitleLabel.text = collectionName
        
        imageView.loadImageFromUrl(url: story.imageURl)
        storyHeadlineLabel.attributedText = story.headline
        
        
    }
    
    @objc func readStoryButtonPressed(){
        print(#function)
    }
    
    
    
    
    
}

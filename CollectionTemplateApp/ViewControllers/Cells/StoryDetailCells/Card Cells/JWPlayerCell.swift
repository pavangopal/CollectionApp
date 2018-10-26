//
//  JWPlayerCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/1/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher

class JWPlayerCell: BaseCollectionCell {
    
    var thumbnailImageView:UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled  = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    var playIcon:UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled  = false

        view.image = AssetImage.PlayCircle.image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func setUpViews(){
        super.setUpViews()
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(playIcon)
        playIcon.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        
        let storyTemplet = self.margin.storyTemplet
        let leftInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 5 : 0
        let rightInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 10 : 0
        
        thumbnailImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: leftInset, bottomConstant: self.margin.Bottom, rightConstant: rightInset, widthConstant: 0, heightConstant: 0)
        playIcon.anchorCenterSuperview()
        
    }
    
    override func configure(data: Any?) {
        super.configure(data: data)
        
        let card = data as? CardStoryElement
        
        if let imageString = card?.metadata?.thumbnail_url,let imageURL = URL(string:"http:\(imageString)"){
            self.thumbnailImageView.kf.setImage(with: imageURL)
        }
        
    }
    
    
}

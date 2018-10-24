//
//  RatingCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/7/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class RatingCell: BaseCollectionCell {
    
    var ratingView:FloatRatingView = {
        let view = FloatRatingView()
        view.clipsToBounds = true
        view.maxRating = 5
        view.minRating = 0
        view.fullImage = AssetImage.FullStarRating.image
        view.emptyImage = AssetImage.EmptyStarRating.image
        view.editable = false
        view.type = FloatRatingView.FloatRatingViewType.halfRatings
        return view
    }()
    
    override func setUpViews(){
        super.setUpViews()
        contentView.backgroundColor = .white
        
        contentView.addSubview(ratingView)
        
        ratingView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: self.margin.Left, bottomConstant: 0, rightConstant: 0, widthConstant: (UIScreen.main.bounds.width/2) - 50, heightConstant: 25)
        
        
    }
    
    
    override func configure(data: Any?) {
        guard let story = data as? Story else{
            return
        }
        
        ratingView.rating = story.storyMetadata?.review_rating?.value ?? 0.0
    }
}

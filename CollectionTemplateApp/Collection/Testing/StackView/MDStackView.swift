//
//  MDStackView.swift
//  MediaOne
//
//  Created by Pavan Gopal on 8/9/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

class MDStackView : UIStackView {
    
    let authorNameLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
//        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
//        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
//        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        label.setProperties()
//        label.isHidden = true
        return label
    }()
    
    let publishTimeLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
//        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setProperties()
        label.isHidden = true
        return label
    }()
    
    let authorImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .green
        imageView.isHidden = true
        return imageView
    }()
    
    let sectionNameLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.backgroundColor = .black
        label.textColor = .white

//        label.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
//        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
//        label.insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isHidden = true
        return label
    }()
    
    let sectionUnderLineView:UIView = {
        let view = UIView()
//        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var headlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
//        label.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()
    
    var subHeadlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
//        label.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()
    
    var ratingView:FloatRatingView = {
        let ratingView = FloatRatingView()
        ratingView.isHidden = true
        ratingView.clipsToBounds = true
        ratingView.maxRating = 5
        ratingView.minRating = 0
        ratingView.fullImage = AssetImage.FullStarRating.image
        ratingView.emptyImage = AssetImage.EmptyStarRating.image
        ratingView.editable = false
        ratingView.type = FloatRatingView.FloatRatingViewType.halfRatings
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(metaData:AssociatedMetadata?) {
        self.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fill
        self.spacing = 10
        
        guard let metaDataD = metaData else{
            createDefaultStackView()
            return
        }
        
        createStackView(for: metaDataD)
    }
    
    private func createStackView(`for` metaData:AssociatedMetadata){
        
        if metaData.show_section_tag{
            self.addArrangedSubview(createSectionStackView(metaData: metaData))
        }else{
//            sectionNameLabel.isHidden = true
            sectionUnderLineView.isHidden = true
        }
        
        self.addArrangedSubview(headlineLabel)
        headlineLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        headlineLabel.isHidden = false
        //        self.addArrangedSubview(subHeadlineLabel)
        //        subHeadlineLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addArrangedSubview(ratingView)
        
        let heightConstraint = ratingView.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        heightConstraint.isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 125).isActive = true

        createAuthorStackView(metaData: metaData)
    }
    
    private func createDefaultStackView(){
        
        self.addArrangedSubview(createSectionStackView(metaData: AssociatedMetadata()))
        self.addArrangedSubview(headlineLabel)
        headlineLabel.isHidden = false
        headlineLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        //        self.addArrangedSubview(subHeadlineLabel)
        //        subHeadlineLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        self.addArrangedSubview(ratingView)
        
        let heightConstraint = ratingView.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        heightConstraint.isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        createAuthorStackView(metaData: AssociatedMetadata())
    }
    
    private func createSectionStackView(metaData:AssociatedMetadata) -> UIStackView {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2
        
//        sectionNameLabel.isHidden = false
        sectionUnderLineView.isHidden = false
        
//        sectionNameLabel.insets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        stackView.addArrangedSubview(sectionNameLabel)
        sectionUnderLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        stackView.addArrangedSubview(sectionUnderLineView)
        
        return stackView
    }
    
    
    private func createAuthorStackView(metaData:AssociatedMetadata) {
        
        let authorStackView = UIStackView()
        authorStackView.axis = .horizontal
        authorStackView.alignment = .top
        authorStackView.distribution = .fill
        authorStackView.spacing = 10
        
        let labelStackView = UIStackView()
        labelStackView.alignment = .leading
        labelStackView.axis = .horizontal
        labelStackView.spacing = 5
        labelStackView.distribution = .fill
        
        
        if metaData.show_author_name {
            
            authorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            let heightConstraint = authorImageView.heightAnchor.constraint(equalToConstant: 50)
            heightConstraint.priority = UILayoutPriority.defaultHigh
            heightConstraint.isActive = true
            
            authorStackView.addArrangedSubview(authorImageView)
            labelStackView.addArrangedSubview(authorNameLabel)
//            authorImageView.isHidden = false
//            authorNameLabel.isHidden = false
        }else{
//            authorNameLabel.isHidden = true
            authorImageView.isHidden = true
        }
        
        if metaData.show_time_of_publish{
            publishTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
            labelStackView.addArrangedSubview(publishTimeLabel)
//            publishTimeLabel.isHidden = false
        }else{
            print("hide publishTimeLabel")
//            publishTimeLabel.isHidden = true
        }
        
        authorStackView.addArrangedSubview(labelStackView)
        self.addArrangedSubview(authorStackView)
        
        authorStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func createAuthorStackView(metaData:AssociatedMetadata,axis:UILayoutConstraintAxis) {
        
        let authorStackView = UIStackView()
        authorStackView.axis = axis
        authorStackView.alignment = .top
        authorStackView.distribution = .fill
        authorStackView.spacing = 5
        
        let labelStackView = UIStackView()
        labelStackView.alignment = .center
        labelStackView.axis = .horizontal
        labelStackView.spacing = 5
        labelStackView.distribution = .fill
        
        if metaData.show_author_name {
            
            authorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            let heightConstraint = authorImageView.heightAnchor.constraint(equalToConstant: 50)
            heightConstraint.priority = UILayoutPriority.defaultHigh
            heightConstraint.isActive = true
            
            authorStackView.addArrangedSubview(authorImageView)
            labelStackView.addArrangedSubview(authorNameLabel)
            //            authorImageView.isHidden = false
//            authorNameLabel.isHidden = false
        }else{
//            authorNameLabel.isHidden = true
            authorImageView.isHidden = true
        }
        
        if metaData.show_time_of_publish{
            publishTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
            labelStackView.addArrangedSubview(publishTimeLabel)
//            publishTimeLabel.isHidden = false
        }else{
            print("hide publishTimeLabel")
//            publishTimeLabel.isHidden = true
        }
        
        authorStackView.addArrangedSubview(labelStackView)
        self.addArrangedSubview(authorStackView)
        
        authorStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    }
  
}















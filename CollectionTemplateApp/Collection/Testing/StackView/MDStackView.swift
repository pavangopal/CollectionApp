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
        label.font = FontService.shared.homeAuthorFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setProperties()
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        return label
    }()
    
    let publishTimeLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.font = FontService.shared.homeTimestampFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setProperties()
        label.isHidden = true
        return label
    }()
    
    let authorImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    let sectionNameLabel:InsetLabel = {
        let label = InsetLabel(frame: .zero)
        label.font = FontService.shared.homeSectionFont
        label.insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.backgroundColor = .black
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sectionUnderLineView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var headlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.font = FontService.shared.homeHeadlineRegular
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()
    
    var subHeadlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.font = FontService.shared.homeSubHeadlineRegular
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
    
    convenience init() {
        self.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fill
        self.spacing = 10
        
        createStackView()
    }
    
    private func createStackView(){
        //#1
        let sectionStackView = createSectionStackView()
        self.addArrangedSubview(sectionStackView)
        //#2
        self.addArrangedSubview(headlineLabel)
        headlineLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        headlineLabel.isHidden = false
        
        self.addArrangedSubview(subHeadlineLabel)
        subHeadlineLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        //#3
        self.addArrangedSubview(ratingView)
        
        let heightConstraint = ratingView.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        heightConstraint.isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        let authorStackView = createAuthorStackView()
        //#4
        self.addArrangedSubview(authorStackView)
        
        authorStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    }

    private func createSectionStackView() -> UIStackView {
        
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
    
    
    private func createAuthorStackView() -> UIStackView {
        
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
        
        authorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        let heightConstraint = authorImageView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        heightConstraint.isActive = true
        
        authorStackView.addArrangedSubview(authorImageView)
        labelStackView.addArrangedSubview(authorNameLabel)
        
        
        publishTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        labelStackView.addArrangedSubview(publishTimeLabel)
        
        authorStackView.addArrangedSubview(labelStackView)
//        self.addArrangedSubview(authorStackView)
        
        return authorStackView
    }
    
    func updateViewFor(associatedMetaData:AssociatedMetadata?) {
        guard let associatedMetaData = associatedMetaData else{return}
        
        if associatedMetaData.show_author_name{
            self.authorNameLabel.isHidden = false
            self.authorImageView.isHidden = true
        }else{
            self.authorNameLabel.isHidden = true
            self.authorImageView.isHidden = true
        }
        
        if associatedMetaData.show_time_of_publish{
            self.publishTimeLabel.isHidden = false
            self.publishTimeLabel.isHidden = false
        }else{
            self.publishTimeLabel.isHidden = true
            self.publishTimeLabel.isHidden = true
        }
        
        if associatedMetaData.show_section_tag{
            self.sectionNameLabel.isHidden = false
            self.sectionNameLabel.isHidden = false
            self.sectionUnderLineView.isHidden = false
        }else{
            self.sectionNameLabel.isHidden = true
            self.sectionNameLabel.isHidden = true
            self.sectionUnderLineView.isHidden = true
        }
    }
}















//
//  AuthorStackView.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/26/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

class AuthorStackView:UIStackView{
    
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
        return label
    }()
    
    let authorImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        createAuthorStackView()
        
    }
    
    private func createAuthorStackView() {
        
        axis = .horizontal
        alignment = .top
        distribution = .fill
        spacing = 5
        
        let labelStackView = UIStackView()
        labelStackView.alignment = .leading
        labelStackView.axis = .vertical
        labelStackView.spacing = 2
        labelStackView.distribution = .fill
        
        authorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        let heightConstraint = authorImageView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        heightConstraint.isActive = true
        
        addArrangedSubview(authorImageView)
        labelStackView.addArrangedSubview(authorNameLabel)
        
        
        publishTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        labelStackView.addArrangedSubview(publishTimeLabel)
        
        addArrangedSubview(labelStackView)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


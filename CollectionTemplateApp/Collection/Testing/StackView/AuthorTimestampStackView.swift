//
//  AuthorTimestampStackView.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

class AuthorTimestampStackView : UIStackView {
    
    var authorNameLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        label.setProperties()
        label.isHidden = true
        return label
    }()
    
    var timestampLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setProperties()
        label.isHidden = true
        return label
    }()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(axis:UILayoutConstraintAxis,alignment:UIStackViewAlignment,distribution:UIStackViewDistribution, spacing:CGFloat ) {
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        
        self.addArrangedSubview(authorNameLabel)
        self.addArrangedSubview(timestampLabel)
//        authorStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    }
    
    
    
}

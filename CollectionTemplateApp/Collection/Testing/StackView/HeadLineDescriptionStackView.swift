//
//  HeadLineDescriptionStackView.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

class HeadLineDescriptionStackView : UIStackView {
    
    var headlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.setProperties()
        
        return label
    }()
    
    var descriptionLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.setProperties()
        
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
        
        self.addArrangedSubview(headlineLabel)
        self.addArrangedSubview(descriptionLabel)
    }
    
    
    
}

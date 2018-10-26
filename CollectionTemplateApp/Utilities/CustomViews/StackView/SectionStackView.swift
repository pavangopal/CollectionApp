//
//  SectionStackView.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/26/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

class SectionStackView:UIStackView {
    
    let sectionNameLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.setProperties()
        return label
    }()
    
    let sectionUnderLineView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeService.shared.theme.primarySectionColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 2
        
        addArrangedSubview(sectionNameLabel)
        addArrangedSubview(sectionUnderLineView)
        let heightConstraint = sectionUnderLineView.heightAnchor.constraint(equalToConstant: 2)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        heightConstraint.isActive = true
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




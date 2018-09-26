//
//  HeadlineSubHealineStackView.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/26/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

class HeadlineSubHealineStackView:UIStackView {
    
    var headlineLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.setProperties()
        return label
    }()
    
    var subheadlinelLabel:TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.setProperties()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(headlineLabel)
        addArrangedSubview(subheadlinelLabel)
        distribution = .fill
        axis = .vertical
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData(headline:NSAttributedString,subheadline:NSAttributedString){
        headlineLabel.attributedText = headline
        subheadlinelLabel.attributedText = subheadline
    }
}

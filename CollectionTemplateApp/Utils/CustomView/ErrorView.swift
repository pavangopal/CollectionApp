//
//  ErrorView.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol ErrorViewDelegate:class {
    func reTryRequested()
}

class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?
    
    var errorLabel:UILabel = {
        let label = UILabel()
        label.textColor = ThemeService.shared.theme.primaryTextColor.withAlphaComponent(0.9)
        label.font = FontService.shared.errorMessageFont
        label.textAlignment = .center
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var retryButton : UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = FontService.shared.errorMessageFont
        button.setTitleColor(ThemeService.shared.theme.primaryTextColor, for: .normal)
        button.layer.borderColor = ThemeService.shared.theme.primaryTextColor.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 1
        button.cornerRadius = 5
        
        return  button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        
        
        addSubview(errorLabel)
        addSubview(retryButton)
        
        errorLabel.anchor(nil, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        errorLabel.anchorCenterSuperview()
        
        retryButton.anchor(errorLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 30)
        retryButton.anchorCenterXToSuperview()
        retryButton.addTarget(self, action: #selector(retryButtonPressed), for: .touchUpInside)
    }
    
    @objc func retryButtonPressed(){
        delegate?.reTryRequested()
    }
    
    func displayErrorMessage(message:String) {
        
        switch message {
        case Constants.HttpError.pageNotFound,Constants.HttpError.noInternetConnection :
            self.errorLabel.text = message
            break
        default:
            self.errorLabel.text = Constants.HttpError.pageNotFound
            break
        }
        
        
        
    }
    
}

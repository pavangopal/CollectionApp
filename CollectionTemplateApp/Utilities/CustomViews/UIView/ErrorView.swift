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
        button.setImage(AssetImage.retry.image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
        clipsToBounds = true
        backgroundColor = .red
        addSubview(errorLabel)
        addSubview(retryButton)
        
        errorLabel.anchor(topAnchor, left: leftAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        retryButton.anchor(nil, left: errorLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 48, heightConstant: 48)
        retryButton.anchorCenterYToSuperview()
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

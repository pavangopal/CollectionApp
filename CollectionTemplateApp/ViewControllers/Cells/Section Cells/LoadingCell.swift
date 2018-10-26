//
//  LoadingCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 3/16/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit

class LoadingCell: BaseCollectionCell {
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        activityIndicatorView.clipsToBounds = true
        activityIndicatorView.color = UIColor.lightGray
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
        activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAcitvityIndicator(){
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator(){
        activityIndicatorView.stopAnimating()
    }
    
    
    
}

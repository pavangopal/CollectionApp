//
//  NavigationExtension.swift
//  CoreApp-iOS
//
//  Created by Albin CR on 2/20/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}


extension UIViewController {
    func addViewController (anyController: AnyObject) {
        if let viewController = anyController as? UIViewController {
            addChildViewController(viewController)
            view.addSubview(viewController.view)
            viewController.view.fillSuperview()
//            viewController.view.anchor(self.view.safeAreaLayoutGuide.topAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            viewController.didMove(toParentViewController: self)
        }
    }
    
    func removeViewController (anyController: AnyObject) {
        if let viewController = anyController as? UIViewController {
            viewController.willMove(toParentViewController: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
    }
}

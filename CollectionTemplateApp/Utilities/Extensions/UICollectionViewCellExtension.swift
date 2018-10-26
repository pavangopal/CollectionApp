//
//  UICollectionViewCellExtension.swift
//  MediaOne
//
//  Created by Pavan Gopal on 8/7/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func setBackgroundView(){
        let imageView = UIImageView()
        imageView.image = AssetImage.BackgroundImage.image
        self.backgroundView = imageView
    }
}

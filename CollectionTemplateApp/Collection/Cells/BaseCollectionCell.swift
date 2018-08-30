//
//  BaseCollectionCell.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 1/9/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Quintype

class BaseCollectionCell: UICollectionViewCell {
    
    let defaultPadding:CGFloat = 15
    let screenWidth = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30).isActive = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var associatedMetaData: AssociatedMetadata?
//
//
//    lazy var completion = { [weak self](associatedMetaData:AssociatedMetadata?) in
//        guard let selfD = self else {
//            return
//        }
//
//        //early exit
//        if let marD = selfD.associatedMetaData{
//            selfD.associatedMetaData = associatedMetaData
//            return
//        }
//
//        selfD.associatedMetaData = associatedMetaData
//        selfD.setUpWithAssociatedMetaData(associatedMetaData: associatedMetaData)
//    }
    
//    func setUpWithAssociatedMetaData(associatedMetaData:AssociatedMetadata?){
////        self.setBackgroundView()
//    }
    
    func configure(data:Any?){
        
    }
    
    func configure(data:Any?,indexPath:IndexPath,status:Bool){
        
    }
    func configureAndReturnHeight(data:Any?,indexPath:IndexPath,status:Bool,targetSize:CGSize) -> CGSize{
        
        return CGSize(width: 1, height: 1)
    }
    
    func calculateHeight(targetSize:CGSize) -> CGSize {
        
        var newSize = targetSize
        newSize.width = targetSize.width
        
        let widthConstraint = NSLayoutConstraint(item: self.contentView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant:newSize.width)
        
        contentView.addConstraint(widthConstraint)
        var size = UILayoutFittingCompressedSize
        size.width = newSize.width
        
        let cellSize = self.contentView.systemLayoutSizeFitting(size, withHorizontalFittingPriority: UILayoutPriority(rawValue: 1000), verticalFittingPriority:UILayoutPriority(rawValue: 1))
        contentView.removeConstraint(widthConstraint)
        
        return cellSize
        
    }
    
    public func setupViews(){
        self.setBackgroundView()
    }
    
    public func didEndDisplay(){
        
    }
}

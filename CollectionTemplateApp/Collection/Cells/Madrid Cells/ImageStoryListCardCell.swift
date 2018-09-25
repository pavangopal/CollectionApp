//
//  ImageStoryListswift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ImageStoryListCardCell: BaseCollectionCell {
    
    var containerView:UIView = {
       let view = UIView()
        return view
    }()
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var stackView : MDStackView!
    
    
    override func setupViews() {
        super.setupViews()
        
        contentView.clipsToBounds = true
        
        stackView = MDStackView()

        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(imageView)
        
        containerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 175, heightConstant: 131)
        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.bottom, relatedBy: .greaterThanOrEqual, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        self.contentView.addConstraint(bottomConstraint)
        
        stackView.anchor(containerView.topAnchor, left: imageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0 )
        
        let stackViewbottomConstraint = NSLayoutConstraint.init(item: containerView, attribute: .bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraint(stackViewbottomConstraint)
    }
    
    override func configure(data:Any?,associatedMetaData:AssociatedMetadata?){
        guard let storyViewModel = data as? StoryViewModel else{
            return
        }
        
        imageView.loadImageFromUrl(url: storyViewModel.imageURl)
        
        stackView.config(storyViewModel: storyViewModel)
        
    }
}

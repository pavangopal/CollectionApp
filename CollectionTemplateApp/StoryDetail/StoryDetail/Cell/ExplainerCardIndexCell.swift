//
//  ExplainerCardIndexCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/30/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Kingfisher
import Quintype

class ExplainerCardIndexCell: BaseCollectionCell {
    var indexButtonAction: ((Int)->())?
    
    var indexButton:UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = FontService.shared.explainerTitleIndexElementFont
        button.backgroundColor = .white
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        
        return button
    }()
    
    override func setUpViews(){
        
        contentView.addSubview(indexButton)
        indexButton.fillSuperview()
        
        indexButton.applyGradient(colors: [UIColor.black.withAlphaComponent(0.3),UIColor.black.withAlphaComponent(0.3),UIColor.darkGray.withAlphaComponent(0.3)], locations: nil, startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 1, y: 1),frame:CGRect(x: 0, y: 0, width:
            100, height: 100))
        indexButton.clipsToBounds = true
    }
    
    func configure(index:Int,ishighlighted: Bool = false,layout:[StoryDetailLayout],story:Story){
        indexButton.setTitleColor(ishighlighted ? .white : .black, for: .normal)
        
        indexButton.setTitle("\(index + 1)", for: .normal)
        
        indexButton.tag = index
        indexButton.addTarget(self, action: #selector(indexButtonPressed(sender:)), for: .touchUpInside)
        
        let imageElement = layout.filter({$0.layoutType == storyDetailLayoutType.StoryImageCell})
        let imageS3Key:String?
        
        if imageElement.count > 0{
            imageS3Key = (imageElement.first?.storyElement?.image_s3_key)
        }else{
            imageS3Key = story.hero_image_s3_key
        }
        
        let str = "https://" + (Quintype.publisherConfig?.cdn_image)! + "/" + (imageS3Key?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed))!
        
        if let imageUrl = URL(string: str){
            indexButton.kf.setBackgroundImage(with: imageUrl, for: .normal)
            
        }else{
            indexButton.setBackgroundImage(nil, for: .normal)
        }
    }
    
    @objc func indexButtonPressed(sender:UIButton){
        guard let buttonAction = indexButtonAction else{
            return
        }
        
        buttonAction(sender.tag)
    }
    
    
    override func prepareForReuse() {
        
        indexButton.setBackgroundImage(nil, for: .normal)
    }
    
    
}

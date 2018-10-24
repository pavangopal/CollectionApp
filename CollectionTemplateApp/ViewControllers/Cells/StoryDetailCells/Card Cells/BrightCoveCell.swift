//
//  BrightCoveCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/14/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher

class BrightCoveCell: BaseCollectionCell {
    
    var thumbnailImageView:UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled  = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var videoIconImageView:UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled  = false
        view.isHidden = true
        view.image = AssetImage.PlayCircle.image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func setUpViews(){
        super.setUpViews()
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(videoIconImageView)
        videoIconImageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        
        let storyTemplet = self.margin.storyTemplet
        let leftInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 5 : 0
        let rightInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 10 : 0
        
        thumbnailImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: leftInset, bottomConstant: self.margin.Bottom, rightConstant: rightInset, widthConstant: 0, heightConstant: 0)
        
        videoIconImageView.anchorCenterSuperview()
        
    }
    
    override func configure(data: Any?) {
        super.configure(data: data)
        
        guard let tuple = data as? (story:Story?,card:CardStoryElement?),let story = tuple.story,let card = tuple.card else {
            return
        }
        
//        contentView.backgroundColor = ParentSectionColor(sectionName: story.parentSection).primaryColor
        
        if let imageString = card.metadata?.poster_url,let imageURL = URL(string:"\(imageString)"){
            self.thumbnailImageView.kf.setImage(with: imageURL, placeholder: AssetImage.ImagePlaceHolder.image, options: nil, progressBlock: nil, completionHandler: { [weak self] (image, error, cachetype, url) in
                guard let selfD = self else{return}
                if error != nil{
                    selfD.thumbnailImageView.image = AssetImage.ImagePlaceHolder.image
                    selfD.videoIconImageView.isHidden = false
                }else{
                    selfD.thumbnailImageView.image = image
                    selfD.videoIconImageView.isHidden = false
                }
            })
        }else if let heroImageS3Key = story.hero_image_s3_key{
            
            if let _ = story.hero_image_metadata?.height{
                let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
                thumbnailImageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2), success: {
                    
                   self.videoIconImageView.isHidden = false
                    
                })
                
            }else{
                self.videoIconImageView.isHidden = false
            }
        }
        
    }
    
    override func prepareForReuse() {
        
        videoIconImageView.isHidden = true
    }
}

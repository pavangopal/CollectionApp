//
//  BitGravityCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/20/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import Kingfisher
import AVFoundation

class BitGravityCell: BaseCollectionCell {
    
    var thumbnailImageView:UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled  = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    var playIcon:UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled  = false
        
        view.image = AssetImage.PlayCircle.image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func setUpViews(){
        super.setUpViews()
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(playIcon)
        playIcon.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        
        let storyTemplet = self.margin.storyTemplet
        let leftInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 5 : 0
        let rightInset = (storyTemplet == .LiveBlog) ?  self.margin.Left - 10 : 0
        
        thumbnailImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: leftInset, bottomConstant: self.margin.Bottom, rightConstant: rightInset, widthConstant: 0, heightConstant: 0)
        playIcon.anchorCenterSuperview()
        
    }
    
    override func configure(data: Any?) {
        super.configure(data: data)
        
        guard let tuple = data as? (story:Story?,card:CardStoryElement?),let story = tuple.story,let card = tuple.card else {
            return
        }
        
        if let urlString = card.url,let url = URL(string: urlString){
            
            DispatchQueue.global(qos: .userInteractive).async {
                let asset = AVAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                do{
                    let thumbnail = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image =  UIImage(cgImage: thumbnail)
                    }
                }catch _{
                    
                    if let heroImageS3Key = story.hero_image_s3_key{
                        
                        let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
                        DispatchQueue.main.async {
                            self.thumbnailImageView.loadImage(imageMetaData: story.hero_image_metadata, imageS3Key: heroImageS3Key, targetSize: imageSize, placeholder: AssetImage.ImagePlaceHolder.image, animation: ImageTransition.fade(0.2))
                        }
                    }
                }
            }
        }
    }
    
    
}

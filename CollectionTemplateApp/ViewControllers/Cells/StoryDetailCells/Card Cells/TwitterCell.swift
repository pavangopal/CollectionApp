//
//  TwitterCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/1/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import TwitterKit
import Quintype

class TwitterCell: BaseCollectionCell {
    
   lazy var tweetView:TWTRTweetView = {
        let view = TWTRTweetView(tweet: nil, style: .compact)

        view.showActionButtons = false
    
        return view
        
    }()
    
    let client = TWTRAPIClient()
    
    override func setUpViews(){
        super.setUpViews()
        let view = self.contentView
        
        view.addSubview(self.tweetView)
        
        self.tweetView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
    }
    
    func configure(viewModel:TWTRTweet?,isConfigured:Bool=false){
        if self.margin.storyTemplet == .Video{
            contentView.backgroundColor = UIColor(hexString:"#333333")
            TWTRTweetView.appearance().theme = .dark
        }else{
            contentView.backgroundColor = .white
            TWTRTweetView.appearance().theme = .light
        }
        
        if !isConfigured{
            if let twitterViewD = viewModel{
                self.tweetView.configure(with: twitterViewD)
            }
        }
    }
    
    override func configure(data: Any?,indexPath:IndexPath,status:Bool){
        
        super.configure(data: data, indexPath: indexPath, status: status)
        
        if self.margin.storyTemplet == .Video{
            contentView.backgroundColor = UIColor(hexString:"#333333")
            TWTRTweetView.appearance().theme = .dark
        }else{
            contentView.backgroundColor = .white
            TWTRTweetView.appearance().theme = .light
        }
        
        let card = data as? CardStoryElement
        
        // TODO: Base this Tweet ID on some data from elsewhere in your app
        
        if let twitterId = card?.metadata?.tweet_id{
            DispatchQueue.main.async {
                
                self.client.loadTweet(withID: (twitterId)) {[weak self](tweet, error) in
                    
                    guard let unwrappedSelf = self else{
                        return
                    }
                    
                    if let unwrappedTweet = tweet{
                        
                        unwrappedSelf.tweetView.configure(with: unwrappedTweet)
                        
                    }else{
                        print("Failed to load tweet with tweetID:\(twitterId)")
                        
                        unwrappedSelf.delegate?.didCalculateSize(indexPath: indexPath, size: CGSize.zero, elementType: storyDetailLayoutType.TwitterCell)
                    }
                    
                    if status{
                        
                        if tweet != nil{
                            let size = unwrappedSelf.tweetView.sizeThatFits(CGSize.init(width: unwrappedSelf.contentView.frame.width, height: CGFloat.greatestFiniteMagnitude))
                            
                            let improvedSize = CGSize(width: size.width, height: size.height + 10)
                            
                            unwrappedSelf.delegate?.didCalculateSize(indexPath: indexPath, size: CGSize(width:unwrappedSelf.contentView.frame.width,height:improvedSize.height), elementType: storyDetailLayoutType.TwitterCell)
                            
                            
                        }else{
                            
                            unwrappedSelf.delegate?.didCalculateSize(indexPath: indexPath, size: CGSize.zero, elementType: storyDetailLayoutType.TwitterCell)
                            
                        }
                    }
                }
            }
        }
        else{
            self.delegate?.didCalculateSize(indexPath: indexPath, size: CGSize.zero, elementType: storyDetailLayoutType.TwitterCell)
        }
    }
    
}

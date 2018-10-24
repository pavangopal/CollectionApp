//
//  SocialShareCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/3/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol SocialShareCellDelegate : class{
    func socialSharePressed(shareType:SocialShareTypes)
}

enum SocialShareTypes:String{
    case Facebook = "facebook"
    case Twitter = "twitter"
    case WhatsApp = "whatsapp"
    
    case LinkedIn = "linkedin"
    
    case Others = "more"
    
    case Comment = "comment"
    
    var iconColor:UIColor{
        switch self {
        case .Facebook:
            return UIColor(hexString:"#3b5998")
        case .Twitter:
            return UIColor(hexString:"#0084b4")
        case .WhatsApp:
            return UIColor(hexString:"#34af23")
        case .Comment:
            return UIColor(hexString:"#7216AA")
            
        case .LinkedIn:
             return UIColor(hexString:"#0077B5")
            
        case .Others:
            return UIColor(hexString:"#36184E")
        }
    }
}

class SocialShareCell: BaseCollectionCell {
    
    weak var shareDelegate : SocialShareCellDelegate?
    
    
    
    var engagmentTitleLabel:UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.text = "SHARE,SAVE,COMMENT"
        view.font = FontService.shared.storySectionFont
        return view
    }()
    
    var commentTitleLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .white
        view.text = "COMMENT"
        view.font = FontService.shared.storySectionFont
        return view
    }()
    
    var commentButton:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontService.shared.storySectionFont
        button.setTitleColor(ThemeService.shared.theme.primaryTextColor, for: .normal)
        
        return button
    }()
    
    
    override func setUpViews(){
        
        contentView.backgroundColor = (self.margin.storyTemplet == .Video || self.margin.storyTemplet == .LiveBlog || (self.margin.storyTemplet == .Explainer)) ?  UIColor(hexString:"#333333") : .white
        
        self.createsocialShareButtons()
    }
    
    override func configure(data: Any?) {
        guard let story = data as? Story else {return}
        
        if let engagmentCount = story.engagment?.engagmentCount,engagmentCount > 999{
            let doubleValue = (Double(engagmentCount)/1000.0)
            let displayValue =  String(format:"%.1f", doubleValue)
            engagmentTitleLabel.text = "\(displayValue)K ENGAGEMENT"
        }
        
//        commentButton.setTitle("0", for: .normal)
    }
    
    
    func createsocialShareButtons(){
        
        let socialShareArray:[SocialShareTypes] = [.Facebook,.Twitter,.LinkedIn,.WhatsApp]
        
        let parentContainerView = UIView(frame: CGRect(x: self.margin.Left, y: 0, width: UIScreen.main.bounds.width - (self.margin.Left + self.margin.Right), height: 50))
        
        let buttonsContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - (self.margin.Left + self.margin.Right) - 100 - 2, height: 50))
        
        buttonsContainerView.backgroundColor = (self.margin.storyTemplet == .Video || self.margin.storyTemplet == .LiveBlog || (self.margin.storyTemplet == .Explainer)) ?  UIColor(hexString:"#333333") : UIColor(hexString:"#F4F4F4")
        
        engagmentTitleLabel.frame = CGRect(x: 0, y: 0, width: buttonsContainerView.frame.width, height: 20)
        
        let buttonsView = UIView(frame: CGRect(x: 0, y: 20, width: buttonsContainerView.frame.width, height: 30))
        var xOffset:CGFloat = 0
        let totalElements = CGFloat(socialShareArray.count)
        let width = ((buttonsView.frame.width - (totalElements - 1))/totalElements)//for padding
        
        for socialElement in socialShareArray{
            
            let button = UIButton(frame: CGRect(x: xOffset, y: 0, width: width, height: 30))
            
            let image = UIImage(named: socialElement.rawValue)?.withRenderingMode(.alwaysTemplate)            
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageView?.tintColor = socialElement.iconColor
            
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            
            button.tag = socialElement.hashValue
            button.addTarget(self, action: #selector(socialButtonPressed(sender:)), for: .touchUpInside)
            button.backgroundColor = .white
            xOffset += (width + 1)
           button.backgroundColor = (self.margin.storyTemplet == .Video || self.margin.storyTemplet == .LiveBlog || (self.margin.storyTemplet == .Explainer)) ?  UIColor(hexString:"#2B2B2B") : .white

            buttonsView.addSubview(button)
        }
        
        buttonsContainerView.addSubview(buttonsView)
        buttonsContainerView.addSubview(engagmentTitleLabel)
        
        //comment View
        let commentContainerView = UIButton(frame: CGRect(x: buttonsContainerView.frame.width + (buttonsContainerView.frame.origin.x) + 2, y: 0, width: 100, height: 50))
        
        commentContainerView.backgroundColor = (self.margin.storyTemplet == .Video || self.margin.storyTemplet == .LiveBlog || (self.margin.storyTemplet == .Explainer)) ?  UIColor(hexString:"#333333") : UIColor(hexString:"#F4F4F4")
        
        commentTitleLabel.frame = CGRect(x:0, y: 0, width: 100, height: 20)
        
        commentButton.frame = CGRect(x: 0, y: 20, width: 100, height: 30)
        commentButton.addTarget(self, action: #selector(commentButtonPressed(sender:)), for: .touchUpInside)
        
        let image = UIImage(named:SocialShareTypes.Comment.rawValue)
        commentButton.setImage(image, for: .normal)
        commentButton.imageView?.contentMode = .scaleAspectFit
        commentButton.backgroundColor = .white
        commentButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        commentButton.backgroundColor = (self.margin.storyTemplet == .Video || self.margin.storyTemplet == .LiveBlog || (self.margin.storyTemplet == .Explainer)) ?  UIColor(hexString:"#2B2B2B") : .white
        commentContainerView.addSubview(commentButton)
        commentContainerView.addSubview(commentTitleLabel)
        
        let titleBackgroundColor = (self.margin.storyTemplet == .Video || self.margin.storyTemplet == .LiveBlog || (self.margin.storyTemplet == .Explainer)) ?  .black : UIColor(hexString:"#333333")
        
        commentTitleLabel.backgroundColor = titleBackgroundColor
        engagmentTitleLabel.backgroundColor = titleBackgroundColor
        
        parentContainerView.addSubview(buttonsContainerView)
        parentContainerView.addSubview(commentContainerView)
        parentContainerView.backgroundColor = (self.margin.storyTemplet == .Video || self.margin.storyTemplet == .LiveBlog || (self.margin.storyTemplet == .Explainer)) ?  UIColor(hexString:"#333333") : UIColor(hexString:"#F4F4F4")
        contentView.addSubview(parentContainerView)
    }
    
    @objc func commentButtonPressed(sender:UIButton){
        
    }
    
    @objc func socialButtonPressed(sender:UIButton){
        switch sender.tag {
            
        case SocialShareTypes.Facebook.hashValue:
            shareDelegate?.socialSharePressed(shareType:SocialShareTypes.Facebook)
            break
        case SocialShareTypes.Twitter.hashValue:
            shareDelegate?.socialSharePressed(shareType:SocialShareTypes.Twitter)
            break
        
        case SocialShareTypes.WhatsApp.hashValue:
            shareDelegate?.socialSharePressed(shareType:SocialShareTypes.WhatsApp)
            break
        case SocialShareTypes.LinkedIn.hashValue:
            shareDelegate?.socialSharePressed(shareType:SocialShareTypes.LinkedIn)
            
        case SocialShareTypes.Others.hashValue:
            shareDelegate?.socialSharePressed(shareType:SocialShareTypes.Others)
            break
            
        default:
            break
        }
    }
    
}

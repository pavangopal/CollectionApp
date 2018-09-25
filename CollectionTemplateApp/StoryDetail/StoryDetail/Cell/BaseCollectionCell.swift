//
//  BaseCollectionCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


struct MarginD {
    var Left:CGFloat = 10
    var Right:CGFloat = 10
    var Top:CGFloat = 10
    var Bottom:CGFloat = 10
    
    //Added On
    var storyTemplet:StoryTemplet = .Default

    init (templet:StoryTemplet = .Default){
        
        self.storyTemplet = templet
        
        switch templet {
            
        case .Default:
            
            self.Left = 10
            self.Right = 10
            self.Top = 5
            self.Bottom = 10
            
        case .LiveBlog:
            
            self.Left = 15
            self.Right = 15
            self.Top = 5
            self.Bottom = 10
            
        default:
            
            self.Left = 10
            self.Right = 10
            self.Top = 5
            self.Bottom = 10
            
            break
        }
    }
}


protocol BaseCollectionCellDelegate:class {
    
    func didCalculateSize(indexPath:IndexPath,size:CGSize,elementType:storyDetailLayoutType)
    func shouldNavigateTo(controller:UIViewController)
}

class BaseCollectionCell: UICollectionViewCell {
    var homeCellDefaultPadding:CGFloat = 10
    var screenWidth = UIScreen.main.bounds.width
    var padding:CGFloat = 15
    let imageBaseUrl = "http://" + (Quintype.publisherConfig?.cdn_image)! + "/"
    
    weak var delegate:BaseCollectionCellDelegate?
    
    var margin:MarginD! = MarginD(templet: StoryTemplet.Default)
    
    lazy var dottedLineView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
//        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "dashedLine"))
        
        return view
    }()
    
    lazy var completion = { [weak self](margin:MarginD) in
        guard let selfD = self else {
            return
        }
        
        //early exit
        if let marD = selfD.margin{
            selfD.margin = margin
            return
        }
        
        selfD.margin = margin
//        selfD.setUpWithMargin(margin: margin)
    }
    
    func setUpViews(){
        contentView.backgroundColor = .white
        
//        if margin.storyTemplet == .LiveBlog{
//            contentView.addSubview(dottedLineView)
//            dottedLineView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 1, heightConstant: 0)
//        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTextColorForTemplet() -> UIColor{
        var textColor = ThemeService.shared.theme.primaryTextColor
        
        if self.margin.storyTemplet == .Video{
            textColor = .white
        }
        
        return textColor
    }
    
    func configure(data:Any?,indexPath:IndexPath,status:Bool){
        
    }
    
    func configure(data:Any?){
        
    }
    
    func configure(data: Any?,associatedMetaData:AssociatedMetadata?) {
    }
    
    func calculateHeight(targetSize:CGSize) -> CGSize{
        
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
    
}

extension BaseCollectionCell:TTTAttributedLabelDelegate{
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
 
        if url.absoluteString.contains("http"){
            let safariViewController = SafariViewController(url: url)
            safariViewController.showSafariController()
        }else{
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                if let topController = UIApplication.shared.topMostViewController() {
                    let alertController = UIAlertController(title: "Failed!!", message: "Could not open the url :(", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    topController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        let commonShare = CommonShare()
        commonShare.openActivityViewController(activityItem: [" "])
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWith url: URL!, at point: CGPoint) {
    }
}



//
//  AdvBlockCell.swift
//  TheQuint-Staging
//
//  Created by Albin.git on 3/9/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype
import GoogleMobileAds

class DFP:DFPBannerView{
    var isAdvLoaded:Bool = false
}

class AdvBlockCell:BaseCollectionCell,GADBannerViewDelegate{
    
    var bannerView:DFP = {
        let view = DFP()
        view.adSize = kGADAdSizeMediumRectangle
        view.backgroundColor = UIColor.init(hexString: "#efefef")
        return view
    }()
    
    let coverView:UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#efefef").withAlphaComponent(0.3)
        return view
        
    }()
    
    override func setUpViews() {
        
        let view = contentView
        view.addSubview(coverView)
        coverView.addSubview(bannerView)
        bannerView.fillSuperview()
        
        coverView.anchor(view.topAnchor, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 300, heightConstant: 250)
        coverView.anchorCenterXToSuperview()
    }
    
    
    func loadAdvForSection(advCount:Int,sectionName:String){
        
//        bannerView.adUnitID = appConfig.GoogleAdv.sectionUnitId
        let tags:[String:Any] = ["devicetype":"ios","section":sectionName,"position":advCount]
        initAdv(tags: tags)
    }
    
    func loadAdvForStoryDetailScreen(advCount:Int,sponsor:String?,storyType:String){
//        bannerView.adUnitID = appConfig.GoogleAdv.storyDetailUnitId
        var tags:[String:Any] = [:]
        
        if let sponsorName = sponsor{
            tags = ["devicetype":"ios","sponsor":sponsorName,"storyType":storyType,"position":advCount]
        }else{
            tags = ["devicetype":"ios","storyType":storyType,"position":advCount]
        }
        self.initAdv(tags: tags)
    }
    
    func initAdv(tags:[String:Any]){
        if !bannerView.isAdvLoaded{
            bannerView.delegate = self
            let request = DFPRequest()
            request.customTargeting = tags
            bannerView.isAdvLoaded = true
            self.bannerView.load(request)
            
        }
        
    }
    
}

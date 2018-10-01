//
//  StoryDetailDatasourceExtension.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import SafariServices
import UIKit
import Quintype
import AVKit
import AVFoundation
import Metype

extension StoryDetailDataSourceAndDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Fire the controller's Methods if implemented
        
        if let scrollViewDidScrollD = scrollViewDidScroll{
            scrollViewDidScrollD(scrollView.contentOffset)
        }
        
        let bounds = collectionView.bounds
        
        if let heroImageCell = collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0))  as? StoryDetailHeaderImageCell{
            heroImageCell.updateParallaxOffet(collectionViewBounds: bounds)
        }
        
    }
    
    //MARK: Action Methods
    
    @objc func summaryToggleButtonPressed(sender:UIButton){
        
        sender.isSelected = !sender.isSelected
        
        let pointConverted = self.collectionView.convert(sender.center, from: sender.superview)
        
        if let indexPath = self.collectionView.indexPathForItem(at: pointConverted){
            self.collapsedIndexPath[indexPath] = sender.isSelected
            self.collectionView.performBatchUpdates(nil, completion: nil)
            
//            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//            rotationAnimation.fromValue = 0.0
//            rotationAnimation.duration = 0.5
//            rotationAnimation.isRemovedOnCompletion = false
//            rotationAnimation.fillMode = kCAFillModeForwards
//
//            if sender.isSelected {
//                rotationAnimation.toValue = (Double.pi * 2) + (Double.pi/4)
//            }else{
//                rotationAnimation.toValue = -(Double.pi * 2)
//            }
//
//            UIView.animate(withDuration: 0, animations: {
//                sender.imageView?.layer.add(rotationAnimation, forKey: nil)
//            })
            
            
        }
    }
    
    @objc func openCommentController(sender:UIButton){
        Quintype.analytics.trackCommentVisit(story: self.story!)
        let pageUrl = sender.accessibilityLabel ?? ""
        let metypeColor = ThemeService.shared.theme.primarySectionColor
        var metypeController:UIViewController!
        
             metypeController = Metype(accountId: appConfig.Metype.id, metypeHost: appConfig.Metype.host, publisherHost: appConfig.baseURL, slug: pageUrl, color: metypeColor)
        
        
        self.controller.navigationController?.pushViewController(metypeController, animated: true)
    }
    
    func didCalculateSize(indexPath:IndexPath,size:CGSize,elementType:storyDetailLayoutType){
        
        if elementType.rawValue == storyDetailLayoutType.JSEmbedCell.rawValue{
            
            self.lazyLoadedCellHeight[indexPath] = size
            
            if collectionView.hasItemAtIndexPath(indexPath: indexPath){
                self.collectionView.reloadData()
            }
            
        }else if elementType.rawValue == storyDetailLayoutType.TwitterCell.rawValue{
            
                if collectionView.hasItemAtIndexPath(indexPath: indexPath){
                    self.collectionView.reloadData()
                }
        }else if elementType.rawValue == storyDetailLayoutType.CommentCell.rawValue{

                self.lazyLoadedCellHeight[indexPath] = size
                if collectionView.hasItemAtIndexPath(indexPath: indexPath){
                    self.collectionView.performBatchUpdates(nil, completion: nil)
                }
        }
    }
    
    func shouldNavigateTo(controller:UIViewController){
        self.controller.present(controller, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Controller actions
    
    func explainerTitleCellPressed(currentStoryElement:CardStoryElement){
        guard let storyD = self.story else {
            return
        }
        
        let explainerPreviewController = ExplainerPreviewController(story: storyD,currentStoryElement:currentStoryElement)
        controller.navigationController?.pushViewController(explainerPreviewController, animated: true)
    }
 
    internal func brightCoveCellPressed(storyElement:CardStoryElement){
//        let jwController = BrightCoveController(element: storyElement)
//        
//        if let navigationController = controller.navigationController{
//            navigationController.present(jwController, animated: true, completion: nil)
//        }else{
//            let navigationController = UINavigationController(rootViewController: jwController)
//            navigationController.present(jwController, animated: true, completion: nil)
//        }
    }
    
    internal func bitGravityCellPressed(storyElement:CardStoryElement){
        guard let urlString = storyElement.url,let videoURL = URL(string: urlString) else {
            return
        }
        
        let player = AVPlayer(url: videoURL)
        let bitGravityController = AVPlayerViewController()
        bitGravityController.player = player
        
        if let navigationController = controller.navigationController{
            
            navigationController.present(bitGravityController, animated: true) {
                bitGravityController.player?.play()
            }
        }else{
            let navigationController = UINavigationController(rootViewController: bitGravityController)
            navigationController.present(bitGravityController, animated: true) {
                bitGravityController.player?.play()
            }
        }
    }
    
    internal func didTapGalleryImage(at index:Int,storyElement:CardStoryElement,currentIndexPath:IndexPath){
        
        self.selectedIndexPath = currentIndexPath
        let newCardElement = CardStoryElement()
        newCardElement.story_elements = storyElement.story_elements
        
        self.showFullScreenImage(currentStoryElement: newCardElement,for:.Gallery(selectedIndex: index))
    }
    
    internal func showFullScreenImage(currentStoryElement:CardStoryElement,`for` type:ImageStoryElementType){
        guard let unwrappedStory = self.story else{
            return
        }
        
        let imageController = ImageController(story: unwrappedStory,currentElement:currentStoryElement,type:type)
        imageController.transitioningDelegate = self
        
        if let navigationController = controller.navigationController{
            navigationController.present(imageController, animated: true, completion: nil)
        }else{
            
            controller.present(imageController, animated: true, completion: nil)
        }
        
    }
    
    internal func getTargetSize(`forSection` section:Int) -> CGSize{
        switch section {
        case 0:
            
            return CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            
        default:
            
            return CGSize(width: UIScreen.main.bounds.width - 20, height: CGFloat.greatestFiniteMagnitude)
            
        }
    }
    
    internal func sortElements(order:SortingOrder) {
        
        guard let unwrappedStory = story , self.selectedOrder != order else{//if the selected order is same then return
            return
        }
        
        self.resetCachedHeight()
        self.selectedOrder = order
        
        var layoutEngine = LayoutEngine()
        
        layoutEngine.updateLiveBlogLayout(forSortingOrder: order, story: unwrappedStory, completion: { (layoutArray) in
            
            let storyLayoutWrapper = StoryLayoutWrapper(story: unwrappedStory, storyDetailLayout: layoutArray, supplementaryView: self.supplimentaryView)
            
            self.layout = storyLayoutWrapper.storyDetailLayout
            self.story = storyLayoutWrapper.story
            self.collectionView.reloadData()
        })
    }
    
    @objc func segmentControllPressed(sender:UISegmentedControl){
        self.collectionView.isScrollEnabled = false
    }
    
    func socialSharePressed(shareType:SocialShareTypes){
        
        if let storyDetail = self.story{
            switch shareType{
                
            case .Facebook:
                let faceBookClient = FacebookClient()
                faceBookClient.share(story: storyDetail, controller: controller)
                Quintype.analytics.trackShare(story: storyDetail, provider: "facebook")
                
            case .Twitter:
                
                let twitterKitClient = TwitterClient()
                twitterKitClient.share(story: storyDetail, controller: controller)
                Quintype.analytics.trackShare(story: storyDetail, provider: "twitter")
            case .WhatsApp:
                let whatsAppClient = WhatsAppClient()
                whatsAppClient.share(story: storyDetail, controller: controller)
                Quintype.analytics.trackShare(story: storyDetail, provider: "whatsapp")
            case .LinkedIn:
                let linkedInClient = LinkedInClient()
                linkedInClient.share(story: storyDetail, controller: controller)
                Quintype.analytics.trackShare(story: storyDetail, provider: "linkedin")
            case .Others:
                
                let commonShare = CommonShare()
                commonShare.share(story: storyDetail, controller: controller)
                Quintype.analytics.trackShare(story: storyDetail, provider: "other")
                break
                
            default:
                break
            }
            
        }
    }
    
    func alsoReadElementPressed(storyElement:CardStoryElement){
        if let linkedStoryId = storyElement.metadata?.linkedStory?.story_content_id ,
            let linkedStorySlug = self.story?.linkedStories[linkedStoryId]?.slug {
            
            let storyDetailViewController = StoryDetailController(slug:linkedStorySlug)
            controller.navigationController?.setNavigationBarHidden(false, animated: false)
            controller.navigationController?.pushViewController(storyDetailViewController, animated: true)
        }
    }
    
    func resetCachedHeight(){
        self.heightCache.removeAll()
    }
    
}

extension StoryDetailDataSourceAndDelegate:TableStoryElementDelegate{
    func registerObserverForView(collectionView: UICollectionView, cell: TableStoryElement) {
        self.tableCollectionView = collectionView
        self.tableCollectionView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: &StoryDetailDataSourceAndDelegate.COLLECTIONVIEW_OBS_CONTEXT)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context != nil && context! == &StoryDetailDataSourceAndDelegate.COLLECTIONVIEW_OBS_CONTEXT && keyPath != nil && keyPath! == "contentSize"{
            if let collectionView = object as? UICollectionView{
                if let tableElement = collectionView.superview?.superview as? TableStoryElement{
                    if let indexPath = self.collectionView.indexPath(for: tableElement){
                        
                        if let size = change?[.newKey] as? CGSize{
                            if size.height > 30{
                                if let value = self.cachedHeightsForTableStoryElement[indexPath]{
                                    if value < size.height{
                                        self.cachedHeightsForTableStoryElement[indexPath] = size.height
                                        self.collectionView.performBatchUpdates(nil, completion: nil)
                                    }
                                }
                                else{
                                    self.cachedHeightsForTableStoryElement[indexPath] = size.height
                                    // self.homeCollectionView.reloadItems(at: [indexPath])
                                    self.collectionView.performBatchUpdates(nil, completion: nil)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

extension StoryDetailDataSourceAndDelegate:UIViewControllerTransitioningDelegate,SFSafariViewControllerDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let unwrappedSelectedIndexPath = self.selectedIndexPath else{
            return nil
        }
        
        let selectedCell = self.collectionView.cellForItem(at: unwrappedSelectedIndexPath)
        transition.originalFrame = (selectedCell?.superview?.convert((selectedCell?.frame ?? UIScreen.main.bounds), to: nil)) ?? UIScreen.main.bounds
        transition.presenting = true
        
        return transition
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = false
        return transition
    }
}


extension StoryDetailDataSourceAndDelegate:AuthorElementCellDelegate{
    
    func authorPressedAt(index:Int){
        
        if index < (self.story?.authors.count ?? 0){
            if let author = self.story?.authors[index],let authorId = author.id?.intValue{
                let explainerPreviewController = AuthorController(authorId: authorId)
                controller.navigationController?.pushViewController(explainerPreviewController, animated: true)
            }
        }else if let authorId = self.story?.author_id?.intValue, index == 0{
            let explainerPreviewController = AuthorController(authorId: authorId)
            controller.navigationController?.pushViewController(explainerPreviewController, animated: true)
        }
        
    }
  
}

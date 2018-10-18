//
//  StoryDetailPager.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 1/5/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class StoryDetailPager: BaseController {
    
    let screenBounds  = UIScreen.main.bounds
    
    var slugArray:[String] = []
    var homeLayoutArray:[SectionLayout] = []
    
    var currentSlug:String?
    
    var currentPage:Int?{
        didSet{
            self.prepareViewControllers()
        }
    }
    
    var pageController: UIPageViewController = {
        let pager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        return pager
        
    }()
    
    override var prefersStatusBarHidden: Bool {

        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(slugArray:[String],currentIndex:Int) {
        self.init()
        self.currentPage = currentIndex
        self.slugArray = slugArray
        
    }
    
    convenience init(homeLayoutArray:[SectionLayout],currentIndex:Int,currentSlug:String?) {
        self.init()
        self.currentPage = currentIndex
        self.homeLayoutArray = homeLayoutArray
        self.currentSlug = currentSlug
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareStorySlugArray()
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIDeviceOrientationDidChange, object: nil)
        
    }
    
   @objc func videoDidRotate() {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func prepareStorySlugArray() {
        if homeLayoutArray.count > 0{
            for item in homeLayoutArray{
                if let slug = item.story?.slug{
                    self.slugArray.append(slug)
                }else if let collectionItemSlug = item.collectionItem?.story?.slug{
                    self.slugArray.append(collectionItemSlug)
                }
            }
            
            if let currentSlugD = currentSlug {
                self.findCurrentIndex(currentSlug: currentSlugD)
            }
            
        }else{
            self.prepareViewControllers()
        }
    }
    
    func findCurrentIndex(currentSlug:String){
        self.currentPage = slugArray.index(of: currentSlug)
    }
    
    func prepareViewControllers(){
        if let currentPageIndex = currentPage{
            let startingViewController = self.loadViewControllerAtIndex(index: currentPageIndex)
            
            let viewControllers = [startingViewController]
            pageController.isDoubleSided = false
            pageController.dataSource = self
            pageController.delegate = self
            pageController.setViewControllers(viewControllers, direction:.forward, animated:false, completion:nil)
            
            
            self.pageController.willMove(toParentViewController: self)
            self.addChildViewController(self.pageController)
            
            self.view.addSubview(self.pageController.view)
            
            self.pageController.didMove(toParentViewController: self)
        }
    }

}

extension StoryDetailPager:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as? StoryDetailController
        var index = vc?.pageIndex
        
        if (index == NSNotFound ){
            
            return nil
        }
        
        index = index! + 1
        
        if (index == self.slugArray.count){
            
            return nil
        }
        
        return loadViewControllerAtIndex(index: index!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as? StoryDetailController
        var index = vc?.pageIndex
        
        if (index == 0 || index == NSNotFound){
            
            return nil
        }
        
        index = index! - 1
        
        return loadViewControllerAtIndex(index: index!)
    }
    
    
    func loadViewControllerAtIndex(index: Int) -> StoryDetailController{
        let slug = self.slugArray[index]
        
        let detailVC = StoryDetailController(slug:slug)
        detailVC.pageIndex = index
        
        return detailVC
    }
}

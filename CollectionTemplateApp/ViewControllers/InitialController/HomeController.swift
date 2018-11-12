//
//  HomeController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/20/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//
import UIKit
import XLPagerTabStrip
import Quintype

class HomeController: BaseButtonBarPagerTabStripViewController<MenuCell> {
    
    var menuArray:[Menu]?
    var viewControllerCollection:[UIViewController] = []
    var selectedIndex:Int = 0
    
    var sponsoredStoryArray:[Story] = []
    var didMove = false
    var shouldShowBackButton = false
    
    //Trending-Stories
    var trendingStoryArray:[Story] = []
    let navigationBarHeight = UIApplication.shared.statusBarFrame.size.height + 44

    convenience init(menuArray:[Menu]?){
        self.init()
        
        buttonBarItemSpec = ButtonBarItemSpec.cellClass( width: {(indicatorInfo) -> CGFloat in
            let title = indicatorInfo.title ?? ""
            let titleWidth = title.width(font: FontService.shared.getCorrectedFont(fontName: FontFamilyName.OswaldRegular.rawValue, size: 26))
            
            if titleWidth < 20{
                return 80
            }
            return  titleWidth + 16
        })
        
        self.menuArray = menuArray
    }
    
    override func viewDidLoad() {
        if (menuArray?.count)! < 1 {
            settings.style.buttonBarHeight = 0.2
        }else{
            settings.style.buttonBarHeight = 55
        }
        
        self.tabarAnimation()
        
        super.viewDidLoad()
        self.setupNavgationbarForHome()
        
        if navigationController?.viewControllers.count ?? 0 > 1{
         self.addbackButton()
        }
        
        self.edgesForExtendedLayout = []
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedIndex < self.viewControllerCollection.count && !didMove{
            didMove = !didMove
            moveToViewController(at: selectedIndex, animated: false)
        }
    }

    override open func configure(cell: MenuCell, for indicatorInfo: IndicatorInfo) {
        
        cell.menuTitleLabel.text = indicatorInfo.title ?? ""
        
        if indicatorInfo.image != nil{
            cell.imageViewIcon.image = indicatorInfo.image
            cell.imageViewIcon.highlightedImage = indicatorInfo.highlightedImage
            cell.menuTitleLabel.text = nil
        }else{
            cell.imageViewIcon.image = nil
            cell.imageViewIcon.highlightedImage = nil
        }
    }
    
    
    func styleButtonBar() {
        settings.style.buttonBarBackgroundColor = ThemeService.shared.theme.primarySectionColor
        settings.style.buttonBarItemBackgroundColor = ThemeService.shared.theme.primarySectionColor
        settings.style.selectedBarBackgroundColor = ThemeService.shared.theme.primaryQuintColor
        settings.style.buttonBarItemFont = FontService.shared.pagerTopBarMenuFont
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarMinimumInteritemSpacing = 15
        settings.style.buttonBarMinimumLineSpacing = 5
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
    }
    
    private func tabarAnimation(){
        self.styleButtonBar()
        
        changeCurrentIndexProgressive = {(oldCell: MenuCell?, newCell: MenuCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
//            guard changeCurrentIndex == true else { return }
            
//            oldCell?.menuTitleLabel.textColor = .white
//            newCell?.menuTitleLabel.textColor = ThemeService.shared.theme.primaryQuintColor
            
            oldCell?.imageViewIcon.isHighlighted = false
            newCell?.imageViewIcon.isHighlighted = true
            
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            }
            else {
                newCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        menuArray?.forEach({ (menu) in
            
            let pagerController = SectionController(menu: menu)
//            let tabbarHeight = self.tabBarController?.tabBar.bounds.height
//            print("tabbarHeight:\(tabbarHeight)")
//            pagerController.additionalSafeAreaInsets.bottom = tabbarHeight ?? (navigationBarHeight + 20)
            viewControllerCollection.append(pagerController)
            return
            
        })
        
        return viewControllerCollection
    }
    
    
    override func reloadPagerTabStripView() {
        
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0 , elasticIndicatorLimit: arc4random() % 2 == 0 )
        }
        else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
    
}

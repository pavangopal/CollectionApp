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

class HomeController: BaseButtonBarPagerTabStripViewController<MenuCell>,
                        UINavigationBarDelegate,
                        NavigationItemDelegate {
    
    var menuArray:[Menu]?
    var viewControllerCollection:[UIViewController] = []
    
    var sponsoredStoryArray:[Story] = []
    
    //Trending-Stories
    var trendingStoryArray:[Story] = []
    
    lazy var navigationBar:CustomNavigationBar = {
        let navigationBar = CustomNavigationBar(delegate: self)
        return navigationBar
    }()
    
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
        
        createNavigationBar()
        navigationBar.setSolidColorNavigationBar()

        buttonBarView.frame.origin.y = 64
        containerView.frame.origin.y = 64
        
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
            
            guard changeCurrentIndex == true else { return }
            
            oldCell?.menuTitleLabel.textColor = .white
            newCell?.menuTitleLabel.textColor = ThemeService.shared.theme.primaryQuintColor
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
            
            let pagerController = SectionController(slug: menu.section_slug ?? "")
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
    
    func createNavigationBar(){
        view.addSubview(navigationBar)
        
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.delegate = self
        
        if #available(iOS 11, *) {
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
        navigationBar.setNavigationItems()
        navigationBar.setSolidColorNavigationBar()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func searchBarButtonPressed(){
        
    }
    func hamburgerBarButtonPressed(){
        
    }
}

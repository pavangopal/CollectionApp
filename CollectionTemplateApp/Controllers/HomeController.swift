//
//  HomeController.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

final class HomeController: UIViewController {
    var isLoading = true
    
    enum CellType: String {
        case Header = "headerCollectionCell"
        case Default = "defaultStoryCell"
        case CollectionTitleCell = "collectionTitleCell"
        case imageTextCell = "ImageTextCell"
        case fourColumnGridCell = "FourColumnGridCell"
        case storyListCell = "StoryListCell"
        case imageStoryListCardCell = "ImageStoryListCardCell"
        case carousalContainerCell = "CarousalContainerCell"
        case fullImageSliderCell = "FullImageSliderCell"
        case linerGalleryCarousalContainer = "LinerGalleryCarousalContainer"
        case imageStoryListCell = "ImageStoryListCell"
        case imageTextDescriptionCell = "ImageTextDescriptionCell"
        case storyListCardCell = "StoryListCardCell"
    }
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hexString: "#F5F5F5")
        return collectionView
    }()
    
    var collectionViewModel:CollectionViewModel?
    
    var sectionLayoutArray:[[SectionLayout]] = []
    
    
    init(slug:String){
        super.init(nibName: nil, bundle: nil)
        collectionViewModel = CollectionViewModel(slug: "home", delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViews()
        collectionViewModel?.startFetch()
        setupNavgationbarForHome()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    func setUpViews(){ 
        
        self.view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.register(CollectionTitleCell.self, forCellWithReuseIdentifier: CellType.CollectionTitleCell.rawValue)
        
        collectionView.register(ImageTextCell.self, forCellWithReuseIdentifier: CellType.imageTextCell.rawValue)
        collectionView.register(FourColumnGridCell.self, forCellWithReuseIdentifier: CellType.fourColumnGridCell.rawValue)
        collectionView.register(StoryListCell.self, forCellWithReuseIdentifier: CellType.storyListCell.rawValue)
        collectionView.register(ImageStoryListCardCell.self, forCellWithReuseIdentifier: CellType.imageStoryListCardCell.rawValue)
        collectionView.register(CarousalContainerCell.self, forCellWithReuseIdentifier: CellType.carousalContainerCell.rawValue)
        collectionView.register(FullImageSliderCell.self, forCellWithReuseIdentifier: CellType.fullImageSliderCell.rawValue)
        collectionView.register(LinerGalleryCarousalContainer.self, forCellWithReuseIdentifier: CellType.linerGalleryCarousalContainer.rawValue)
        collectionView.register(ImageStoryListCell.self, forCellWithReuseIdentifier: CellType.imageStoryListCell.rawValue)
        collectionView.register(ImageTextDescriptionCell.self, forCellWithReuseIdentifier: CellType.imageTextDescriptionCell.rawValue)
        collectionView.register(StoryListCardCell.self, forCellWithReuseIdentifier: CellType.storyListCardCell.rawValue)
        
        
        
    }
    
}


extension HomeController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionLayoutArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionLayoutArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BaseCollectionCell
        let layout = self.sectionLayoutArray[indexPath.section][indexPath.row]
        
        //Based on What data is passed to Config function
        //TODO: change different types of data to type Any
        
        switch layout.homeCellType {
            
        case .collectionTitleCell:

            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.CollectionTitleCell.rawValue, for: indexPath) as! BaseCollectionCell
            cell.configure(data: layout.data,associatedMetaData:layout.associatedMetaData)

        case .carousalContainerCell,.linerGalleryCarousalContainer:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as! BaseCollectionCell
            
            cell.configure(data: layout.carouselModel,associatedMetaData:layout.associatedMetaData)
            
        case .fourColumnGridCell,.imageTextDescriptionCell:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as! BaseCollectionCell
            
            cell.configure(data: layout.story,associatedMetaData:layout.associatedMetaData)
            
        default:
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as! BaseCollectionCell
            
            cell.configure(data: layout.storyViewModel,associatedMetaData:layout.associatedMetaData)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = self.sectionLayoutArray[indexPath.section][indexPath.row]
        let width = UIScreen.main.bounds.width - 30
        let targetSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    
        
        switch layout.homeCellType{
            
        case .collectionTitleCell:
            return CGSize(width: width, height: 50)
            
        case .fourColumnGridCell:
            return CGSize(width: width, height: 300)
            
        case .carousalContainerCell,.linerGalleryCarousalContainer:
            let size = CGSize(width: targetSize.width, height: (layout.carouselModel?.estimatedInnerCellHeight ?? 0) + CGFloat(20))
            return size
            
        default:
            return layout.storyViewModel?.preferredSize ?? .zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard  let layout = self.sectionLayoutArray[section].first else{
            return .zero
        }
        
        
        switch layout.collectionLayoutType ?? .UNKNOWN {
            
        case .FullscreenLinearGallerySlider:
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
            
        default:
            return UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //LoadMore
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 200.0 {
            if !isLoading{
                isLoading = true
                self.collectionViewModel?.loadNext()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = self.sectionLayoutArray[indexPath.section][indexPath.row]
        navigateToStory(story: layout.story!, indexPath: indexPath)
    }
    
    func navigateToStory(story:Story,indexPath:IndexPath){
        
        let storyDetailPager = StoryDetailPager(slugArray: [story.slug ?? ""], currentIndex: 0)
        
        self.navigationController?.pushViewController(storyDetailPager, animated: true)
        
    }
}


extension HomeController : CollectionViewModelDelegate {
    
    func didRecieveData(sectionLayoutArray:[[SectionLayout]]) {
        self.sectionLayoutArray.append(contentsOf: sectionLayoutArray)
        self.collectionView.reloadData()
        isLoading = false
    }
    
}




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
        case ImageTextCell = "ImageTextCell"
        case FourColumnGridCell = "FourColumnGridCell"
        case StoryListCell = "StoryListCell"
        case ImageStoryListCell = "ImageStoryListCell"
        case CarousalContainerCell = "CarousalContainerCell"
        case FullImageSliderCell = "FullImageSliderCell"
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
        
    }
    
    func setUpViews() {
        
        self.view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.register(CollectionTitleCell.self, forCellWithReuseIdentifier: CellType.CollectionTitleCell.rawValue)
        
        collectionView.register(ImageTextCell.self, forCellWithReuseIdentifier: CellType.ImageTextCell.rawValue)
        collectionView.register(FourColumnGridCell.self, forCellWithReuseIdentifier: CellType.FourColumnGridCell.rawValue)
        collectionView.register(StoryListCell.self, forCellWithReuseIdentifier: CellType.StoryListCell.rawValue)
        collectionView.register(ImageStoryListCell.self, forCellWithReuseIdentifier: CellType.ImageStoryListCell.rawValue)
        collectionView.register(CarousalContainerCell.self, forCellWithReuseIdentifier: CellType.CarousalContainerCell.rawValue)
        collectionView.register(FullImageSliderCell.self, forCellWithReuseIdentifier: CellType.FullImageSliderCell.rawValue)
        
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
        var cell: BaseCollectionCell?
        let layout = self.sectionLayoutArray[indexPath.section][indexPath.row]
        
        switch layout.homeCellType {
            
        case .CollectionTitleCell:

            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.CollectionTitleCell.rawValue, for: indexPath) as? BaseCollectionCell
            cell?.configure(data: layout.data)

            
        case .ImageTextCell:
            let imageTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as? ImageTextCell// as? ImageTextCell
            
            imageTextCell?.configure(data: layout.story)
            
            cell = imageTextCell
            
        case .FourColumnGridCell:
            let imageTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as? FourColumnGridCell// as? ImageTextCell
            
            imageTextCell?.configure(data: layout.story)
            
            cell = imageTextCell
            
        case .StoryListCell:
            let imageTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as? StoryListCell// as? ImageTextCell
            
            imageTextCell?.configure(data: layout.story)
            
            cell = imageTextCell
            
        case .ImageStoryListCell:
            let imageTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as? ImageStoryListCell// as? ImageTextCell
            
            imageTextCell?.configure(data: layout.story)
            
            cell = imageTextCell
            
        case .CarousalContainerCell:
            let imageTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as? CarousalContainerCell
            
            imageTextCell?.configure(data: layout.carouselModel)
            
            cell = imageTextCell
            
        case .FullImageSliderCell:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellType.FullImageSliderCell.rawValue, for: indexPath) as? FullImageSliderCell
            
            cell?.configure(data: layout.story)
            
            return cell!
            
        default:
            
            let imageTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: layout.homeCellType.rawValue, for: indexPath) as? ImageTextCell// as? ImageTextCell
            
            imageTextCell?.configure(data: layout.story)
            
            cell = imageTextCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = self.sectionLayoutArray[indexPath.section][indexPath.row]
        let width = UIScreen.main.bounds.width - 30
        let targetSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        switch layout.homeCellType{
            
        case .CollectionTitleCell:
            return CGSize(width: width, height: 50)
            
            
        case .FourColumnGridCell:
            return CGSize(width: width, height: 300)
            
        case .ImageTextCell :
//            let sizingCell = ImageTextCell(frame: CGRect.zero)
//            sizingCell.configure(data: layout.story)
//            let size = sizingCell.calculateHeight(targetSize: targetSize)
//
//            return size
            return layout.size
            
        case .StoryListCell:
//            let sizingCell = StoryListCell(frame: CGRect.zero)
//            sizingCell.configure(data: layout.story)
//            let size = sizingCell.calculateHeight(targetSize: targetSize)
//
//            return size
            return layout.size

        case .ImageStoryListCell:
//            let sizingCell = ImageStoryListCell(frame: CGRect.zero)
//            sizingCell.configure(data: layout.story)
//            let size = sizingCell.calculateHeight(targetSize: targetSize)
//
//            return size
            return layout.size


        case .CarousalContainerCell:
            let size = CGSize(width: targetSize.width, height: (layout.carouselModel?.estimatedInnerCellHeight ?? 0) + CGFloat(20))
            return size
            
        case .FullImageSliderCell:
            return CGSize(width: width, height: 450)
            
        default:
            return CGSize(width: width, height: 50)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard  let layout = self.sectionLayoutArray[section].first else{
            return .zero
        }
        
        switch layout.homeCellType {
            
        case .CollectionTitleCell:
            return UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        default:
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
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
    
}


extension HomeController : CollectionViewModelDelegate {
    
    func didRecieveData(sectionLayoutArray:[[SectionLayout]]) {
        self.sectionLayoutArray.append(contentsOf: sectionLayoutArray)
        self.collectionView.reloadData()
        isLoading = false
    }
    
}




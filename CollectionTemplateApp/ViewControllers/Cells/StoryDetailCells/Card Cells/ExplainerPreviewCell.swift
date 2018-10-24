//
//  ExplainerPreviewCell.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/24/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol ExplainerPreviewCellDelegate:class {
    func innerCollectionViewDidScroll(contentOffset:CGPoint,scrollView:UIScrollView)
}

class ExplainerPreviewCell: BaseCollectionCell {
    
    weak var explainerCellDelegate:ExplainerPreviewCellDelegate?
    
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = UIColor(hexString: "#F4F4F4")
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        return collectionview
    }()
    
    var dataSource : StoryDetailDataSourceAndDelegate?
    var sizingCells:[String:BaseCollectionCell] = [:]
    
    override func setUpViews(){
        contentView.backgroundColor = UIColor(hexString: "#F4F4F4")
        contentView.addSubview(collectionView)
        
        collectionView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: self.margin.Top, leftConstant: self.margin.Left, bottomConstant: self.margin.Bottom, rightConstant: self.margin.Right, widthConstant: 0, heightConstant: 0)
        self.registerCells()
      
    }
    
    func registerCells(){
        //TODO: should be removed
        
        collectionView.register(BaseCollectionCell.self, forCellWithReuseIdentifier: String(describing:BaseCollectionCell.self))
        
        let storyDetailCells = [StoryDetailHeaderImageCell.self,StoryHeadlineCell.self,AuthorElementCell.self,StoryTextElementCell.self,StoryImageCell.self,StorySummaryCell.self,TwitterCell.self,BlockQuoteCell.self,BlurbElementCell.self,BigfactCell.self,QuestionandAnswerCell.self,QuoteCell.self,QuestionElementCell.self,AnswerElementCell.self,UrlEmbedCell.self,SocialShareCell.self,GalleryCell.self,RatingCell.self,TitleElementCell.self,KeyEventCell.self,StoryCardsSorterCell.self,AlsoReadCell.self,ExplainerHeaderImageCell.self,ExplainerTitleCell.self]
        
        storyDetailCells.forEach { (cell) in
            collectionView.register(cellClass: cell)
            let cellD = cell.self.init()
            self.sizingCells[cell.reuseIdentifier] = cellD
        }
    }
    
    func configureCell(layout:[[StoryDetailLayout]],story:Story,controller:BaseController){
        let layoutWrapper:StoryLayoutWrapper = StoryLayoutWrapper(story: story, storyDetailLayout: layout, supplementaryView: nil)
        self.dataSource = StoryDetailDataSourceAndDelegate(layoutWrapper:layoutWrapper, collectionview: self.collectionView, controller: controller, sizingCell: self.sizingCells)
        
        self.collectionView.delegate = self.dataSource
        self.collectionView.dataSource = self.dataSource
        
    }
    
    func configure(dataSource:StoryDetailDataSourceAndDelegate?,animated:Bool = true){
        DispatchQueue.main.async {
            if animated{
                UIView.animate(withDuration: 0.5, animations: {
                    self.displayCard(dataSource: dataSource)
                })
            }else{
                self.displayCard(dataSource: dataSource)
            }
        }
    }
    
    func displayCard(dataSource:StoryDetailDataSourceAndDelegate?){
        self.dataSource = dataSource
        
        if let dataSourceD = dataSource{
            dataSourceD.scrollViewDidScroll = {[weak self] (contentOffset)->() in
                guard let selfD = self else {return}
                
                selfD.explainerCellDelegate?.innerCollectionViewDidScroll(contentOffset:contentOffset,scrollView: selfD.collectionView)
            }
            
            self.collectionView.alpha = 1
            
            dataSourceD.collectionView = self.collectionView
            dataSourceD.sizingCells = self.sizingCells
            self.collectionView.delegate = dataSourceD
            self.collectionView.dataSource = dataSourceD
            
        }else{
            self.collectionView.alpha = 0
        }
    }
    
    override func prepareForReuse() {
        if #available(iOS 10.0, *) {
            DispatchQueue.main.async {
                self.displayCard(dataSource: .none)
            }
        }
    }
    
}

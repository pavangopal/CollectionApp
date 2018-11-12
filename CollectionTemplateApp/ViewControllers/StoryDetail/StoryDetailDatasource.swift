//
//  StoryDetailControllerExtension.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype
import FacebookShare
import TwitterKit


class StoryDetailDataSourceAndDelegate:NSObject,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BaseCollectionCellDelegate,GalleryCellDelegate,StoryCardsSorterCellDelegate,SocialShareCellDelegate,AlsoReadCellDelegate{
    
    
    //basic requirements
    var story:Story?
    
    weak var collectionView:UICollectionView!
    weak var controller:BaseController!
    var layout : [[StoryDetailLayout]] = []
    
    var supplimentaryView:StoryDetailLayout?
    
    //caching variables
    var advCounter:Int = 0
    var advReuseableIdentifiers:[String] = []
    var jsEmbbedCellIdentifiers : [String] = []
    var youtubeCellIdentifiers:[String] = []
    
    var collapsedIndexPath: [IndexPath:Bool] = [:]
    
    var lazyLoadedCellHeight : [IndexPath:CGSize] = [:]
    var selectedIndexPath : IndexPath?
    
    var heightCache:[IndexPath:CGSize] = [:]
    
    var sizingCells:[String:BaseCollectionCell] = [:]
    
    var selectedOrder = SortingOrder.New
    let transition = Animator()
    
    //Table Story Element
    var tableCollectionView: UICollectionView?
    var cachedHeightsForTableStoryElement:[IndexPath:CGFloat] = [:]
    static var COLLECTIONVIEW_OBS_CONTEXT:Int = 0
    
    
    //Call Backs to controllers
    public var selectedCallback : ((_ layout:[[StoryDetailLayout]],_ indexPath:IndexPath)->Void)?
    public var scrollViewDidScroll:((_ contentOffset:CGPoint) -> ())?
    
    var margin: MarginD! = MarginD(templet: StoryTemplet.Default)
    
    required init (layoutWrapper:StoryLayoutWrapper,
                   collectionview:UICollectionView,
                   controller:BaseController,
                   sizingCell:[String:BaseCollectionCell]? = nil){
        
        super.init()
        
        
        self.heightCache = [:]
        self.story = layoutWrapper.story
        self.collectionView = collectionview
        self.controller = controller
        self.layout = layoutWrapper.storyDetailLayout
        self.supplimentaryView = layoutWrapper.supplementaryView
        
        if let sizingCells = sizingCell{
            self.sizingCells = sizingCells
        }else{
            self.registerCells()
        }
        
        //for Liveblog
        self.selectedOrder = (story?.storyMetadata?.is_closed ?? false) ? SortingOrder.Old : SortingOrder.New
        
    }
    
    required init(layoutWrapper:StoryLayoutWrapper,controller:BaseController) {
        self.story = layoutWrapper.story
        
        self.layout = layoutWrapper.storyDetailLayout
        self.supplimentaryView = layoutWrapper.supplementaryView
        self.controller = controller
    }
    
    func registerCells(){
        //TODO: should be removed
        collectionView.register(BaseCollectionCell.self, forCellWithReuseIdentifier: String(describing:BaseCollectionCell.self))
        
        registerSuplimentaryViews()
       
        let storyTypeArray = Set(self.layout.flatMap({$0}).map({$0.layoutType}))
        
        var cells:[BaseCollectionCell.Type] = []
        
        for type in storyTypeArray{
            if let cell = NSObject.swiftClassFromString(className: type.rawValue) as? BaseCollectionCell.Type{
                cells.append(cell)
            }
        }
        
        cells.forEach { (cell) in
            collectionView.register(cellClass: cell)
            let cellD = cell.self.init()
//            cellD.completion(self.margin)
            self.sizingCells[cell.reuseIdentifier] = cellD
        }
        
        collectionView.register(cellClass: TableStoryElement.self)
    }
    
    private func registerSuplimentaryViews(){
        collectionView.register(StoryDetailHeaderImageCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: StoryDetailHeaderImageCell.reuseIdentifier)
        collectionView.register(YoutubeCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: YoutubeCell.reuseIdentifier)
        collectionView.register(BrightCoveCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: BrightCoveCell.reuseIdentifier)
        collectionView.register(BitGravityCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: BitGravityCell.reuseIdentifier)
        
    }
    
    //MARK: CollectionView's DataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return layout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layout[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : BaseCollectionCell?
        
        let cellType = layout[indexPath.section][indexPath.row].layoutType
        let storyElement = layout[indexPath.section][indexPath.row].storyElement
        
        switch cellType {
            
        case .CommentCell:
            let id = "JSEmbedCell\(indexPath)"
            
            if jsEmbbedCellIdentifiers.contains(id){
                
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? BaseCollectionCell
                let currentCell = cell as? CommentCell
                
                currentCell?.configure(data: story, indexPath: indexPath, status: true)
                currentCell?.delegate = self
                
            }else{
                
                collectionView.register(CommentCell.self, forCellWithReuseIdentifier: id)
                self.jsEmbbedCellIdentifiers.append(id)
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? BaseCollectionCell
                let currentCell = cell as? CommentCell
                //Reseting the contentLoaded key so that pull to refresh reloads the jsembed
//                currentCell?.contentLoaded = true
                
                currentCell?.configure(data: story, indexPath: indexPath, status: false)
                currentCell?.delegate = self
                
            }
            
        case .AdvBlockCell:
            let advCell:AdvBlockCell?
            
            let identifier = "adv" + indexPath.section.description
            
            if advReuseableIdentifiers.contains(identifier){
                advCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? AdvBlockCell
                advCell?.bannerView.rootViewController = self.controller
                advCell?.loadAdvForStoryDetailScreen(advCount: advReuseableIdentifiers.index(of: identifier)!, sponsor: story?.storyMetadata?.sponsored_by ?? nil, storyType: (self.story?.story_template?.rawValue)!)
                return advCell!
            }else{
                collectionView.register(AdvBlockCell.self, forCellWithReuseIdentifier: identifier)
                advReuseableIdentifiers.append(identifier)
                advCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? AdvBlockCell
                advCell?.bannerView.rootViewController = self.controller
                advCell?.loadAdvForStoryDetailScreen(advCount: advCounter, sponsor: story?.storyMetadata?.sponsored_by ?? nil, storyType: (self.story?.story_template?.rawValue)!)
                
                advCounter = advCounter + 1
                return advCell!
            }
            
        case .StoryDetailHeaderImageCell:
            
            cell = collectionView.dequeueReusableCell(ofType: StoryDetailHeaderImageCell.self, for: indexPath)
            let currentCell = cell as? StoryDetailHeaderImageCell
            
            currentCell?.delegate = self
            
            currentCell?.configure(data:self.story)
            
            currentCell?.updateParallaxOffet(collectionViewBounds: collectionView.bounds)
            
        case .StoryHeadlineCell:
            
            cell = collectionView.dequeueReusableCell(ofType: StoryHeadlineCell.self, for: indexPath)
            
            let currentCell = cell as? StoryHeadlineCell
            currentCell?.storyHeadlineDelegate = self
            currentCell?.configure(data: self.story)
            
            
        case .AuthorElementCell:
            cell = collectionView.dequeueReusableCell(ofType: AuthorElementCell.self, for: indexPath)
            let currentCell = cell as? AuthorElementCell
            currentCell?.authorDelegate = self
            currentCell?.configure(data: self.story)
            
            
        case .StoryTextElementCell:
            
            cell = collectionView.dequeueReusableCell(ofType: StoryTextElementCell.self, for: indexPath)
            let currentCell = cell as? StoryTextElementCell
            
            currentCell?.configure(data: storyElement)
            
            
        case .StoryImageCell:
            
            cell = collectionView.dequeueReusableCell(ofType: StoryImageCell.self, for: indexPath)
            let currentCell = cell as? StoryImageCell
            
            currentCell?.configure(data: storyElement)
            
            
            
        case .StorySummaryCell:
            cell = collectionView.dequeueReusableCell(ofType: StorySummaryCell.self, for: indexPath)
            
            let currentCell = cell as? StorySummaryCell
            currentCell?.dropDownButton.addTarget(self, action: #selector(summaryToggleButtonPressed(sender:)), for: .touchUpInside)
            currentCell?.indexPath = indexPath
            currentCell?.configure(data: storyElement)
            
            
        case .JSEmbedCell:
            
            let id = "JSEmbedCell\(indexPath)"
            
            if jsEmbbedCellIdentifiers.contains(id){
                
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? BaseCollectionCell
                let currentCell = cell as? JSEmbedCell
                
                currentCell?.configure(data: storyElement, indexPath: indexPath, status: true)
                currentCell?.delegate = self
                
            }else{
                
                collectionView.register(JSEmbedCell.self, forCellWithReuseIdentifier: id)
                self.jsEmbbedCellIdentifiers.append(id)
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? BaseCollectionCell
                let currentCell = cell as? JSEmbedCell
                //Reseting the contentLoaded key so that pull to refresh reloads the jsembed
                currentCell?.contentLoaded = ""
                
                currentCell?.configure(data: storyElement, indexPath: indexPath, status: false)
                currentCell?.delegate = self
                
            }
            
        case .YoutubeCell:
            
            let id = "YoutubeCell\(indexPath)"
            
            if youtubeCellIdentifiers.contains(id){
                
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? BaseCollectionCell
                let currentCell = cell as? YoutubeCell
                
                currentCell?.configure(data: storyElement)
                
            }else{
                
                collectionView.register(YoutubeCell.self, forCellWithReuseIdentifier: id)
                self.youtubeCellIdentifiers.append(id)
                
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? BaseCollectionCell
                let currentCell = cell as? YoutubeCell
                
                currentCell?.configure(data: storyElement)
                
            }
            
            
        case .BrightCoveCell:
            
            cell = collectionView.dequeueReusableCell(ofType: BrightCoveCell.self, for: indexPath)
            let currentCell = cell as? BrightCoveCell
            let tuple:(story:Story?,card:CardStoryElement?) = (story,storyElement)
            currentCell?.configure(data: tuple)
            
            
        case .TwitterCell:
            
            cell = collectionView.dequeueReusableCell(ofType: TwitterCell.self, for: indexPath)
            
            let currentCell = cell as? TwitterCell
            
            
            if (lazyLoadedCellHeight.index(forKey: indexPath) == nil){
                
                currentCell?.configure(viewModel:  layout[indexPath.section][indexPath.row].tweet,isConfigured:true)
                
            }else{
                currentCell?.configure(viewModel:  layout[indexPath.section][indexPath.row].tweet,isConfigured:false)
            }
            
        case .QuestionandAnswerCell:
            cell = collectionView.dequeueReusableCell(ofType: QuestionandAnswerCell.self, for: indexPath)
            let currentCell = cell as? QuestionandAnswerCell
            
            currentCell?.configure(data: storyElement)
            
            
        case .BlockQuoteCell:
            
            cell = collectionView.dequeueReusableCell(ofType: BlockQuoteCell.self, for: indexPath)
            let currentCell = cell as? BlockQuoteCell
            
            currentCell?.configure(data: storyElement)
            
            
        case .QuoteCell:
            cell = collectionView.dequeueReusableCell(ofType: QuoteCell.self, for: indexPath)
            let currentCell = cell as? QuoteCell
            
            currentCell?.configure(data: storyElement)
            
        case .BlurbElementCell:
            cell = collectionView.dequeueReusableCell(ofType: BlurbElementCell.self, for: indexPath)
            let currentCell = cell as? BlurbElementCell
            
            currentCell?.configure(data: storyElement)
            
        case .BigfactCell:
            
            cell = collectionView.dequeueReusableCell(ofType: BigfactCell.self, for: indexPath)
            let currentCell = cell as? BigfactCell
            
            currentCell?.configure(data: storyElement)
            
            
        case .QuestionElementCell:
            cell = collectionView.dequeueReusableCell(ofType: QuestionElementCell.self, for: indexPath)
            let currentCell = cell as? QuestionElementCell
            
            currentCell?.configure(data: storyElement)
            
            
        case .AnswerElementCell:
            cell = collectionView.dequeueReusableCell(ofType: AnswerElementCell.self, for: indexPath)
            let currentCell = cell as? AnswerElementCell
            
            currentCell?.configure(data: storyElement)
            
            
        case .UrlEmbedCell:
            cell = collectionView.dequeueReusableCell(ofType: UrlEmbedCell.self, for: indexPath)
            let currentCell = cell as? UrlEmbedCell
            
            currentCell?.configure(data: storyElement, indexPath: indexPath, status: false)
            
            
        case .SocialShareCell:
            cell = collectionView.dequeueReusableCell(ofType: SocialShareCell.self, for: indexPath)
            let currentCell = cell as? SocialShareCell
            currentCell?.shareDelegate = self
            currentCell?.commentButton.addTarget(self, action: #selector(openCommentController(sender:)), for: UIControlEvents.touchUpInside)
            if let slug = story?.slug{ currentCell?.commentButton.accessibilityLabel = slug }
            currentCell?.configure(data: story)
            
        case .GalleryCell:
            cell = collectionView.dequeueReusableCell(ofType: GalleryCell.self, for: indexPath)
            let currentCell = cell as? GalleryCell
            currentCell?.galleryDelegate = self
            
            currentCell?.configure(data: storyElement, indexPath: indexPath, status: true)
            
            
        case .RatingCell:
            cell = collectionView.dequeueReusableCell(ofType: RatingCell.self, for: indexPath)
            let currentCell = cell as? RatingCell
            
            currentCell?.configure(data: self.story)
            
            
            
        case .TitleElementCell:
            
            cell = collectionView.dequeueReusableCell(ofType: TitleElementCell.self, for: indexPath)
            let currentCell = cell as? TitleElementCell
            
            currentCell?.configure(data: storyElement)
            
            
        case .KeyEventCell:
            cell = collectionView.dequeueReusableCell(ofType: KeyEventCell.self, for: indexPath)
            let currentCell = cell as? KeyEventCell
            
            currentCell?.configure(data: layout[indexPath.section][indexPath.row].card)
            
            
        case .StoryCardsSorterCell:
            
            cell = collectionView.dequeueReusableCell(ofType: StoryCardsSorterCell.self, for: indexPath)
            let currentCell = cell as? StoryCardsSorterCell
            currentCell?.sortingDelegate = self
            
            currentCell?.configure(data: self.selectedOrder)
            
        case .AlsoReadCell:
            
            cell = collectionView.dequeueReusableCell(ofType: AlsoReadCell.self, for: indexPath)
            let currentCell = cell as? AlsoReadCell
            currentCell?.alsoReadDelegate = self
            
            currentCell?.configure(data: storyElement)
            
        case .ExplainerHeaderImageCell:
            cell = collectionView.dequeueReusableCell(ofType: ExplainerHeaderImageCell.self, for: indexPath)
            let currentCell = cell as? ExplainerHeaderImageCell
            
            currentCell?.configure(data: self.story)
            
            //            actualCell?.updateParallaxOffet(collectionViewBounds: collectionView.bounds)
            
        case .ExplainerTitleCell:
            
            cell = collectionView.dequeueReusableCell(ofType: ExplainerTitleCell.self, for: indexPath)
            
            let currentCell = cell as? ExplainerTitleCell
            
            currentCell?.configure(headline: story?.headline, element: storyElement, index: indexPath.row)
            
        case .storyTableElementCell:
            cell = collectionView.dequeueReusableCell(ofType: TableStoryElement.self, for: indexPath)
            let currentCell = cell as? TableStoryElement
            currentCell?.tableDelegate = self
            currentCell?.setNeedsUpdateConstraints()
            currentCell?.updateConstraintsIfNeeded()
            
            currentCell?.configure(datam: storyElement?.tableData)
            
        case .BitGravityCell:
            
            cell = collectionView.dequeueReusableCell(ofType: BitGravityCell.self, for: indexPath)
            let currentCell = cell as? BitGravityCell
            
            let tuple:(story:Story?,card:CardStoryElement?) = (story,storyElement)
            currentCell?.configure(data: tuple)
            
            
        case .ExplainerSummaryCell:
            cell = collectionView.dequeueReusableCell(ofType: ExplainerSummaryCell.self, for: indexPath)
            let currentCell = cell as? ExplainerSummaryCell
            
            currentCell?.configure(data: storyElement)
            
        case .StoryDetailsTagElementCell:
            cell = collectionView.dequeueReusableCell(ofType: StoryDetailsTagElementCell.self, for: indexPath)
            let currentCell = cell as? StoryDetailsTagElementCell
            currentCell?.delegate = self
            currentCell?.configure(data: story)
            
        }
      
        return cell!
    }
    
    //MARK: Layout Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let size = heightCache[indexPath]{
            return size
        }
        
        let targetSize =  self.getTargetSize(forSection: indexPath.section)
        
        let cellType = layout[indexPath.section][indexPath.row].layoutType
        let storyElement = layout[indexPath.section][indexPath.row].storyElement
        let sizingCell = sizingCells[cellType.rawValue]
        
        switch cellType {
            
        case .CommentCell:
    
            if lazyLoadedCellHeight.index(forKey: indexPath) != nil{
                
                return lazyLoadedCellHeight[indexPath]!
                
            }else{
                
                return CGSize(width: targetSize.width, height: 40)
            }
            
        case .AdvBlockCell:
          
            return CGSize(width: UIScreen.main.bounds.width - 20, height: 290)
            
        case .StoryDetailHeaderImageCell:
            
            sizingCell?.configure(data:self.story)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .StoryHeadlineCell:
            
            sizingCell?.configure(data:self.story)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .AuthorElementCell:
            
            sizingCell?.configure(data:self.story)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .StoryTextElementCell:
            
            sizingCell?.configure(data: storyElement)
            //            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            let constraintedSize = CGSize(width: targetSize.width - (self.margin.Left * 2), height: targetSize.height)
            
            let calculatedSize = TTTAttributedLabel.sizeThatFitsAttributedString(storyElement?.displayText, withConstraints: constraintedSize, limitedToNumberOfLines: 0)
            let actualHeight = CGSize(width: targetSize.width, height: calculatedSize.height + (self.margin.Left * 2))
            self.heightCache[indexPath] = actualHeight
            return actualHeight
            
            
        case .StoryImageCell:
            
            sizingCell?.configure(data:storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .StorySummaryCell:
            if !(self.collapsedIndexPath[indexPath] ?? false){
                
                sizingCell?.configure(data:storyElement)
                let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
                return calculatedSize!
                
            }else{
                
                return CGSize(width: targetSize.width, height: 74)
            } 
            
        case .YoutubeCell:
            
            return CGSize(width: targetSize.width, height: 200)
            
        case .JSEmbedCell:
            if lazyLoadedCellHeight.index(forKey: indexPath) != nil{
                
                return lazyLoadedCellHeight[indexPath]!
                
            }else{
                
                return CGSize(width: targetSize.width, height: 40)
            }
            
        case .TwitterCell:
            
            if let tweetD = layout[indexPath.section][indexPath.row].tweet{
                
                let height = TWTRTweetTableViewCell.height(for: tweetD, style: .compact, width: targetSize.width, showingActions: false) //- self.margin.Left - self.margin.Right
                
                let size  = CGSize(width: targetSize.width, height: height)
                
                lazyLoadedCellHeight[indexPath] = size
                return  size
                
            }else{
                return .zero
            }
            
        case .BrightCoveCell:
            return CGSize(width: targetSize.width, height: 200)
            
        case .QuestionandAnswerCell:
            
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .BlockQuoteCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .QuoteCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .BigfactCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .QuestionElementCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .AnswerElementCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .BlurbElementCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .UrlEmbedCell:
            return CGSize(width: targetSize.width, height: 200)
            
        case .SocialShareCell:
            return CGSize(width: targetSize.width, height: 70)
            
        case .GalleryCell:
            return CGSize(width: targetSize.width, height: 255)
            
        case .RatingCell:
            
            return CGSize(width: targetSize.width, height: 25)
            
        case .TitleElementCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            return calculatedSize!
            
        case .KeyEventCell:
            return CGSize(width: targetSize.width, height: 30)
            
        case .StoryCardsSorterCell:
            return CGSize(width: targetSize.width, height: 80)
            
        case .AlsoReadCell:
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .ExplainerHeaderImageCell:
            return CGSize(width: targetSize.width, height: 300)
            
        case .ExplainerTitleCell:
            let currentSizingCell = sizingCell as? ExplainerTitleCell
            
            currentSizingCell?.configure(headline: story?.headline, element: storyElement, index: indexPath.row)
            
            let calculatedSize = currentSizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .storyTableElementCell:
            
            if let value = cachedHeightsForTableStoryElement[indexPath]{
                return CGSize.init(width: targetSize.width, height: value + 45)
            }
            
            return CGSize.init(width: targetSize.width, height: 400 + 45)
            
        case .BitGravityCell:
            
            return CGSize.init(width: targetSize.width, height: 200)
            
        case .ExplainerSummaryCell:
            
            sizingCell?.configure(data: storyElement)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
            
        case .StoryDetailsTagElementCell:
            
            sizingCell?.configure(data:story)
            let calculatedSize = sizingCell?.calculateHeight(targetSize: targetSize)
            self.heightCache[indexPath] = calculatedSize
            return calculatedSize!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //if callback is implemented in the controller then pass the control to Controller else continue with default implementation
        if let callback = self.selectedCallback{
            callback(layout, indexPath)
            return
        }
        
        let cellType = layout[indexPath.section][indexPath.row].layoutType
        let storyElement = layout[indexPath.section][indexPath.row].storyElement
        
        self.selectedIndexPath = indexPath
        
        switch cellType {
            
        case .StoryDetailHeaderImageCell:
            
            let newStoryElement = CardStoryElement()
            newStoryElement.image_s3_key = self.story?.hero_image_s3_key
            newStoryElement.hero_image_metadata = self.story?.hero_image_metadata
            newStoryElement.title = self.story?.hero_image_caption
            newStoryElement.image_attribution = self.story?.hero_image_attribution
            
            self.showFullScreenImage(currentStoryElement: newStoryElement,for:  .HeroImage)
            
            
        case .BrightCoveCell:
            if let unwrappedStoryElement = storyElement{
                self.brightCoveCellPressed(storyElement:unwrappedStoryElement)
            }
            
        case .StoryImageCell:
            
            self.showFullScreenImage(currentStoryElement: storyElement!,for:  .ListImage)
            
        case .ExplainerTitleCell:
            if let storyElementD = storyElement{
                self.explainerTitleCellPressed(currentStoryElement:storyElementD)
            }
            
        case .BitGravityCell:
            if let storyElementD = storyElement{
                self.bitGravityCellPressed(storyElement: storyElementD)
            }
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0:
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            
        default:
            if self.story?.story_template == .LiveBlog{
                return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            }else{
                return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
            }            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    deinit {
        if let _ = tableCollectionView{
            self.tableCollectionView?.removeObserver(self, forKeyPath: "contentSize", context: &StoryDetailDataSourceAndDelegate.COLLECTIONVIEW_OBS_CONTEXT)
        }
        print("DataSource deinit Called")
    }
}



extension StoryDetailDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Dequeue Reusable Supplementary View
        guard let layout = supplimentaryView else{
            fatalError("Unable to Dequeue Reusable Supplementary View")
        }
        
        var cell : BaseCollectionCell?
        
        let cellType = layout.layoutType

        switch cellType{
            
        default:
            
            if let storyHeaderImageCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: StoryDetailHeaderImageCell.reuseIdentifier, for: indexPath) as? StoryDetailHeaderImageCell {
                // Configure Supplementary View
                
                storyHeaderImageCell.delegate = self
                
                storyHeaderImageCell.configure(data:self.story)
                
                storyHeaderImageCell.updateParallaxOffet(collectionViewBounds: collectionView.bounds)
                
                cell = storyHeaderImageCell
            }
            
        }
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let layout = supplimentaryView, section == 0 else{
            return .zero
        }
        
        let cellType = layout.layoutType
        
        switch cellType{
        case .StoryDetailHeaderImageCell:
            return CGSize(width: collectionView.bounds.width, height: 250)
        
        default:
            return .zero
            
        }
        
    }
}

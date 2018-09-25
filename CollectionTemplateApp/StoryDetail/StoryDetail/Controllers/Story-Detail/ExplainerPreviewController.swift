//
//  ExplainerPreviewController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/24/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class ExplainerPreviewController: BaseController {
    
    var indexCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .white
        
        collectionview.showsHorizontalScrollIndicator = false
        
        return collectionview
    }()
    
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = UIColor(hexString: "#F4F4F4")
        
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.isPagingEnabled = true
        collectionview.isDirectionalLockEnabled = true
        
        return collectionview
    }()
    
    var layoutArray:[[StoryDetailLayout]] = []
    var story:Story!
    
    let loadingQueue = OperationQueue()
    var loadingOperations = [IndexPath : DataLoadOperation]()
    
    var indexCollectionViewHeightConstraint :NSLayoutConstraint?
    var collectionViewTopConstraint:NSLayoutConstraint?
    var margin: MarginD!
    
    var didScrollToInitialIndexPath = false
    var oldInnerCollectionViewYContentOffset:CGFloat = 0
    
    var currentCardIndex:Int = 0{
        didSet{
            if currentCardIndex != oldValue{
                let indexPath = IndexPath(item: currentCardIndex, section: 0)
                self.indexCollectionView.reloadData()
                self.indexCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    override var state: ViewState<Any>?{
        didSet{
            update()
            
            self.loadingQueue.maxConcurrentOperationCount = 1
            
            switch state! {
                
            case .loaded(let storyLayout):
                
                createUI()
                
                guard let layoutArray = storyLayout as? [[StoryDetailLayout]] else{
                    return
                }
                
                if (self.story?.sections.count ?? -1) > 0{
                    self.margin = MarginD(templet: self.story?.story_template ?? .Default)
                }else{
                    self.margin = MarginD(templet: self.story?.story_template ?? .Default)
                }
                
                self.layoutArray = layoutArray
                self.convertAttributtedText(storyDetailLayout: layoutArray, story: self.story)
                
                indexCollectionView.delegate = self
                indexCollectionView.dataSource = self
                collectionView.delegate = self
                collectionView.dataSource = self
                
                if #available(iOS 10.0, *) {
                    collectionView.prefetchDataSource = self
                } else {
                    //Use default collectionView lifecycle
                }
                
                break
                
            case .error(let message):
                if layoutArray.count == 0{
                    self.errorView.displayErrorMessage(message: message)
                }else{
                    self.errorView.isHidden = true
                }
                
                
            default:
                break
            }
        }
    }
    
    required init(story:Story,currentStoryElement:CardStoryElement) {
        super.init()
        
        self.story = story
        self.generateLayout(story: story)
        
        var titleElementsArray:[CardStoryElement] = []
        
        for card in story.cards{
            
            let filtedElemets = card.story_elements.filter({$0.type == storyType.title.rawValue})
            titleElementsArray.append(contentsOf: filtedElemets)
            
        }
        
        self.currentCardIndex = titleElementsArray.index(of: currentStoryElement) ?? 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
       
    }
    
    func createUI(){
        view.addSubview(indexCollectionView)
        view.addSubview(collectionView)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        indexCollectionView.anchor(self.topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        indexCollectionViewHeightConstraint = indexCollectionView.heightAnchor.constraint(equalToConstant: 100)
        indexCollectionViewHeightConstraint?.isActive = true
        
        collectionView.anchor(indexCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionViewTopConstraint = collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 150)
        collectionViewTopConstraint?.isActive = true
        indexCollectionView.register(cellClass: ExplainerCardIndexCell.self)
        collectionView.register(cellClass: ExplainerPreviewCell.self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didScrollToInitialIndexPath{
            let indexPath = IndexPath(item: self.currentCardIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.indexCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            
            didScrollToInitialIndexPath = true
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    private func generateLayout(story:Story){
        self.state = ViewState.loading
        var layoutEngine = LayoutEngine()
        
        layoutEngine.makeExplainerPreviewLayout(story: story) { (layoutArray) in
            self.state = ViewState.loaded(data: layoutArray)
        }
    }
    
    @objc func closePressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func convertAttributtedText(storyDetailLayout:[[StoryDetailLayout]],story:Story){
        StoryModifier.getDisplayText(storyDetailLayout: storyDetailLayout, story: story)
    }
}


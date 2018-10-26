//
//  ImageController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/6/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype


class ImageController: BaseController {
    
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view  = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.backgroundColor = .white
        return view
    }()
    
    var closeButton:UIButton = {
        let view = UIButton()
        view.setImage(AssetImage.crossIcon.image, for: .normal)
        view.imageView?.contentMode = .center
        return view
    }()
    
    lazy var transform3DIdentity: CATransform3D = {
        var identity = CATransform3DIdentity
        identity.m34 = 1 / 1000
        return identity
    }()
    
    var cubeDegree:CGFloat = 90
    
    var imageStoryElements : [CardStoryElement] = []
    var currentStoryElementIndex:Int = 0
    
    var currentDisplayedIndex = 0
//    var margin:MarginD!
    
    override init() {
        super.init()
    }
    
    convenience init(story:Story,currentElement:CardStoryElement,type:ImageStoryElementType) {
        self.init()
//        self.margin = margin
        self.createDataSource(story:story,currentElement:currentElement,type:type)
    }
    
    convenience init(story:Story) {
        self.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        
    }
    
    
    func createDataSource(story:Story,currentElement:CardStoryElement,type:ImageStoryElementType){
        switch type {
            
        case .HeroImage:
            
            for card in story.cards{
                
                let filtedElemets = card.story_elements.filter({$0.type == storyType.image.rawValue})
                imageStoryElements.append(contentsOf: filtedElemets)
            }
            //For Header Element
            imageStoryElements.insert(currentElement, at: 0)
            
            self.currentStoryElementIndex = self.imageStoryElements.index(of: currentElement) ?? 0
            
        case .ListImage:
            for card in story.cards{
                
                let filtedElemets = card.story_elements.filter({$0.type == storyType.image.rawValue})
                imageStoryElements.append(contentsOf: filtedElemets)
            }
            
            self.currentStoryElementIndex = self.imageStoryElements.index(of: currentElement) ?? 0
            
        case .Gallery(let selectedIndex):
            //inner storyElements
            let filtedElemets = currentElement.story_elements.filter({$0.type == storyType.image.rawValue})
            imageStoryElements.append(contentsOf: filtedElemets)
            
            self.currentStoryElementIndex = selectedIndex//self.imageStoryElements.index(of: currentElement) ?? 0
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.currentStoryElementIndex >= 0{
            self.currentDisplayedIndex = self.currentStoryElementIndex
            
            collectionView.scrollToItem(at: IndexPath(item: self.currentStoryElementIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.currentStoryElementIndex = -1
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func createUI(){
        view.addSubview(collectionView)
        view.addSubview(closeButton)

        collectionView.fillSuperview()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(cellClass: FullScreenImageCell.self)
        
        closeButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 40, heightConstant: 40)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        
        let swipeGuesture = UISwipeGestureRecognizer(target: self, action: #selector(closePressed))
        swipeGuesture.direction = .up
        self.collectionView.addGestureRecognizer(swipeGuesture)
    }
    
    @objc func rightButtonPressed(){
        
        currentDisplayedIndex += 1
        if currentDisplayedIndex < self.imageStoryElements.count{
            
         collectionView.scrollToItem(at: IndexPath(item: currentDisplayedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }else{
            currentDisplayedIndex -= 1
        }
        
    }
    
    @objc func leftButtonPressed(){
        
        currentDisplayedIndex -= 1
        if currentDisplayedIndex >= 0{
            
            collectionView.scrollToItem(at: IndexPath(item: currentDisplayedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }else{
            currentDisplayedIndex += 1
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            currentDisplayedIndex = indexPath.row
        }
    }
    
    @objc func closePressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.collectionView.visibleCells
            .flatMap { $0 as? FullScreenImageCell }
            .forEach { [weak self] cell in
                
                self?.animateCells(cell: cell)
        }
        
    }
}
extension ImageController :UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageStoryElements.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageCell = collectionView.dequeueReusableCell(ofType: FullScreenImageCell.self, for: indexPath)
        imageCell.configure(data: self.imageStoryElements[indexPath.row])
        
        return imageCell
    }
    
}


extension ImageController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ImageController{
    func animateCells(cell:FullScreenImageCell){
        let convertedFrame = collectionView.convert(cell.frame, to: collectionView.superview)
        
        let distance = distanceFromCenter(withParentFrame: collectionView.frame, cellFrame: convertedFrame)
        
        let visibleMaxDistance = self.visibleMaxDistance(withParentFrame: collectionView.frame, cellFrame: convertedFrame)
        
        if abs(distance) >=  visibleMaxDistance{
            return
        }
        
        let ratio = distanceRatio(withParentFrame: collectionView.frame, cellFrame: convertedFrame)
        
        cell.adjustAnchorPoint(anchorPoint(withDistanceRatio: ratio))
        cell.layer.transform = transform(withParentFrame: collectionView.frame, cellFrame: convertedFrame)
        
    }
    
    func distanceFromCenter(withParentFrame parentFrame: CGRect, cellFrame: CGRect) -> CGFloat {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        switch layout.scrollDirection {
        case .vertical:   return cellFrame.midY - parentFrame.midY
        case .horizontal: return cellFrame.midX - parentFrame.midX
        }
    }
    
    func visibleMaxDistance(withParentFrame parentFrame: CGRect, cellFrame: CGRect) -> CGFloat {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        switch layout.scrollDirection {
            
        case .vertical:   return parentFrame.midY + cellFrame.height / 2
        case .horizontal: return parentFrame.midX + cellFrame.width / 2
        }
    }
    
    func distanceRatio(withParentFrame parentFrame: CGRect, cellFrame: CGRect) -> CGFloat {
        let distance = distanceFromCenter(withParentFrame: parentFrame, cellFrame: cellFrame)
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        switch layout.scrollDirection {
        case .vertical:   return distance / (parentFrame.height / 2 + cellFrame.height / 2)
        case .horizontal: return distance / (parentFrame.width / 2 + cellFrame.width / 2)
        }
    }
    
    func anchorPoint(withDistanceRatio ratio: CGFloat) -> CGPoint {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        switch layout.scrollDirection {
        case .vertical   where ratio > 0: return CGPoint(x: 0.5, y: 0)
        case .vertical   where ratio < 0: return CGPoint(x: 0.5, y: 1)
        case .horizontal where ratio > 0: return CGPoint(x: 0, y: 0.5)
        case .horizontal where ratio < 0: return CGPoint(x: 1, y: 0.5)
        default: return CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    func transform(withParentFrame parentFrame: CGRect, cellFrame: CGRect) -> CATransform3D {
        
        let _ratio = distanceRatio(withParentFrame: parentFrame, cellFrame: cellFrame)
        let ratio  = _ratio < 0 ? max(-1, _ratio) : min(1, _ratio)
        let easingRatio = ratio
        
        let toDegree: CGFloat = max(0, min(90, cubeDegree))
        let degree: CGFloat
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        switch layout.scrollDirection {
        case .vertical:
            degree = easingRatio * toDegree
            return CATransform3DRotate(transform3DIdentity, degree * .pi / 180, 1, 0, 0)
        case .horizontal:
            degree = easingRatio * -toDegree
            return CATransform3DRotate(transform3DIdentity, degree * .pi / 180, 0, 1, 0)
        }
        
    }
}


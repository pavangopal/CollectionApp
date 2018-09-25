//
//  TableStoryElement.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 20/06/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Quintype

@objc protocol TableStoryElementDelegate{
    func registerObserverForView(collectionView:UICollectionView, cell:TableStoryElement)
}

class TableStoryElement: BaseCollectionCell {
    
    var hasPerformedConstraints:Bool = false
    @NSCopying var tableData:TableData!
    var holdingTableData:TableData!
    var headerTableData:TableData!
    var originalTableData:TableData?
    var isLoaded:Bool = false
    var offset:Int = 0
    var limit:Int = 10
    
    weak var tableDelegate:TableStoryElementDelegate?
    
    var collectionView:UICollectionView = {
        let bidirectionalCollectionLayout = BidirectionCollectionLayout.init()
        bidirectionalCollectionLayout.headerReferenceSize = CGSize.zero
        let collectionViewd:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: bidirectionalCollectionLayout)
        collectionViewd.backgroundColor = UIColor.white
        collectionViewd.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionViewd
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        offset = -limit
        registerCells()
        
    }
    
    var cachedWidths:[Int:CGFloat] = [:]
    var cachedHeights:[Int:CGFloat] = [:]
    var cachedHeaderWidths:[Int:CGFloat] = [:]
    var cachedHeaderHeights:[Int:CGFloat] = [:]
    
    func registerCells(){
        self.collectionView.register(TableStoryElementItemCell.self, forCellWithReuseIdentifier: "TableStoryElementItemCell")
        self.collectionView.register(TableStoryElementHeaderCell.self, forCellWithReuseIdentifier: "TableStoryElementHeaderCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerCells()
    }
    
    override func updateConstraints(){
        if !hasPerformedConstraints{
            
            hasPerformedConstraints = !hasPerformedConstraints
            createConstraints()
            addObservers()
        }
        super.updateConstraints()
    }
    
    func addObservers(){
        self.tableDelegate?.registerObserverForView(collectionView: self.collectionView, cell: self)
    }
 
    
    func computeData(datap:TableData){
        let data = datap.copy() as! TableData
        data.parsedData.insert(contentsOf: self.headerTableData.parsedData, at: 0)
        for i in 0..<data.parsedData.count{
            
            for j in 0..<data.parsedData[i].count{
                let data = data.parsedData[i][j]
                let fontd = i == 0 ? UIFont.boldSystemFont(ofSize: 12) : UIFont.systemFont(ofSize: 12)
                let widthValue = ceil(data.width(font: fontd))
                let width = ceil(widthValue > 120 ? 120 : widthValue)
                if let valueIsPresent = self.cachedWidths[j]{
                    if valueIsPresent < width{
                        self.cachedWidths[j] = width
                    }
                }
                else{
                    self.cachedWidths[j] = width
                }
                
                let heightValue = ceil(data.height(fits: width - 16, font: UIFont.systemFont(ofSize: 12)))
                if let heightValuePresent = self.cachedHeights[i]{
                    if heightValuePresent < heightValue{
                        self.cachedHeights[i] = heightValue
                    }
                }
                else{
                    self.cachedHeights[i] = heightValue
                }
                
            }
            
        }
    }
   
    
    func configure(datam:TableData?){
        
        guard let datap = datam else{return}
         self.tableData = datap
        self.headerTableData = TableData()
        self.headerTableData.content = self.tableData.content
        self.headerTableData.contentType = self.tableData.contentType
        self.headerTableData.parsedData = [self.tableData.parsedData.removeFirst()]
       

        
        if !isLoaded{
            if limit > tableData.parsedData.count{
                limit = tableData.parsedData.count
            }
           
            isLoaded = !isLoaded
            holdingTableData = TableData()
            holdingTableData.content = tableData.content
            holdingTableData.contentType = tableData.contentType
            prepareHoldingData()
             self.collectionView.reloadData()
        }
        
        computeData(datap: holdingTableData)
       // computeHeaderData(data: self.headerTableData)
       
    }
    
    func prepareHoldingData(){
        kickNext()
        if offset + limit < tableData.parsedData.count{
            holdingTableData.parsedData = Array(tableData.parsedData[offset..<offset + limit])
        }
        else{
            holdingTableData.parsedData = Array(tableData.parsedData[offset..<tableData.parsedData.count])
        }
        
      //  holdingTableData.parsedData.insert(headerTableData.parsedData.first!, at: 0)
    }
    
    func kickNext(){
        if offset >= tableData.parsedData.count{
            return
        }
        
        if (offset + limit) - (tableData.parsedData.count) == 0{
            return
        }
        
        if offset + limit < tableData.parsedData.count{
            offset = offset + limit
        }
        else{
            offset = offset + tableData.parsedData.count - offset
        }
    }
    
    func kickPrev(){
        if offset > 0{
            offset = offset - limit
        }
    }
    
  @objc func goNext(){
        kickNext()
        
        if offset >= tableData.parsedData.count{
            return
        }
        if offset + limit < tableData.parsedData.count{
            holdingTableData.parsedData = Array(tableData.parsedData[offset..<offset + limit])
        }
        else{
            holdingTableData.parsedData = Array(tableData.parsedData[offset..<tableData.parsedData.count])
        }
       // holdingTableData.parsedData.insert(headerTableData.parsedData.first!, at: 0)
        self.cachedHeights.removeAll()
        self.cachedWidths.removeAll()
        computeData(datap: holdingTableData)
        collectionView.reloadData()
    }
    
    @objc func goPrev(){
        kickPrev()
        if offset - limit >= 0{
            holdingTableData.parsedData = Array(tableData.parsedData[offset..<offset + limit])
        }
        else{
            
          holdingTableData.parsedData = Array(tableData.parsedData[0..<limit])
        }
        
     //   holdingTableData.parsedData.insert(headerTableData.parsedData.first!, at: 0)
        
        computeData(datap: holdingTableData)
        collectionView.reloadData()
    }
    
    func loadTopHeaderCell() -> UIView{
        let headerCell = TableStoryElementTopHeaderCell.init(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))

        headerCell.translatesAutoresizingMaskIntoConstraints = false
        return headerCell
    }
    
    func createConstraints(){
        self.contentView.addSubview(self.collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let topHeaderCell = self.loadTopHeaderCell() as! TableStoryElementTopHeaderCell
        self.contentView.addSubview(topHeaderCell)
        topHeaderCell.prevButton.addTarget(self, action: #selector(TableStoryElement.goPrev), for: .touchUpInside)
        topHeaderCell.nextButton.addTarget(self, action: #selector(TableStoryElement.goNext), for: .touchUpInside)
        topHeaderCell.setNeedsUpdateConstraints()
        topHeaderCell.updateConstraintsIfNeeded()
        topHeaderCell.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        topHeaderCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        topHeaderCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        topHeaderCell.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        topHeaderCell.searchTF.delegate = self
        
        self.collectionView.topAnchor.constraint(equalTo: topHeaderCell.bottomAnchor, constant: 0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    deinit {
        print("Table Element deinited")
    }
}
extension TableStoryElement:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return holdingTableData.parsedData.count + headerTableData.parsedData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return headerTableData.parsedData[section].count
        }
        
        return holdingTableData.parsedData[section - 1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellItem:UICollectionViewCell?
        if indexPath.section == 0{
            let headerCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TableStoryElementHeaderCell", for: indexPath) as! TableStoryElementHeaderCell
            headerCell.setNeedsUpdateConstraints()
            headerCell.updateConstraintsIfNeeded()
            headerCell.configure(inputData: headerTableData.parsedData[indexPath.section][indexPath.item])
            headerCell.contentView.backgroundColor = UIColor.white
            cellItem = headerCell
            
        }
        else{
            let color = indexPath.section % 2 == 0 ? UIColor.lightGray : UIColor.white
            
            let itemCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TableStoryElementItemCell", for: indexPath) as! TableStoryElementItemCell
            itemCell.setNeedsUpdateConstraints()
            itemCell.updateConstraintsIfNeeded()
            itemCell.configure(inputData: holdingTableData.parsedData[indexPath.section - 1][indexPath.item])
            itemCell.contentView.backgroundColor = color
            cellItem = itemCell
        }
        return cellItem!
    }
    
    
}

extension TableStoryElement:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
              return CGSize.init(width: cachedWidths[indexPath.item]! + 16, height: cachedHeights[indexPath.section]!)
        }
        
        return CGSize.init(width: cachedWidths[indexPath.item]! + 16, height: cachedHeights[indexPath.section - 1]! + 16)
    }
}

extension TableStoryElement:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchTerm = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        if searchTerm == ""{
            //reset
            if self.originalTableData != nil{
                isLoaded = !isLoaded
                self.originalTableData!.parsedData.insert(contentsOf: self.headerTableData.parsedData, at: 0)
                limit = 10
                offset = -limit
                self.configure(datam: self.originalTableData!)
                self.originalTableData = nil
            }
        }
        else{
            if let _ = self.originalTableData{
            
            }
            else{
                self.originalTableData = self.tableData.copy() as? TableData
            }
           
            self.tableData.parsedData = self.originalTableData!.parsedData.filter({ (data) -> Bool in
                return data.joined(separator: " ").contains(searchTerm)
                
            })
            limit = 10
            if limit > tableData.parsedData.count{
                limit = tableData.parsedData.count
            }
            
            offset = -limit
            holdingTableData = TableData()
            holdingTableData.content = tableData.content
            holdingTableData.contentType = tableData.contentType
            prepareHoldingData()
            self.collectionView.reloadData()
            
        }
        
        return true
    }
}


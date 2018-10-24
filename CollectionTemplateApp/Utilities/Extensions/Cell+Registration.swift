//
//  Cell+Registration.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/30/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    
    static var reuseIdentifier: String { get }
    
}

extension ReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableView {
    
    func register<CellClass: UITableViewCell>(cellClass: CellClass.Type) {
    
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueReusableCell<CellClass: UITableViewCell>(ofType cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass {
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! CellClass
    }
    
}

extension UICollectionView {
    
    func register<CellClass: UICollectionViewCell>(cellClass: CellClass.Type)  {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)

    }
    
    func dequeueReusableCell<CellClass: UICollectionViewCell>(ofType cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass {
        
        let cell = dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! CellClass
        
        return cell
    }
}

extension UITableViewCell : ReusableView { }
extension UICollectionViewCell: ReusableView { }



extension UICollectionViewCell : CellBackgroundProtocol{}

protocol CellBackgroundProtocol{}

extension CellBackgroundProtocol where Self : UICollectionViewCell {

    
}


extension UICollectionView {
    func hasItemAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}














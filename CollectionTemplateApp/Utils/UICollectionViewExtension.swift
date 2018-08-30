//
//  UICollectionViewExtension.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 8/13/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

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

//    func dequeueReusableCell<CellClass: UICollectionViewCell>(ofType cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass {
//        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! CellClass
//    }

}

extension UITableViewCell : ReusableView { }
extension UICollectionViewCell: ReusableView { }


extension UICollectionView {
    func hasItemAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}

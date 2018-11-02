//
//  MenuController.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 10/30/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol MenuControllerDelegate: class {
    func itemSelectedAtIndex(menuArray:[Menu],index:Int)
    func linkSelected(menu:Menu)
}

class MenuController: BaseController {
    
    var menu:[Menu] = []
    
    var sortedMenu:[SideMenuViewModel] = []{
        didSet{
            if sortedMenu.count == menu.count{
                tableView.reloadData()
            }
        }
    }
    
    lazy var tableView:UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.separatorColor = UIColor.lightGray
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass: SideMenuCell.self)
        tableView.register(cellClass: ParentMenuCell.self)
        return tableView
    }()
    
    lazy var dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()
    var dismissCompletionHandler:(() -> Void)!
    
    weak var delegate:MenuControllerDelegate?
    var tabViewLeadingConstraint:NSLayoutConstraint?
    
    convenience init(menu:[Menu]) {
        self.init()
        self.menu = menu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        createViews()
        prepareDataSource()
    }
    func createViews() {
        self.view.backgroundColor = .clear
        self.view.addSubview(dismissView)
        self.view.addSubview(tableView)
        
        
        let trailingOffset:CGFloat = -UIScreen.main.bounds.width*0.8
        
        tableView.anchor(self.view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: UIScreen.main.bounds.width*0.8, heightConstant: 0)
        
        tabViewLeadingConstraint = tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: trailingOffset)
        tabViewLeadingConstraint?.isActive = true
        
        dismissView.anchor(self.view.topAnchor, left: nil, bottom: self.view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: UIScreen.main.bounds.width * 0.2, heightConstant: 0)
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.dissmissViewTapped(sender:)))
        dismissView.addGestureRecognizer(tapGuesture)
    }
    
    
    func swipeLeft() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.dissmissViewSwipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tabViewLeadingConstraint?.constant = 0
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            if finished {
                self.dismissView.alpha = 0.1
            }
        }
    }
    
    @objc func dissmissViewTapped(sender:UITapGestureRecognizer){
        self.dismissWithAnimation()
    }
    
    @objc func dissmissViewSwipeLeft(sender:UISwipeGestureRecognizer){
        if sender.direction == UISwipeGestureRecognizerDirection.left{
            self.dismissWithAnimation()
        }
    }
    
    @objc func dismissWithAnimation() {
        self.dismissView.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            
            let trailingOffset:CGFloat = -UIScreen.main.bounds.width*0.8
            self.tabViewLeadingConstraint?.constant = trailingOffset
            
            self.view.layoutIfNeeded()
        }) { (finished) in
            if self.dismissCompletionHandler != nil {
                self.dismissCompletionHandler()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func prepareDataSource(){
        let parentMenuArray = menu.filter({$0.parent_id == nil})
        
        parentMenuArray.forEach { (parentMenu) in
            let subMenuArray =  menu.filter({$0.parent_id == parentMenu.id})
            
            let singleMenuSorter = SideMenuViewModel(parentMenu: parentMenu, subMenus: subMenuArray)
            sortedMenu.append(singleMenuSorter)
        }
    }
}

extension MenuController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var count = sortedMenu.count
        
        for section in sortedMenu {
            count += section.subMenus.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(ofType: ParentMenuCell.self, for: indexPath)
            cell.configure(menu: sortedMenu[section], sectionIndex: section)
            cell.delegate = self
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(ofType: SideMenuCell.self, for: indexPath)
            cell.configure(menu: sortedMenu[section].subMenus[row - 1])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)

        self.dismissView.alpha = 0
        
        var menuArray:[Menu] = []
        menuArray = sortedMenu[section].subMenus
        let selectedMenu:Menu!
        if row == 0{
            selectedMenu = sortedMenu[section].parentMenu!
            menuArray.insert(selectedMenu, at: 0)
        }else{
            menuArray.insert(sortedMenu[section].parentMenu!, at: 0)
            selectedMenu = sortedMenu[section].subMenus[row-1]
        }
        
        let selectedIndex = menuArray.firstIndex(of: selectedMenu) ?? 0
        
        self.dismissWithAnimation()
        
//        self.delegate?.itemSelectedAtIndex(menuArray: menuArray, index: selectedIndex)
        
        let homeController = HomeController(menuArray: menuArray)
        homeController.navigationBar.setBackHambergerMenu()
        homeController.selectedIndex = selectedIndex
        let homeNavigationController = self.navigationController?.presentingViewController as? UINavigationController
        homeNavigationController?.pushViewController(homeController, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        // Header has fixed height
        if row == 0 {
            return 50.0
        }
        
        return sortedMenu[section].isCollapsed ? 0 : 44.0
    }
    
}


extension MenuController : ParentMenuCellDelegate {
    func shouldToggle(headerView: ParentMenuCell, sectionIndex: Int) {
        let section = sectionIndex
        let collapsed = sortedMenu[section].isCollapsed
        
        // Toggle collapse
        sortedMenu[section].isCollapsed = !collapsed
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        let end = start + sortedMenu[section].subMenus.count
        
        tableView.beginUpdates()
        for i in start ..< end + 1 {
            tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
        }
        tableView.endUpdates()
    }
}

extension MenuController{

    // MARK: - Helper Functions
    //TODO: - Create cleaner implementation
    
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in sortedMenu {
            indices.append(index)
            index += section.subMenus.count + 1
        }
        
        return indices
    }
    
}


//
//  SideMenuController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/21/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

protocol SideMenuControllerDelegate: class {
    func itemSelectedAtIndex(slug:String,index:Int)
    func linkSelected(menu:Menu)
}

class SideMenuController: BaseController {
    
    var dismissCompletionHandler:(() -> Void)!
    
    //created tableview for a change because I'm forgetting how to use it.
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ThemeService.shared.theme.primarySectionColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
//        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 50
        
        tableView.separatorColor = UIColor(hexString: "#624577")
        tableView.register(cellClass: SideMenuCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    lazy var dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0
        
        return view
    }()
    
    var tabViewTrailingConstraint:NSLayoutConstraint?
    weak var delegate:SideMenuControllerDelegate?
    
    var menuArray:[Menu] = []
    
    required init(menuArray:[Menu]) {
        super.init()
        self.menuArray = menuArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func swipeRight(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.dissmissViewSwipeRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRight()
        self.view.backgroundColor = .clear
        self.view.addSubview(dismissView)
        self.view.addSubview(tableView)
        
        let trailingOffset = UIScreen.main.bounds.width * 0.8
        
        tableView.anchor(self.view.topAnchor, left: nil, bottom: self.view.bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: trailingOffset, heightConstant: 0)
        
        tabViewTrailingConstraint = tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: trailingOffset)
        tabViewTrailingConstraint?.isActive = true
        
        dismissView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: UIScreen.main.bounds.width * 0.2, heightConstant: 0)
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.dissmissViewTapped(sender:)))
        dismissView.addGestureRecognizer(tapGuesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tabViewTrailingConstraint?.constant = 0
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
    
    @objc func dissmissViewSwipeRight(sender:UISwipeGestureRecognizer){
        if sender.direction == UISwipeGestureRecognizerDirection.right{
                 self.dismissWithAnimation()
        }
   
    }
    @objc func dismissWithAnimation() {
        self.dismissView.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            
            let trailingOffset = UIScreen.main.bounds.width * 0.8
            self.tabViewTrailingConstraint?.constant = trailingOffset
            
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
}

extension SideMenuController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: SideMenuCell.self, for: indexPath) 
        cell.configure(menu: menuArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismissView.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            
            let trailingOffset = UIScreen.main.bounds.width * 0.8
            self.tabViewTrailingConstraint?.constant = trailingOffset
            
            self.view.layoutIfNeeded()
        }) { (finished) in
            if let slug = self.menuArray[indexPath.row].section_slug{
                self.delegate?.itemSelectedAtIndex(slug: slug, index:indexPath.row)
            }else{
                
                let linkMenu = self.menuArray[indexPath.row]
                self.delegate?.linkSelected(menu: linkMenu)
                
            }
            if self.dismissCompletionHandler != nil {
                self.dismissCompletionHandler()
            }
        }
    }
    
}

//
//  BaseController.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 10/24/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit
import Quintype

class BaseController: UIViewController , DataLoading,ErrorViewDelegate{
        
    let loadingView = LoadingView()
    let errorView = ErrorView()
    
    var state: ViewState<Any>? {
        didSet {
            update()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func addStateHandlingView(`in` view:UIView){
        
        self.view.addSubview(loadingView)
        self.view.addSubview(errorView)
        loadingView.fillSuperview()
        errorView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        errorView.fillSuperview()
        hideViewsInitially()
        errorView.delegate = self
    }
  
    
    func hideViewsInitially(){
        errorView.isHidden = true
        loadingView.isHidden = true
    }

    
    func reTryRequested() {
        //implemented in subclasses
    }
}


protocol DataLoading{
    associatedtype Mytype
    
    
    var state: ViewState<Mytype>? {get set}
    var loadingView:LoadingView{get}
    var errorView:ErrorView{get}
    
    func update()
    
}

enum ViewState<Content> {
    case loading
    case loaded(data: Content)
    case error(message: String)
    case needsReloading
}


extension DataLoading where Self:UIViewController {
    
    func update() {
        guard let unwrappedState = state else{
            return 
        }
        
        switch unwrappedState {
        case .loading:
            
            loadingView.isHidden = false
            errorView.isHidden = true
            
            loadingView.activityIndicator.startAnimating()
            self.view.bringSubview(toFront: loadingView)
            
        case .error(_):
            
            loadingView.isHidden = true
            errorView.isHidden = false
            
            self.view.bringSubview(toFront: errorView)
            
        case .loaded:
            
            loadingView.isHidden = true
            errorView.isHidden = true
            
        default:
            break
        }
    }
}

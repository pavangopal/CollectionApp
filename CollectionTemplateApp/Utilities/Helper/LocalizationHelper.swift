//
//  LocalizationHelper.swift
//  CoreApp-iOS
//
//  Created by Pavan Gopal on 3/17/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit

class LocalizationHelper:NSObject{
    
    static let BUNDLE_EXTENSION = "lproj"
    static let sharedHelper:LocalizationHelper = LocalizationHelper.init()
    fileprivate var myBundle:Bundle = Bundle.main
    
    override init() {
        super.init()
    }
    
    func localizedStringForKey(_ key:String) -> String{
        
        return myBundle.localizedString(forKey: key, value: "", table: nil)
    }
    
    func setLanguage(_ language:String){
        if let path = Bundle.main.path(forResource: language, ofType: LocalizationHelper.BUNDLE_EXTENSION){
            
            if let bundled = Bundle.init(path: path){
                myBundle = bundled
            }
            else{
                myBundle = Bundle.main
            }
            
        }
        else{
            myBundle = Bundle.main
        }
        
        
    }
    
}

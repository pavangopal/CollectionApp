//
//  MulticastDelegate.swift
//  CoreApp-iOS
//
//  Created by Albin.git on 5/4/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation

class MulticastDelegate<T>: NSObject {
    
    open var weakDelegates:NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func addDelegate(delegate:T){
        guard !weakDelegates.contains(delegate as AnyObject?) else{
            return
        }
        weakDelegates.add(delegate as AnyObject?)
    }
    
    func removeDelegate(delegate:T){
        if weakDelegates.contains(delegate as AnyObject?){
            weakDelegates.remove(delegate as AnyObject?)
        }
    }
    
    func invoke(invokation:(T) -> ()) {
        
        self.weakDelegates.allObjects
            .flatMap{$0 as? T}
            .forEach { (delegate) in
                invokation(delegate)
        }
    }
}

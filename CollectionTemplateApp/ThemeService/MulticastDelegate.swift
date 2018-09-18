//
//  MulticastDelegate.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/13/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import UIKit


class MulticastDelegate<T>: NSObject {
    
    var weakDelegates:NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func addDelegate(delegate:T){
        weakDelegates.add(delegate as AnyObject?)
    }
    
    func removeDelegate(delegate:T){
        if weakDelegates.contains(delegate as AnyObject?){
            weakDelegates.remove(delegate as AnyObject?)
        }
    }
    
    
    func invoke(invokation:(T) -> ()){
        let enumerator = self.weakDelegates.objectEnumerator()
        
        while let delegate: AnyObject = enumerator.nextObject() as AnyObject? {
            invokation(delegate as! T)
        }
    }
}

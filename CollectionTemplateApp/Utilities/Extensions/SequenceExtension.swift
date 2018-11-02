//
//  SequenceExtension.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 11/2/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

extension Sequence {
    
    func count(_ shouldCount: (Iterator.Element) -> Bool) -> Int {
        
        var count = 0
        
        for element in self {
            
            if shouldCount(element) {
                
                count += 1
                
            }
            
        }
        
        return count
        
    }
    
}

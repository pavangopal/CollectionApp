//
//  Paging.swift
//  CollectionTemplet
//
//  Created by Pavan Gopal on 7/26/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

public struct Page{
    
    public enum PagingStatus:Int{
        case NotPaging
        case Paging
        case LastPage
        case Errored
    }
    
    public var offset:Int = 0
    public var limit:Int = 0
    public var status:PagingStatus = PagingStatus.NotPaging
    
    public init(offsetPara:Int = 0, limitPara:Int = 0) {
        
        self.limit = limitPara
        if offsetPara == 0{
            self.offset =  -limitPara
        }
        else{
            self.offset = -limitPara
            self.offset += offsetPara
        }
    }
    public mutating func kick(){
        
        self.offset += self.limit
    }
    
    public  mutating func minus(){
        self.offset -= self.limit
    }
}

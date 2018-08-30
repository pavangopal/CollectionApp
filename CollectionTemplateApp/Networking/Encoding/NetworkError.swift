//
//  NetworkError.swift
//  CollectionTemplet
//
//  Created by Pavan Gopal on 7/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

public enum NetworkError : Error {
    
    case parametersNil
    case encodingFailed
    case missingURL
    case NoInternet
    case NoData
    case ParsingError
    case Paging
    
    case Custom(message:String)
    
    var errorMessage:String{
        
        switch self {
            
        case .parametersNil:
            return "Parameters were nil."
            
        case .encodingFailed:
            return "Parameter encoding failed."
            
        case .missingURL:
            return "URL is nil."
        case .NoInternet:
            return "Please check your network connection."
        case .NoData:
            return "Response returned with no data to decode."
        case .ParsingError:
            return "Parsing Error."
        case .Paging:
            return "Paging"
        case .Custom(let message):
            return message
            
            
        }
    }
}

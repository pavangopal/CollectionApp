//
//  EndPointType.swift
//  CollectionTemplet
//
//  Created by Pavan Gopal on 7/23/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}


//
//  NSObjectExtension.swift
//  CollectionTemplateApp
//
//  Created by Pavan Gopal on 9/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

extension NSObject {
    class func swiftClassFromString(className: String) -> AnyClass! {
        if let appName: String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String {
            let fAppName = appName.replacingOccurrences(of: "-", with: "_", options: .literal, range: nil)
            return NSClassFromString("\(fAppName).\(className)")
        }
        return nil;
    }
}

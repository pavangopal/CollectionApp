//
//  SocialShare.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/7/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import Quintype

protocol SocialPlatform {
    func share(story:Story,controller:UIViewController)
}


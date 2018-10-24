//
//  ThemeService.swift
//  PodcastPlayer
//
//  Created by Pavan Gopal on 5/3/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation
import UIKit


protocol Themeable:class {
    func applyTheme(theme: Theme)
}

public class ThemeService {
    
    static let shared = ThemeService()
    
    var imageQuality:ImageQuality = ImageQuality.Medium{
        willSet{
            if imageQuality.rawValue != newValue.rawValue{
                UserDefaults.standard.set(newValue.rawValue, forKey: kImageQuality)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    var theme: Theme = PrimaryTheme() {
        didSet {
            self.multicastDelegate.invoke(invokation: { (delegate:Themeable) in
                delegate.applyTheme(theme: theme)
            })
        }
    }
    
    var multicastDelegate:MulticastDelegate<Themeable>!
    
    private init() {
        multicastDelegate = MulticastDelegate<Themeable>()
    }
    
    func addThemeable(themable: Themeable, applyImmediately: Bool = false) {
        
        self.multicastDelegate.addDelegate(delegate: themable)
        
        if applyImmediately{
            self.multicastDelegate.invoke(invokation: { (delegate:Themeable) in
                delegate.applyTheme(theme: theme)
            })
        }
    }
    
    func removeThemeable(themable: Themeable){
        self.multicastDelegate.removeDelegate(delegate: themable)
    }
    
    private func applyTheme() {
        // Update styles via UIAppearance
        
        UINavigationBar.appearance().isTranslucent = theme.navigationBarTranslucent
        UINavigationBar.appearance().barTintColor = theme.navigationBarTintColor
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: theme.navigationTitleColor,
            NSAttributedStringKey.font: theme.navigationTitleFont
        ]
        
        // The tintColor will trickle down to each view
        if let window = UIApplication.shared.windows.first {
            window.tintColor = theme.tintColor
        }
        
        self.multicastDelegate.invoke { (delegate:Themeable) in
            delegate.applyTheme(theme: theme)
        }
    }
    
}


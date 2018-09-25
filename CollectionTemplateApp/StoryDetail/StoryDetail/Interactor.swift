//
//  Interactor.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 2/15/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

class Interactor: UIPercentDrivenInteractiveTransition ,UIGestureRecognizerDelegate{
    
    var viewController: UIViewController?
    var presentViewController: UIViewController?
    var pan: UIPanGestureRecognizer!
    
    var shouldComplete = false
    var lastProgress: CGFloat?
    
    func attachToViewController(viewController: UIViewController, withView view: UIView, presentViewController: UIViewController?) {
        self.viewController = viewController
        self.presentViewController = presentViewController
        pan = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        
        //Represents the percentage of the transition that must be completed before allowing to complete.
        let percentThreshold: CGFloat = 0.2
        //Represents the difference between progress that is required to trigger the completion of the transition.
        let automaticOverrideThreshold: CGFloat = 0.03
        
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        let dragAmount: CGFloat = (presentViewController == nil) ? screenHeight : -screenHeight
        var progress: CGFloat = translation.y / dragAmount
        
        progress = fmax(progress, 0)
        progress = fmin(progress, 1)
        
        switch pan.state {
            
        case .began:
            if let presentViewController = presentViewController {
                
                viewController?.present(presentViewController, animated: true, completion: nil)
            } else {
                viewController?.dismiss(animated: true, completion: nil)
            }
            
        case .changed:
            guard let lastProgress = lastProgress else {return}
            
            // When swiping back
            if lastProgress > progress {
                shouldComplete = false
                // When swiping quick to the right
            } else if progress > lastProgress + automaticOverrideThreshold {
                shouldComplete = true
            } else {
                // Normal behavior
                shouldComplete = progress > percentThreshold
            }
            
            update(progress)
            
        case .ended, .cancelled:
            if pan.state == .cancelled || shouldComplete == false {
                cancel()
            } else {
                finish()
            }
            
        default:
            break
        }
        
        lastProgress = progress
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if let sv = gestureRecognizer.view as? UITableView{
            return sv.contentOffset.y <= 0
        }else{
            return true
        }
    }
}


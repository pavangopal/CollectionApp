//
//  Animator.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 11/6/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation

class Animator:NSObject,UIViewControllerAnimatedTransitioning{
    
    let duration = 0.4
    var presenting = true
    var originalFrame = CGRect.zero
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originalFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originalFrame
        
        let xScaleFactor = presenting ?
            
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting{
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)
        
        herbView.alpha = self.presenting ? 1 : 1
        
        UIView.animate(withDuration: duration, delay: 0.02, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            herbView.alpha = self.presenting ? 1 : 0
        }) { (isCompleted) in
            transitionContext.completeTransition(isCompleted)
        }
        
        
    }
    
}

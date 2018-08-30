//
//  MailComposer.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/3/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//


import UIKit
import MessageUI

class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    
    var controller:UIViewController!
    var composeVC = MFMailComposeViewController()
    
    required init(recipients:[String],ccRecipient:[String],subject:String?,body:String?,controller:UIViewController) {
        super.init()
        self.controller = controller
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(recipients)
        composeVC.setCcRecipients(ccRecipient)
        
        if let subjectD = subject {
            composeVC.setSubject(subjectD)
        }
        
        if let bodyD = body {
            composeVC.setMessageBody(bodyD, isHTML: false)
        }
        
        // Present the view controller modally.
        controller.present(composeVC, animated: true, completion: nil)
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print(error?.localizedDescription ?? "")
            
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}

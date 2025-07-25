//
//  EnquraViewController.swift
//  Runner
//
//  Created by Taha on 26.03.2024.
//

import UIKit
import PPEnQualifyModule
import Adjust

class EnquraViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                PPModule.setNavigationConfiguration(navigationController: appDelegate.navigationController.topViewController)
            }
        }
        PPModule.startEnQualifySDK(identifier: "com.enqura.PiapiriEnQualifyModule", sender: self, isProd: true) 
    }

    func cleanupThemeSettings() {
        self.overrideUserInterfaceStyle = .unspecified
        self.navigationController?.overrideUserInterfaceStyle = .unspecified
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            if let window = windowScene?.windows.first {
                window.overrideUserInterfaceStyle = .unspecified
                window.rootViewController?.overrideUserInterfaceStyle = .unspecified
            }
        }   
    }
}

extension EnquraViewController: PPModuleDelegate {
    func moduleExitedSuccess() {
        print(#function)
        cleanupThemeSettings()
        
        if #available(iOS 13.0, *) {
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                PPModule.setNavigationConfiguration(navigationController: appDelegate.navigationController.topViewController)
            }
        }
    }
    
    func moduleExitedFailure() {
        print(#function)
        cleanupThemeSettings()
    }
    
    func moduleStartFailure() {
        print(#function)
        cleanupThemeSettings()
    }

    func adjustEventTriggered(eventToken: String) {
         switch eventToken {
         case "onWelcome":
             trackEvent(eventName:"nlaouo")
         case "onWhatsWaiting":
             trackEvent(eventName:"lrxjka")
         case "onFormView":
             trackEvent(eventName:"9cjj12")
         case "onOTP":
             trackEvent(eventName:"l35o1c")
         case "onIdDetail":
             trackEvent(eventName:"5ttbnz")
         case "onFaceRecognition":
             trackEvent(eventName:"ah7unw")
         case "onInvestorInfo":
             trackEvent(eventName:"5ig883")
         case "onContractApproval":
             trackEvent(eventName:"sp1gt8")
         case "onAppointment":
             trackEvent(eventName:"ezn0gu")
         case "onVideoCallInfo":
             trackEvent(eventName:"x5f84u")
         case "onVideoCallWaiting":
             trackEvent(eventName:"5282di")
         case "onVideoCallEnd":
             trackEvent(eventName:"ys3bsp")
         default:
             print("Unknown event: \(eventToken)")
         }
     }
    
    
    func trackEvent(eventName:String) {
        guard let event = ADJEvent(eventToken: eventName) else {
        print("Error creating event for \(self)")
        return
        }
        Adjust.trackEvent(event)
        }
}

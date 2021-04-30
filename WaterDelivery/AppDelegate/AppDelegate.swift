//
//  AppDelegate.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initialSetup()
        return true
    }
}

extension AppDelegate {
    /// Setting the initial data
    func initialSetup(){
        IQKeyboardManager.shared.enable = true
    }
}


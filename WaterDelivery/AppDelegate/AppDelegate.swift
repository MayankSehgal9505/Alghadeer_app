//
//  AppDelegate.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initialSetup()
        GMSServices.provideAPIKey("AIzaSyDWK2zFda82S7Dgg0vo1u7ybjpfJcQY6q8")
        GMSPlacesClient.provideAPIKey("AIzaSyDWK2zFda82S7Dgg0vo1u7ybjpfJcQY6q8")
        return true
    }
}

extension AppDelegate {
    /// Setting the initial data
    func initialSetup(){
        IQKeyboardManager.shared.enable = true
    }
}


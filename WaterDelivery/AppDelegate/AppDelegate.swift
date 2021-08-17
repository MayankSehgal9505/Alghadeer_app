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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initialSetup()
        GMSServices.provideAPIKey("AIzaSyDtB5sgvGxdLTOK3kAJJ8xvCtElO87pchI")
        GMSPlacesClient.provideAPIKey("AIzaSyDtB5sgvGxdLTOK3kAJJ8xvCtElO87pchI")
        registerForPushNotifications()
        return true
    }
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.provisional]) {
              (granted, error) in
              print("Permission granted: \(granted)")
              // 1. Check if permission granted
              guard granted else { return }
              // 2. Attempt registration for remote notifications on the main thread
              DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
              }
          }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         // 1. Convert device token to string
         let tokenParts = deviceToken.map { data -> String in
             return String(format: "%02.2hhx", data)
         }
         let token = tokenParts.joined()
         // 2. Print device token to use for PNs payloads
         print("Device Token: \(token)")
        Defaults.setDeviceToken(token: token)
     }

     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         // 1. Print out error if PNs registration not successful
         print("Failed to register for remote notifications with error: \(error)")
     }
}

extension AppDelegate {
    /// Setting the initial data
    func initialSetup(){
        IQKeyboardManager.shared.enable = true
        Bundle.swizzleLocalization()
        Utility.checkIfAlreadyLogin()
    }
}


extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }

    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let bundlePath = Bundle.main.path(forResource: Defaults.getEnglishLangauge() == "en" ? "en" : "ar", ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}

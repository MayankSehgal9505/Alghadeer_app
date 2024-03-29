//
//  Defaults.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 27/04/21.
//

import Foundation

class Defaults {
    static let defaults = UserDefaults.standard

    static func isAppAlreadyLaunchedOnce()->Bool{
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    static func isUserLoggedIn()->Bool{
        return  defaults.bool(forKey: "isUserLoggedIn")
    }
    
    static func setUserLoggedIn(userLoggedIn:Bool) {
        defaults.set(userLoggedIn, forKey: "isUserLoggedIn")
    }
    
    static func setUserID(userID:String) {
        defaults.set(userID, forKey: "userID")
    }
    static func getUserID()-> String {
        defaults.string(forKey: "userID") ?? ""
    }
    static func setUserPhoneNumber(userNumber:String) {
        defaults.set(userNumber, forKey: "userNumber")
    }
    static func getUserPhoneNumber()-> String {
        defaults.string(forKey: "userNumber") ?? ""
    }
    static func setToken(token:String) {
        defaults.set(token, forKey: "token")
    }
    static func getToken()-> String? {
        defaults.string(forKey: "token")
    }
    static func resetDefaults() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != "isAppAlreadyLaunchedOnce" {
                defaults.removeObject(forKey: key)
            }
        }
    }
}

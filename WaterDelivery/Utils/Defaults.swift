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
    static func setDeviceToken(token:String) {
        defaults.set(token, forKey: "deviceToken")
    }
    static func getDeviceToken()-> String? {
        defaults.string(forKey: "deviceToken")
    }
    static func setToken(token:String) {
        defaults.set(token, forKey: "token")
    }
    static func getToken()-> String? {
        defaults.string(forKey: "token")
    }
    static func setSkipLogin(_ skipLogin:Bool) {
        defaults.set(skipLogin, forKey: "skippedLogin")
    }
    static func getSkipLogin()-> Bool {
        defaults.bool(forKey: "skippedLogin") 
    }
    static func setEnglishLangauge(_ english:String) {
        defaults.set(english, forKey: "selectedLanguageEnglish")
    }
    static func getEnglishLangauge()-> String? {
        if defaults.value(forKey: "selectedLanguageEnglish") != nil {
            return defaults.string(forKey: "selectedLanguageEnglish")
        } else {
            return "en"
        }
    }
    static func resetDefaults() {
        let dictionary = defaults.dictionaryRepresentation()
        print("dictionary is \(dictionary)")
        dictionary.keys.forEach { key in
            if key == "selectedLanguageEnglish" {
            } else {
                defaults.removeObject(forKey: key)
            }
        }
        print("updted dict \(defaults.dictionaryRepresentation())")
    }
}

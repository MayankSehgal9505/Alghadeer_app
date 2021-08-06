//
//  UserInfo.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 12/05/21.
//

import Foundation
import UIKit

final class UserData: NSObject {
   static let sharedInstance = UserData()

    //User properties
    var userPhoneNumber = ""
    var userName = ""
    var userID = ""
    var userModel = UserModel()
    var businessTypes = Array<BusinessModel>()
   private override init() { }
}

//
//  NotificationModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 04/08/21.
//

import Foundation
import SwiftyJSON

struct NotificationModel {
    //MARK: Variable
    var notificationID = ""
    var notificationTitle = ""
    var notificationMessage = ""
    var notificationDate = ""

    //MARK: Lifecycle
    init() {
    }
    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.notificationID = json["id"].stringValue
        self.notificationTitle = json["title"].stringValue
        self.notificationMessage = json["message"].stringValue
        self.notificationDate = json["created_date"].stringValue
    }
}

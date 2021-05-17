//
//  ContactUsModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 17/05/21.
//

import Foundation
import SwiftyJSON

struct ContactUsModel {
    //MARK: Variable
    var contactUsID = ""
    var contactUsMsg = ""
    var contactUsName = ""
    var contactUsPhone = ""
    var contactUsEmail = ""

    var faqAnswerVisible = false
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.contactUsID = json["id"].stringValue
        self.contactUsMsg = json["message"].stringValue
        self.contactUsName = json["name"].stringValue
        self.contactUsPhone = json["phone"].stringValue
        self.contactUsEmail = json["email"].stringValue
    }
}

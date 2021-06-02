//
//  BusinessModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 02/06/21.
//

import Foundation
import SwiftyJSON

struct BusinessModel {
    //MARK: Variable
    var businessID = ""
    var businessName = ""

    //MARK: Lifecycle
    init() {
    }
    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.businessID = json["id"].stringValue
        self.businessName = json["name"].stringValue
    }
}

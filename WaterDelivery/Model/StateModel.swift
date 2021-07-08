//
//  StateModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 22/06/21.
//

import Foundation
import SwiftyJSON

struct StateModel {
    //MARK: Variable
    var stateID = ""
    var stateName = ""
    var countryID = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.stateID = json["id"].stringValue
        self.stateName = json["name"].stringValue
        self.countryID = json["country_id"].stringValue
    }
}

struct CityModel {
    //MARK: Variable
    var cityID = ""
    var cityName = ""
    var stateID = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.cityID = json["id"].stringValue
        self.cityName = json["name"].stringValue
        self.stateID = json["state_id"].stringValue
    }
}

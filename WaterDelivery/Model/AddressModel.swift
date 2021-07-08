//
//  AddressModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 08/05/21.
//

import Foundation
import SwiftyJSON

struct AddressModel {
    
    //MARK: Variable
    var addressID = ""
    var shippingFname = ""
    var shippingLname = ""
    var shippingAddress = ""
    var shippingCity = ""
    var shippingState = ""
    var shippingCountry = ""
    var shippingPostCode = ""
    var shippingPhoneNumber = ""
    var shippingEmail = ""
    var shippingCustomerID = ""
    var latitude = ""
    var longitude = ""
    var addressSelected = false
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.addressID = json["id"].stringValue
        self.shippingFname = json["first_name"].stringValue
        self.shippingLname = json["last_name"].stringValue
        self.shippingAddress = json["address"].stringValue
        self.shippingCity = json["city"].stringValue
        self.shippingState = json["district"].stringValue
        self.shippingCountry = json["country"].stringValue
        self.shippingPostCode = json["postcode"].stringValue
        self.shippingPhoneNumber = json["phone_no"].stringValue
        self.shippingEmail = json["email"].stringValue
        self.shippingCustomerID = json["customer_id"].stringValue
        self.latitude = json["latitude"].stringValue
        self.longitude = json["longitude"].stringValue
    }
}

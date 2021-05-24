//
//  DeliveredProductsModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 24/05/21.
//

import Foundation
import SwiftyJSON

struct DeliveredProductsModel {
    enum DeliveredProductType:String {
        case oneTime = ""
        case subscription = "subscription"
        
        var deliveredProductStr: String {
            switch self {
            case .oneTime:
                return "One Time Order"
            default:
                return "Subscription Order"
            }
        }
    }
    var orderID = ""
    var status = ""
    var deliveryTime = ""
    var deliveryDate = ""
    var totalAmount = ""
    var deliveredProductType: DeliveredProductType = .oneTime
    var address = AddressModel()
    
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.orderID = json["order_id"].stringValue
        self.status = json["status"].stringValue
        self.deliveryTime = json["delivery_time"].stringValue
        //self.deliveryDate = json["image"].stringValue
        if let deliveredProductType = DeliveredProductType.init(rawValue: json["subscription"].stringValue) {
            self.deliveredProductType = deliveredProductType
        }
        self.totalAmount = json["total_amt"].stringValue
        self.address = AddressModel.init(json: json["address"])
    }
}


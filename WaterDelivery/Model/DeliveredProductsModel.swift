//
//  DeliveredProductsModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 24/05/21.
//

import Foundation
import SwiftyJSON
struct Order {
    var orderMonth = ""
    var deliveredProducts = Array<DeliveredProductsModel>()
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.orderMonth = json["date"].stringValue
        if let deliveryList = json["deliverylist"].array {
            for deliveredProduct in deliveryList {
                let deliverProductModel = DeliveredProductsModel.init(json: deliveredProduct)
                deliveredProducts.append(deliverProductModel)
            }
        }
    }
}
struct DeliveredProductsModel {
    enum DeliveredProductType:String {
        case oneTime = "0"
        case subscription = "1"
        
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
        self.deliveryDate = json["DATEFORMAT"].stringValue
        if let deliveredProductType = DeliveredProductType.init(rawValue: json["subscription"].stringValue) {
            self.deliveredProductType = deliveredProductType
        }
        self.totalAmount = json["total_amt"].stringValue
        self.address = AddressModel.init(json: json["address"])
    }
}


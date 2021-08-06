//
//  SummaryModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 05/06/21.
//

import Foundation
import SwiftyJSON

struct OrderSummary {
    //MARK: Variable
    var orderAmount = ""
    var orderVat = ""
    var orderGrandTotal = ""

    var faqAnswerVisible = false
    //MARK: Lifecycle
    init() {
    }
    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.orderAmount = json["amount"].stringValue
        self.orderVat = json["vat"].stringValue
        self.orderGrandTotal = json["grandtotal"].stringValue
    }
}

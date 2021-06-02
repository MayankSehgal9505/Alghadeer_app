//
//  AddMoney.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 02/06/21.
//

import Foundation
import SwiftyJSON

struct AddMoneyModel {
    enum TransactionStatus: String {
        case pending = "PENDING"
        case paid = "PAID"
        case fail = ""

    }
    var transactionID = ""
    var transactionDisplayID = ""
    var transactionReeferenceID = ""
    var transactionOrderId = ""
    var merchantID = ""
    var merchantName = ""
    var currency = ""
    var grandTotal = 0
    var cash = 0
    var status:TransactionStatus = .pending
    var paymentMethod = ""
    var branchID = ""
    var branchName = ""
    var customerEmail = ""
    var customerFirstName = ""
    var customerLastName = ""
    var customerPhone = ""
    var deviceReference = ""
    var firebaseCollection = ""
    var firebaseDatabase = ""
    var firebaseDocument = ""
    var redirectUrl = ""
    var redirectUrlShort = ""
    var timestamp = ""
    var base64QR = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.transactionID = json["id"].stringValue
        self.transactionDisplayID = json["displayId"].stringValue
        self.transactionReeferenceID = json["referenceId"].stringValue
        self.transactionOrderId = json["orderId"].stringValue
        self.merchantID = json["merchantId"].stringValue
        self.merchantName = json["merchantName"].stringValue
        self.currency = json["currency"].stringValue
        self.grandTotal = json["grandtotal"].intValue
        self.cash = json["cash"].intValue
        if let statusValue = TransactionStatus.init(rawValue: json["status"].stringValue) {
            self.status = statusValue
        } else {
            self.status = .fail
        }
        self.paymentMethod = json["paymentMethod"].stringValue
        self.branchID = json["branchId"].stringValue
        self.branchName = json["branchName"].stringValue
        self.customerEmail = json["customerEmail"].stringValue
        self.customerFirstName = json["customerFirstName"].stringValue
        self.customerLastName = json["customerLastName"].stringValue
        self.customerPhone = json["customerPhone"].stringValue
        self.deviceReference = json["deviceReference"].stringValue
        self.firebaseCollection = json["firebaseCollection"].stringValue
        self.firebaseDatabase = json["firebaseDatabase"].stringValue
        self.firebaseDocument = json["firebaseDocument"].stringValue
        self.redirectUrl = json["redirectUrl"].stringValue
        self.redirectUrlShort = json["redirectUrlShort"].stringValue
        self.timestamp = json["timestamp"].stringValue
        self.base64QR = json["base64QR"].stringValue
    }
}

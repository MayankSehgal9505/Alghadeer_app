//
//  WalletTransactionModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 05/06/21.
//

import Foundation
import SwiftyJSON
struct WalletTransaction{
    var date = ""
    var walletTransactions = [WalletTransactionModel]()
    
    //MARK: Lifecycle
    init() {
    }
    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.date = json["date"].stringValue
        if let transactions = json["wallet_trans_list"].array {
            var walletTransactions = [WalletTransactionModel]()
            for walletTransaction in transactions {
                let walletTransactionModel = WalletTransactionModel.init(json: walletTransaction)
                walletTransactions.append(walletTransactionModel)
            }
            self.walletTransactions = walletTransactions
        }
    }
    
}
struct WalletTransactionModel {
    //MARK: Variable
    var trans_type = ""
    var customer_id = ""
    var amt = ""
    var amt_after_trans = ""
    var wallet_id = ""
    var amt_before_trans = ""
    var id = ""
    var wallet_status = ""
    var comment = ""
    var transactionDate = ""
    var faqAnswerVisible = false
    var dateFormat = ""
    //MARK: Lifecycle
    init() {
    }
    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.trans_type = json["trans_type"].stringValue
        self.customer_id = json["customer_id"].stringValue
        self.amt = json["amt"].stringValue
        self.amt_after_trans = json["amt_after_trans"].stringValue
        self.wallet_id = json["wallet_id"].stringValue
        self.amt_before_trans = json["amt_before_trans"].stringValue
        self.id = json["id"].stringValue
        self.wallet_status = json["wallet_status"].stringValue
        self.comment = json["comment"].stringValue
        self.transactionDate = json["created_date"].stringValue
        self.dateFormat = json["DATEFORMAT"].stringValue
    }
}



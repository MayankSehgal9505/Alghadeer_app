//
//  WalletBalance.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 02/06/21.
//

import Foundation
import SwiftyJSON

struct WalletBalance {
    //MARK: Variable
    var walletID = ""
    var walletAmount = ""

    var faqAnswerVisible = false
    //MARK: Lifecycle
    init() {
    }
    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.walletID = json["id"].stringValue
        self.walletAmount = json["wallet_amount"].stringValue
    }
}

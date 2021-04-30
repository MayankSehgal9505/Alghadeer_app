//
//  File.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import Foundation
import SwiftyJSON

struct ProductModel {

    //MARK: Variable
    var productID = ""
    var name = ""
    var details = ""
    var productImage = ""
    var unitNumber = ""
    var attributeName = ""
    var unitPrice = ""
    var sellingPrice = ""
    var document = ""
    var quantity = ""
    var stockName = ""
    var brandName = ""

    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.productID = json["product_id"].stringValue
        self.name = json["product_name"].stringValue
        self.details = json["product_details"].stringValue
        self.productImage = json["image"].stringValue
        self.unitNumber = json["unit_number"].stringValue
        self.attributeName = json["attributes_name"].stringValue
        self.unitPrice = json["unit_price"].stringValue
        self.sellingPrice = json["selling_price"].stringValue
        self.document = json["discount"].stringValue
        self.quantity = json["quantity"].stringValue
        self.stockName = json["stock_name"].stringValue
        self.brandName = json["brand_name"].stringValue

    }
}

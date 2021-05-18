//
//  SubscriptionModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 17/05/21.
//

import Foundation
import SwiftyJSON

struct SubscriptionModel {
    
    var productID = ""
    var productName = ""
    var productDetails = ""
    var productImg = ""
    var productUnitNumber = ""
    var productAttributeName = ""
    var productAttributeID = ""
    var productUnitPrice = ""
    var productSellingPrice = ""
    var productDiscount = ""
    var productQuantity = ""
    var productStockName = ""
    var productStockID = ""
    var productCategoryID = ""
    var productCategoryName = ""
    var productBrandName = ""
    var productOrderID = ""
    var totalAmount = ""
    var productDeliveryTime = ""
    var subscriptionStartDate = ""
    var subscriptionEndDate = ""
    var address = AddressModel()
    
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.productID = json["product_id"].stringValue
        self.productName = json["product_name"].stringValue
        self.productDetails = json["product_details"].stringValue
        self.productImg = json["image"].stringValue
        self.productUnitNumber = json["unit_number"].stringValue
        self.productAttributeName = json["attributes_name"].stringValue
        self.productAttributeID = json["attributes_id"].stringValue
        self.productUnitPrice = json["unit_price"].stringValue
        self.productSellingPrice = json["selling_price"].stringValue
        self.productDiscount = json["discount"].stringValue
        self.productQuantity = json["quantity"].stringValue
        self.productStockName = json["stock_name"].stringValue
        self.productStockID = json["stock_id"].stringValue
        self.productCategoryID = json["category_id"].stringValue
        self.productCategoryName = json["category_name"].stringValue
        self.productBrandName = json["brand_name"].stringValue
        self.productOrderID = json["order_id"].stringValue
        self.totalAmount = json["total_amt"].stringValue
        self.productDeliveryTime = json["delivery_time"].stringValue
        self.subscriptionStartDate = json["start_date"].stringValue
        self.subscriptionEndDate = json["end_date"].stringValue
        self.address = AddressModel.init(json: json["address"])
    }
}


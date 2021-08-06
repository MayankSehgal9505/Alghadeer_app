//
//  File.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 01/05/21.
//

import Foundation
import SwiftyJSON
struct CartModel {
    var cartItems = Array<CartItemModel>()
    var totalPrice = ""
    
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.totalPrice = json["total_price"].stringValue
        if let itemslist = json[APIField.dataKey].array {
            for cartItem in itemslist {
                let cartItem = CartItemModel.init(json: cartItem)
                cartItems.append(cartItem)
            }
        }
    }
    
}
struct CartItemModel {

    //MARK: Variable
    var cartID = ""
    var productID = ""
    var cartQuantity = ""
    var itemPrice = ""
    var productName = ""
    var productDetails = ""
    var productImage = ""
    var discount = ""
    var totalPrice = ""
    var price = ""
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.productID = json["product_id"].stringValue
        self.cartID = json["cart_id"].stringValue
        self.cartQuantity = json["cart_quantity"].stringValue
        self.productImage = json["image"].stringValue
        self.itemPrice = json["price"].stringValue
        self.productName = json["product_name"].stringValue
        self.productDetails = json["product_details"].stringValue
        self.discount = json["discount"].stringValue
        self.totalPrice = json["total_price"].stringValue
        self.price = json["price"].stringValue
    }
}

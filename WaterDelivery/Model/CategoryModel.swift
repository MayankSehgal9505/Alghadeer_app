//
//  CategoryModel.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import Foundation
import SwiftyJSON

struct CategoryModel {

    //MARK: Variable
    var categoryID = ""
    var name = ""
    var details = ""
    var categoryImage = ""
    
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.categoryID = json["category_id"].stringValue
        self.name = json["category_name"].stringValue
        self.details = json["category_details"].stringValue
        self.categoryImage = json["image"].stringValue
    }
}

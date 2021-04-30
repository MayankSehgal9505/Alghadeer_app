//
//  Banner.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import Foundation
import SwiftyJSON

struct BannerModel {
    //MARK: Variable
    var id = ""
    var title = ""
    var details = ""
    var link = ""
    var sort = ""
    var imageUrl = ""
    
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.id = json["id"].stringValue
        self.title = json["title"].stringValue
        self.details = json["details"].stringValue
        self.link = json["link"].stringValue
        self.sort = json["sort"].stringValue
        self.imageUrl = json["image"].stringValue
    }
}

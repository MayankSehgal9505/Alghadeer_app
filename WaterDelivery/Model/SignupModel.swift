//
//  SignupModel.swift
//  CareConnect
//
//  Created by Vedvyas Rauniyar on 15/04/21.
//

import Foundation
import SwiftyJSON

struct SignupModel {
    
    //MARK: Variable
    var signuptype = ""
    var seeking_support = ""
    var myage = ""
    var support_firstname = ""
    var support_lastname = ""
    var located_serve = ""
    var support_seeking = ""
    var paying_support = ""
    var ndis_fund_manage = ""
    var hour_week_work = ""
    var firstname = ""
    var lastname = ""
    var mobile = ""
    var email = ""
    var password = ""
    var aboutus = ""
    
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.signuptype = json["signuptype"].stringValue
        self.seeking_support = json["seeking_support"].stringValue
        self.myage = json["myage"].stringValue
        self.support_firstname = json["support_firstname"].stringValue
        self.support_lastname = json["support_lastname"].stringValue
        self.located_serve = json["located_serve"].stringValue
        self.support_seeking = json["support_seeking"].stringValue
        self.paying_support = json["paying_support"].stringValue
        self.ndis_fund_manage = json["ndis_fund_manage"].stringValue
        self.hour_week_work = json["hour_week_work"].stringValue
        self.firstname = json["firstname"].stringValue
        self.lastname = json["lastname"].stringValue
        self.mobile = json["mobile"].stringValue
        self.email = json["email"].stringValue
        self.password = json["password"].stringValue
        self.aboutus = json["aboutus"].stringValue
    }
}
//Struct ends here

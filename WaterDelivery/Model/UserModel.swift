import Foundation
import SwiftyJSON

struct UserModel {
    
    //MARK: Variable
    var userID = ""
    var userName = ""
    var userEmail = ""
    var userAddress = ""
    var userGender = ""
    var userDOB = ""
    var userPhoneNumber = ""
    var userCountry = ""
    var userlatitude = ""
    var userlongitude = ""
    var userRole = ""
    
    //MARK: Lifecycle
    init() {
    }

    /// Init method of model
    ///
    /// - Parameter json: Json object
    init(json : JSON) {        
        self.userID = json["customer_id"].stringValue
        self.userName = json["name"].stringValue
        self.userEmail = json["email"].stringValue
        self.userAddress = json["address"].stringValue
        self.userGender = json["gender"].stringValue
        self.userDOB = json["dob"].stringValue
        self.userPhoneNumber = json["mobile_number"].stringValue
        self.userCountry = json["country"].stringValue
        self.userlatitude = json["latitude"].stringValue
        self.userlongitude = json["longitude"].stringValue
        self.userRole = json["role_name"].stringValue
    }
}

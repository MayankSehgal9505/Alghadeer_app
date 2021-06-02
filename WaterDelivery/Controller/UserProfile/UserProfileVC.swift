//
//  UserProfileVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit
import Kingfisher
class UserProfileVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameTxtfld: UITextField!
    @IBOutlet weak var emailTxtfld: UITextField!
    @IBOutlet weak var addressTxtfld: UITextField!
    @IBOutlet weak var countryTxtfld: UITextField!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryValue: UILabel!
    //MARK:- Local Variables
    var user = UserModel()
    var imagedict:[String:Data] = [:]
    var businesses = [BusinessModel]()
    var selectedBusinessType = BusinessModel()
    var dispatchGroup = DispatchGroup()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if UserData.sharedInstance.businessTypes.count < 2 {
            getBusinessCategory()
        } else {
            businesses = UserData.sharedInstance.businessTypes
        }
        getUserProfile()
        let imageData: Data? = userImg.image?.jpegData(compressionQuality: 0)
        if let data = imageData {
            self.imagedict["profile"] = data
        }
    }
    //MARK:- Internal Methods
    func setupUI() {
        userImg.setCornerRadiusOfView(cornerRadiusValue: 75.00, setBorder: true, borderColor: .white, width: 2.0)
        saveBtn.setCornerRadiusOfView(cornerRadiusValue:30)
    }
    
    func updateUI() {
        userNameLbl.text = user.userName
        nameTxtfld.text = user.userName
        emailTxtfld.text = user.userEmail
        addressTxtfld.text = user.userAddress
        countryTxtfld.text = user.userCountry
        phoneNumberTxtFld.text = user.userPhoneNumber
        if let imageURL = URL.init(string: user.profileImgUrl) {
            userImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
        } else {
            userImg.image = UIImage(named: "profile")
        }
        let business = businesses.filter({ (businessModel) -> Bool in
            return businessModel.businessID == user.businessID
        }).first
        selectedBusinessType = business ?? BusinessModel()
        categoryValue.text = business?.businessName ?? ""
    }
    func showOptions(){
        let alert = UIAlertController(title: "Please select category", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: self.businesses.first?.businessName ?? "", style: .default , handler:{ (UIAlertAction)in
            self.selectedBusinessType = self.businesses.first!
            self.categoryValue.text = self.businesses.first?.businessName ?? ""
           }))
           alert.addAction(UIAlertAction(title: self.businesses.last?.businessName ?? "", style: .default , handler:{ (UIAlertAction)in
            self.selectedBusinessType = self.businesses.last!
            self.categoryValue.text = self.businesses.last?.businessName ?? ""
           }))
           self.present(alert, animated: true, completion: {
               print("completion block")
           })
    }
    //MARK:- IBActions
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if (nameTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Name can't be empty", duration: 3.0, position: .center)
        } else if (emailTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        } else if (!CommonMethods.isValidEmail(emailTxtfld.text!)) {
            self.view.makeToast("Email should be valid", duration: 3.0, position: .center)
        }else if (addressTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Address name can't be empty", duration: 3.0, position: .center)
        } else if (phoneNumberTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Phone Number can't be empty", duration: 3.0, position: .center)
        }else if (countryTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Country can't be empty", duration: 3.0, position: .center)
        } else {
            updateUserProfile()
            updateUserImg()
        }
    }
    @IBAction func camerBtnAction(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
               //here is the image
            self.userImg.image = image
            let imageData: Data? = image.jpegData(compressionQuality: 0)
            if let data = imageData {
                self.imagedict["profile"] = data
            }

        }
    }
    @IBAction func categoryBtnAction(_ sender: UIButton) {
        showOptions()
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- API call
extension UserProfileVC {
    func getUserProfile() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getUserDetailsUrl : String = UrlName.baseUrl + UrlName.getUserDetailUrl + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: getUserDetailsUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let userDict = jsonValue[APIField.dataKey] {
                        self.user = UserModel.init(json: userDict)
                        UserData.sharedInstance.userModel = self.user
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserInfo"), object: self)
                        }
                    }
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    func updateUserImg() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let setUserImgUrl : String = UrlName.baseUrl + UrlName.updateUserImgUrl
            let parameters = [
                "user_id":Defaults.getUserID()
            ] as [String : Any]
            NetworkManager.viewControler = self
            let headers = [
                "Authorization": "Bearer \(Defaults.getToken() ?? "")",
                "Content-Type" : "multipart/form-data"
            ]
            NetworkManager.sharedInstance.uploadDocuments(url: setUserImgUrl, method: .post, imagesDict: self.imagedict, parameters: parameters, headers: headers, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.view.makeToast("Photo uploaded successfully", duration: 3.0, position: .center)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            }) }else{
                self.showNoInternetAlert()
            }
    }
    func updateUserProfile() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let setUserDetailsUrl : String = UrlName.baseUrl + UrlName.updateUserDetailUrl + Defaults.getUserID()
            let parameters = [
                "name":nameTxtfld.text!,
                "address":addressTxtfld.text!,
                "gender":"M",
                "dob":"2017-3-2",
                "country":countryTxtfld.text!,
                "role_id":"1",
                "mobile_number":phoneNumberTxtFld.text!,
                "latitude":"19.4354",
                "longitude":"67.45453",
                "customer_id": Defaults.getUserID(),
                "email":emailTxtfld.text!,
                "business_id": selectedBusinessType.businessID
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: setUserDetailsUrl, method: .put, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.view.makeToast("Profile updated successfully", duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    
    func getBusinessCategory() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getBBusinessTypeUrl : String = UrlName.baseUrl + UrlName.getBusinessUrl
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: getBBusinessTypeUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let businessList = jsonValue[APIField.dataKey]?.array {
                        var businesses = Array<BusinessModel>()
                        for business in businessList {
                            let businessModel = BusinessModel.init(json: business)
                            businesses.append(businessModel)
                        }
                        self.businesses = businesses
                        UserData.sharedInstance.businessTypes = self.businesses
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
}

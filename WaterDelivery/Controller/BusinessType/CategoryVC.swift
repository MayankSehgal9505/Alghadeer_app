//
//  CategoryVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit

class CategoryVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var categoView,emailView: UIView!
    @IBOutlet weak var categotyTF,emailTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var businesses = [BusinessModel]()
    var selectedBusinessType = BusinessModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getBusinessCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView(){
        self.nextButton.setCornerRadiusOfView(cornerRadiusValue: 25)
        self.setCornerWithColor(aView: self.categoView, radius: 0)
        self.setCornerWithColor(aView: self.emailView, radius: 0)
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        showOptions()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
         if (self.categotyTF.text?.isEmpty)! {
            self.view.makeToast(AlertField.emptycategoString, duration: 3.0, position: .bottom)
            return
        }
        else if (self.emailTF.text?.isEmpty)! {
           self.view.makeToast(AlertField.emptyEmailString, duration: 3.0, position: .bottom)
           return
        }
        else if (!self.isValidEmail(emailStr: emailTF.text!)) {
            self.view.makeToast(AlertField.emailNotValidString, duration: 3.0, position: .bottom)
            return
        }
         else {
            setBusinessCategory()
        }
    }
}

extension CategoryVC {
    func showOptions(){
        let alert = UIAlertController(title: "Please select category", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: self.businesses.first?.businessName ?? "", style: .default , handler:{ (UIAlertAction)in
            self.selectedBusinessType = self.businesses.first!
            self.categotyTF.text = self.businesses.first?.businessName ?? ""
           }))
           alert.addAction(UIAlertAction(title: self.businesses.last?.businessName ?? "", style: .default , handler:{ (UIAlertAction)in
            self.selectedBusinessType = self.businesses.last!
            self.categotyTF.text = self.businesses.last?.businessName ?? ""
           }))
           self.present(alert, animated: true, completion:nil)
    }
}

//MARK:- API Calls
extension CategoryVC: CategoryAPI {
    func setBusinessCategory() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let faqURL : String = UrlName.baseUrl + UrlName.setBusinessUrl + Defaults.getUserID()
            let parameters = [
                "email":emailTF.text!,
                "business_id":selectedBusinessType.businessID
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .put, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        Defaults.setUserLoggedIn(userLoggedIn: true)
                        self.makeRootViewController()
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

    
    func getBusinessCategory() {
        getBusinessCategory { (businesses) in
            self.businesses = businesses
            UserData.sharedInstance.businessTypes = self.businesses
        }
    }
}

protocol CategoryAPI {
}
extension CategoryAPI where Self: UIViewController{
    func getBusinessCategory(resultObtained: @escaping(Array<BusinessModel>) -> Void) {
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
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let businessList = jsonValue[APIField.dataKey]?.array {
                        var businesses = Array<BusinessModel>()
                        for business in businessList {
                            let businessModel = BusinessModel.init(json: business)
                            businesses.append(businessModel)
                        }
                        resultObtained(businesses)
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

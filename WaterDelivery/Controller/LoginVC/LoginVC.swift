//
//  LoginVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit
import Toast_Swift

class LoginVC: UIViewController {

    
    //MARK:- IBOutlet
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    //Labels
    @IBOutlet weak var loginTextLbl: UILabel!
    @IBOutlet weak var enterPhnNumberLbl: UILabel!
    @IBOutlet weak var otpText: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var helpText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView(){
        changeOfLanguage()
        self.loginButton.setCornerRadiusOfView(cornerRadiusValue: 25)
        self.setCornerWithColor(aView: self.phoneView, radius: 2)
        phoneTextField.textAlignment = Defaults.getEnglishLangauge() == "en" ? .left : .right
        phoneTextField.placeholder = Bundle.main.localizedString(forKey: "Enter Phone Number", value: nil, table: nil)
        loginTextLbl.text = Bundle.main.localizedString(forKey: "Login", value: nil, table: nil)
        enterPhnNumberLbl.text = Bundle.main.localizedString(forKey: "Enter your Phone Number", value: nil, table: nil)
        otpText.text = Bundle.main.localizedString(forKey: "We will send you on OTP to verify your number \n Existing customer can login using their registered number", value: nil, table: nil)
        loginButton.setTitle(Bundle.main.localizedString(forKey: "Submit", value: nil, table: nil), for: [])
        skipBtn.setTitle(Bundle.main.localizedString(forKey: "Skip >>", value: nil, table: nil), for: [])
        helpText.text = Bundle.main.localizedString(forKey: "In case of any issues, please contact us of", value: nil, table: nil)
    }
    @objc func changeOfLanguage(){
        if Defaults.getEnglishLangauge() == "en" {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.view.layoutIfNeeded()
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
         if (self.phoneTextField.text?.isEmpty)! {
            self.view.makeToast(Bundle.main.localizedString(forKey: AlertField.emptyMobileString, value: "", table: "") , duration: 3.0, position: .bottom)
            return
        }
         else {
            self.loginWithOtpAPI()
        }
    }
    
    @IBAction func skipBtnClicked(_ sender: Any) {
        Defaults.setSkipLogin(true)
        Defaults.setToken(token: UserDefaultsKey.defaultToken)
        self.makeRootViewController()
    }
    
    @IBAction func callBtnClicked(_ sender: Any) {
        guard let number = URL(string: "tel://" + "+919069720406") else { return }
        UIApplication.shared.open(number)
    }
}

// MARK: API Call
extension LoginVC {
    func loginWithOtpAPI() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let loginURL : String = UrlName.baseUrl + UrlName.loginOtpUrl
            let parameters = [
            "mobile_number":self.phoneTextField.text!,
                "fcm_token":Defaults.getDeviceToken() ?? ""
            ] as [String : Any]
            NetworkManager.sharedInstance.commonApiCall(url: loginURL, method: .post, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    Defaults.setToken(token: jsonValue[APIField.tokenKey]?.stringValue ?? "")
                    if let dataString = jsonValue[APIField.dataKey]?.dictionary {
                        let user = UserModel.init(json: jsonValue[APIField.dataKey]!)
                        UserData.sharedInstance.userModel = user
                        Defaults.setUserPhoneNumber(userNumber: dataString["mobile_number"]?.stringValue ?? "")
                        Defaults.setUserID(userID: dataString["id"]?.stringValue ?? "")
                        DispatchQueue.main.async {
                            let obj = OTPVC.init(nibName: OTPVC.className(), bundle: nil)
                            obj.mobile = self.phoneTextField.text!
                            obj.otpRecieved = dataString["otp"]?.stringValue ?? ""
                            self.navigationController?.pushViewController(obj, animated: true)
                        }
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

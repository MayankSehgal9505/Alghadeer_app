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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView(){
        self.loginButton.setCornerRadiusOfView(cornerRadiusValue: 25)
        self.setCornerWithColor(aView: self.phoneView, radius: 2)
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
         if (self.phoneTextField.text?.isEmpty)! {
            self.view.makeToast(AlertField.emptyMobileString, duration: 3.0, position: .bottom)
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

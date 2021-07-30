//
//  OTPVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit
import Toast_Swift

class OTPVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var tiimerField: UILabel!
    @IBOutlet var otpTxtFlds: [OtpTextfield]!
    @IBOutlet weak var resendOtp: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var otpTxtFldViews: [UIView]! {
        didSet {
            for otpView in otpTxtFldViews {
                self.setCornerWithColor(aView: otpView, radius: 8,color: UIColor.init(red: 59/255, green: 112/255, blue: 229/255, alpha: 1.0))
            }
        }
    }
    
    var remainingStrStack: [String] = []
    
    //MARK:- Variables
    var mobile = ""
    var otp = ""
    var otpRecieved = ""
    private var timer : Timer?
    private var timelimit = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        resendOtp.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView(){
        submitButton.isEnabled = true
        self.submitButton.setCornerRadiusOfView(cornerRadiusValue: 25)
        setupTextfields()
        initializeTimer()
    }
    private func initializeTimer() {
        timelimit = 59
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fire()
    }
    @objc private func startTimer() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        if timelimit == 0 {
            timer?.invalidate()
            timer = nil
            tiimerField.attributedText = NSAttributedString(string: "Send Again OTP", attributes: underlineAttribute)
            resendOtp.isEnabled = true
        } else {
            timelimit = timelimit-1
            tiimerField.attributedText = NSAttributedString(string: String(format: "Send Again OTP (%@s)", "\(timelimit)"), attributes: underlineAttribute)
        }
    }
    //gives the OTP text
    final func getOTP() -> String{
        for textField in otpTxtFlds{
            otp += textField.text ?? ""
        }
        return otp
    }
    private func setupTextfields() {
        for index in 0..<otpTxtFlds.count{
            otpTxtFlds[index].delegate = self
            //Adding a marker to previous field
            index != 0 ? (otpTxtFlds[index].previousTextField = otpTxtFlds[index-1]) : (otpTxtFlds[index].previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (otpTxtFlds[index-1].nextTextField = otpTxtFlds[index]) : ()
        }
        
//        for (otpChar,textfield) in zip(otpRecieved, otpTxtFlds) {
//            textfield.text = String.init(otpChar)
//        }
    }
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        verifyWithOtpAPI()
    }
    @IBAction func resendBtnClicked(_ sender: Any) {
        resendOtpAPI()
    }
}

extension OTPVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let otpTxtFld = textField as! OtpTextfield
        if (otpTxtFlds.index(of: otpTxtFld) == otpTxtFlds.count-1) {
            return true
        } else if otpTxtFld.nextTextField?.text?.isEmpty ?? false {
            return true
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
    }
    //checks if all the OTPfields are filled
    private final func checkForValidity(){
        for fields in otpTxtFlds{
            if (fields.text == ""){
                submitButton.isEnabled = false
                return
            }
        }
        submitButton.isEnabled = true
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OtpTextfield else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                }else{
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in otpTxtFlds {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
    }
}
// MARK: API Call
extension OTPVC {
    func verifyWithOtpAPI() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let loginURL : String = UrlName.baseUrl + UrlName.verifyOTPUrl
            let parameters = [
            "mobile_number":self.mobile,
            "otp":getOTP()
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: loginURL, method: .post, parameters: parameters, completionHandler: { (json, status) in
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
                }else {
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
    
    func resendOtpAPI() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let loginURL : String = UrlName.baseUrl + UrlName.resendOtpUrl
            let parameters = [
            "mobile_number":self.mobile
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: loginURL, method: .post, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    return
                }
                if let apiSuccess = jsonValue[APIField.successKey], apiSuccess == "true" {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                }
                else {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoInternetAlert()
        }
    }
}

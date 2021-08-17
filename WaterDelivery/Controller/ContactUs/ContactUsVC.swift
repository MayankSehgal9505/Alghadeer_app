//
//  ContactUsVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 17/05/21.
//

import UIKit

class ContactUsVC: UIViewController {

    //MARK:- IBOutlets    
    @IBOutlet weak var emailValue: UILabel!
    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var numberValue: UILabel!
    @IBOutlet weak var subjectTextFld: UITextField!
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var msgTxtFld: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var contactUsLbl: UILabel!
    @IBOutlet weak var youurMsgLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    //MARK:- Local Variables
    var contactUsModel = ContactUsModel()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitBtn.setCornerRadiusOfView(cornerRadiusValue: 20)
        contactUsLbl.text = Bundle.main.localizedString(forKey: "Contact Us", value: nil, table: nil)
        subjectTextFld.placeholder = Bundle.main.localizedString(forKey: "Subject", value: nil, table: nil)
        titleTxtFld.placeholder = Bundle.main.localizedString(forKey: "Title", value: nil, table: nil)
        youurMsgLbl.text = Bundle.main.localizedString(forKey: "Your Message", value: nil, table: nil)
        emailLbl.text = Bundle.main.localizedString(forKey: "Email:", value: nil, table: nil)
        phoneNumberLbl.text = Bundle.main.localizedString(forKey: "Phone Number", value: nil, table: nil)
        addressLbl.text = Bundle.main.localizedString(forKey: "Address", value: nil, table: nil)
        submitBtn.setTitle(Bundle.main.localizedString(forKey: "Submit", value: nil, table: nil), for: [])
        if Defaults.getEnglishLangauge() == "ar" {
            subjectTextFld.textAlignment = .right
            titleTxtFld.textAlignment = .right
            msgTxtFld.textAlignment = .right
        } else {
            subjectTextFld.textAlignment = .left
            titleTxtFld.textAlignment = .left
            msgTxtFld.textAlignment = .left
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        greyView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    //MARK:- Internal Methods
    private func updateUI(){
        emailValue.text = contactUsModel.contactUsEmail
        nameValue.text = contactUsModel.contactUsName
        numberValue.text = "+971 \(contactUsModel.contactUsPhone)"
    }
    private func resetEnquiryView(){
        subjectTextFld.text = ""
        titleTxtFld.text = ""
        msgTxtFld.text = ""
    }
    //MARK:- IBActions
    @IBAction func submitBtnAction(_ sender: UIButton) {
        if (subjectTextFld.text?.isEmpty ??  true) {
            self.view.makeToast("Subject can't be empty", duration: 3.0, position: .center)
        } else if (titleTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Title can't be empty", duration: 3.0, position: .center)
        } else if (msgTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Message can't be empty", duration: 3.0, position: .center)
        } else {
            sendEnquiry()
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- API Call
extension ContactUsVC {
    
    func sendEnquiry() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let enquiryUrl : String = UrlName.baseUrl + UrlName.enquiryUrl
            let parameters = [
            "subject":self.subjectTextFld.text!,
            "title":self.titleTxtFld.text!,
            "message":self.msgTxtFld.text!,
            "customer_id":Defaults.getUserID()
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: enquiryUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.resetEnquiryView()
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
    
    func getContactUs() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let faqURL : String = UrlName.baseUrl + UrlName.contactUrl
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    self.contactUsModel = ContactUsModel.init(json: json!)
                    DispatchQueue.main.async {
                        self.updateUI()
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

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
    @IBOutlet weak var messageValue: UILabel!
    //MARK:- Local Variables
    var contactUsModel = ContactUsModel()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getContactUs()
    }

    //MARK:- Internal Methods
    private func updateUI(){
        emailValue.text = contactUsModel.contactUsEmail
        nameValue.text = contactUsModel.contactUsName
        numberValue.text = "+971 \(contactUsModel.contactUsPhone)"
        messageValue.text = contactUsModel.contactUsMsg
    }
    
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- API Call
extension ContactUsVC {
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

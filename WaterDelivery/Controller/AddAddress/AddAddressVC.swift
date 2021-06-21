//
//  AddAddressVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit
protocol AddAddressProtocol: class {
    func addressAdded()
}
class AddAddressVC: UIViewController {
    //MARK:- Enums
    enum AddressScreenType {
        case addAddress
        case updateAddress
    }

    //MARK:- IBOutlets
    @IBOutlet var roundedViews: [UIView]!
    @IBOutlet weak var fNameTxtFld: UITextField!
    @IBOutlet weak var lNameTxtFld: UITextField!
    @IBOutlet weak var streetTxtFld: UITextField!
    @IBOutlet weak var townCityTxtFld: UITextField!
    @IBOutlet weak var stateCountryTxtfld: UITextField!
    @IBOutlet weak var postCodTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var emailTxtfld: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addressTypeTitle: UILabel!
    
    //MARK:- Properties
    var addressScreenType: AddressScreenType = .addAddress
    var addressModel = AddressModel()
    weak var delegate : AddAddressProtocol?
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    //MARK:- Internal Methods
    func setupUI() {
        addressTypeTitle.text = addressScreenType == .addAddress ? "Add Address" : "Update Address"
        switch addressScreenType {
        case .updateAddress: setUpUIData()
        default: break
        }
        roundedViews.forEach{$0.setCornerRadiusOfView(cornerRadiusValue: 20,setBorder: true, borderColor: .lightGray, width: 1.0)}
        saveBtn.setCornerRadiusOfView(cornerRadiusValue:25)
    }
    
    func setUpUIData() {
        self.fNameTxtFld.text = addressModel.shippingFname
        self.lNameTxtFld.text = addressModel.shippingLname
        self.streetTxtFld.text = addressModel.shippingAddress
        self.townCityTxtFld.text = addressModel.shippingCity
        self.stateCountryTxtfld.text = addressModel.shippingState
        self.postCodTxtFld.text = addressModel.shippingPostCode
        self.phoneNumberTxtFld.text = addressModel.shippingPhoneNumber
        self.emailTxtfld.text = addressModel.shippingEmail
    }
    
    //MARK:- IBActions
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if (fNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("First name can't be empty", duration: 3.0, position: .center)
        } else if (lNameTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Last name can't be empty", duration: 3.0, position: .center)
        } else if (streetTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Street name can't be empty", duration: 3.0, position: .center)
        } else if (townCityTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Town/City can't be empty", duration: 3.0, position: .center)
        } else if (stateCountryTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("State/Country can't be empty", duration: 3.0, position: .center)
        } else if (postCodTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("PostCode/Zip can't be empty", duration: 3.0, position: .center)
        } else if (postCodTxtFld.text!.count != 6 ) {
            self.view.makeToast("PostCode/Zip should bee of 6 characters", duration: 3.0, position: .center)
        }else if (phoneNumberTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Phone number can't be empty", duration: 3.0, position: .center)
        } else if (emailTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        } else if (!CommonMethods.isValidEmail(emailTxtfld.text!)) {
            self.view.makeToast("Email should be valid", duration: 3.0, position: .center)
        } else {
            switch addressScreenType {
            case .addAddress:
                addAddress()
            default:
                updateAddress()
            }
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- API call
extension AddAddressVC {
    func updateAddress() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addAddressUrl : String = UrlName.baseUrl + UrlName.updateAddressUrl + addressModel.addressID
            let parameters = [
                "first_name":fNameTxtFld.text!,
                "last_name":lNameTxtFld.text!,
                "address":streetTxtFld.text!,
                "city":townCityTxtFld.text!,
                "state":stateCountryTxtfld.text!,
                "country":stateCountryTxtfld.text!,
                "postcode":postCodTxtFld.text!,
                "phone_no":phoneNumberTxtFld.text!,
                "email":emailTxtfld.text!,
                "latitude":"19.079023",
                "longitude":"72.908012",
                //"customer_id": Defaults.getUserID()
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: addAddressUrl, method: .put, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.view.makeToast("Address Updated successfully", duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if let errordict = jsonValue["Errors"]?.dictionaryObject {
                            if errordict.keys.count == 0 {
                                self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                            } else {
                                self.view.makeToast(errordict[errordict.keys.first!] as? String ?? "", duration: 3.0, position: .center)

                            }
                        } else {
                            self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                        }
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
    
    func addAddress() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addAddressUrl : String = UrlName.baseUrl + UrlName.addAddressUrl
            let parameters = [
                "first_name":fNameTxtFld.text!,
                "last_name":lNameTxtFld.text!,
                "address":streetTxtFld.text!,
                "city":townCityTxtFld.text!,
                "state":stateCountryTxtfld.text!,
                "country":stateCountryTxtfld.text!,
                "postcode":postCodTxtFld.text!,
                "phone_no":phoneNumberTxtFld.text!,
                "email":emailTxtfld.text!,
                "latitude":"19.079023",
                "longitude":"72.908012",
                "customer_id": Defaults.getUserID()
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: addAddressUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.view.makeToast("Address added successfully", duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.delegate?.addressAdded()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if let errordict = jsonValue["Errors"]?.dictionaryObject {
                            if errordict.keys.count == 0 {
                                self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                            } else {
                                self.view.makeToast(errordict[errordict.keys.first!] as? String ?? "", duration: 3.0, position: .center)

                            }
                        } else {
                            self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                        }
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

extension AddAddressVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fNameTxtFld {
            textField.resignFirstResponder()
            lNameTxtFld.becomeFirstResponder()
        } else if textField == lNameTxtFld {
            textField.resignFirstResponder()
            streetTxtFld.becomeFirstResponder()
        } else if textField == streetTxtFld {
            textField.resignFirstResponder()
            townCityTxtFld.becomeFirstResponder()
        } else if textField == townCityTxtFld {
            textField.resignFirstResponder()
            stateCountryTxtfld.becomeFirstResponder()
        } else if textField == stateCountryTxtfld {
            textField.resignFirstResponder()
            postCodTxtFld.becomeFirstResponder()
        } else if textField == postCodTxtFld {
            textField.resignFirstResponder()
            phoneNumberTxtFld.becomeFirstResponder()
        } else if textField == phoneNumberTxtFld {
            textField.resignFirstResponder()
            emailTxtfld.becomeFirstResponder()
        } else{
            textField.resignFirstResponder()
        }
        return true
    }
}

//
//  AddAddressVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class AddAddressVC: UIViewController {

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
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    //MARK:- Internal Methods
    func setupUI() {
        roundedViews.forEach{$0.setCornerRadiusOfView(cornerRadiusValue: 20,setBorder: true, borderColor: .lightGray, width: 1.0)}
        saveBtn.setCornerRadiusOfView(cornerRadiusValue:25)
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
        } else if (phoneNumberTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Phone number can't be empty", duration: 3.0, position: .center)
        } else if (emailTxtfld.text?.isEmpty ??  true) {
            self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        } else if (!CommonMethods.isValidEmail(emailTxtfld.text!)) {
            self.view.makeToast("Email should be valid", duration: 3.0, position: .center)
        } else {
            self.view.makeToast("Under Development", duration: 3.0, position: .bottom)
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

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
class AddAddressVC: UIViewController,SelectedLoc {

    
    //MARK:- Enums
    enum AddressScreenType {
        case addAddress
        case updateAddress
    }
    enum PickerType {
        case state
        case city
    }
    //MARK:- IBOutlets
    @IBOutlet var circularViews: [UIView]! {didSet {circularViews.forEach{$0.setCornerRadiusOfView(cornerRadiusValue: 15)}}}
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton! {didSet{self.saveBtn.setCornerRadiusOfView(cornerRadiusValue: 20)
        saveBtn.setTitle(Bundle.main.localizedString(forKey: "Submit", value: "", table: ""), for: [])
    }}
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var addressTypeTitle: UILabel!
    @IBOutlet weak var pickerLbl: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerMainView: UIView!
    @IBOutlet weak var stateTxtFld: UITextField!
    @IBOutlet weak var cityTxtFld: UITextField!
    @IBOutlet weak var locationTxtFld: UITextField!
    @IBOutlet weak var addAddressLbl: UILabel!
    
    //MARK:- Properties
    var addressScreenType: AddressScreenType = .addAddress
    private var pickerType: PickerType = .state
    var addressModel = AddressModel()
    weak var delegate : AddAddressProtocol?
    private var effectView,vibrantView : UIVisualEffectView?
    var stateList = Array<StateModel>()
    var cityList = Array<CityModel>()
    private var selectedState = StateModel()
    private var selectedCity = CityModel()
    private var lat = Double()
    private var long = Double()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    //MARK:- Internal Methods
    func setupUI() {
        getStatesCities(cities: false)
        addressTypeTitle.text = addressScreenType == .addAddress ? Bundle.main.localizedString(forKey: "Add new Address", value: "", table: "") : Bundle.main.localizedString(forKey: "Update Address", value: "", table: "")
        addressTxtFld.placeholder = Bundle.main.localizedString(forKey: "Address", value: "", table: "")
        phoneNumberTxtFld.placeholder = Bundle.main.localizedString(forKey: "Contact Number", value: "", table: "")
        stateTxtFld.placeholder = Bundle.main.localizedString(forKey: "City", value: "", table: "")
        cityTxtFld.placeholder = Bundle.main.localizedString(forKey: "District", value: "", table: "")
        locationTxtFld.placeholder = Bundle.main.localizedString(forKey: "Location", value: "", table: "")
        addressTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .right : .left
        phoneNumberTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .right : .left
        stateTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .right : .left
        cityTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .right : .left
        locationTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .right : .left
        switch addressScreenType {
        case .updateAddress: setUpUIData()
        default: break
        }
    }
    func getAddress(lat: Double,long: Double) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let faqURL : String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=AIzaSyDtB5sgvGxdLTOK3kAJJ8xvCtElO87pchI"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                if let jsonValue = json?.dictionaryValue {
                    if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == "OK" {
                        if let addressList = jsonValue["results"]?.array {
                            if addressList.count > 0 {
                                if let addressDict = addressList.first?.dictionaryValue {
                                    DispatchQueue.main.async {
                                        self.dismissHUD(isAnimated: true)
                                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                                        self.locationTxtFld.text = addressDict["formatted_address"]?.string ?? ""
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.dismissHUD(isAnimated: true)
                                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                                        self.locationTxtFld.text = ""
                                    }
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                        self.locationTxtFld.text = ""
                    }
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    
    func setUpUIData() {
        self.addressTxtFld.text = addressModel.shippingAddress
        self.phoneNumberTxtFld.text = addressModel.shippingPhoneNumber
        self.stateTxtFld.text = addressModel.shippingState
        self.cityTxtFld.text = addressModel.shippingCity
        getAddress(lat: Double(addressModel.latitude) ?? 0.0, long: Double(addressModel.longitude) ?? 0.0)
    }
    /// Hiding Picker View
    private func hidePickerView(){
        pickerMainView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    
    /// Hiding Picker View
    private func showPickerView(){
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(pickerMainView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.pickerMainView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: pickerMainView, view: self.view)
        pickerView.reloadAllComponents()
    }
    
    func locationData(locString: String, lat: Double, long: Double) {
        DispatchQueue.main.async {
            self.locationTxtFld.text = locString
        }
        self.lat = lat
        self.long = long
    }
    //MARK:- IBActions
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        let mapVC = MapVC.init()
        mapVC.modalPresentationStyle = .fullScreen
        mapVC.locationDelegate = self
        self.present(mapVC, animated: true, completion: nil)
        
    }
    @IBAction func stateBtnAction(_ sender: UIButton) {
        pickerType = .state
        showPickerView()
    }
    
    @IBAction func cityBtnAction(_ sender: UIButton) {
        pickerType = .city
        showPickerView()
    }
    @IBAction func pickerCancelAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func pckerDoneAction(_ sender: UIBarButtonItem) {
        hidePickerView()
        switch pickerType {
        case .state:
            stateTxtFld.text = selectedState.stateName
            getStatesCities(cities: true,state: selectedState.stateID)
        default:
            cityTxtFld.text = selectedCity.cityName
        }
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if (addressTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast(Bundle.main.localizedString(forKey: "Address can't be empty", value: "", table: "")
, duration: 3.0, position: .center)
        } else if (phoneNumberTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast(Bundle.main.localizedString(forKey: "Phone number can't be empty", value: "", table: ""), duration: 3.0, position: .center)
        } /*else if (locationTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast("Location can't be empty", duration: 3.0, position: .center)
        }*/ else if (stateTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast(Bundle.main.localizedString(forKey: "State can't be empty", value: "", table: ""), duration: 3.0, position: .center)
        } else if (cityTxtFld.text?.isEmpty ??  true) {
            self.view.makeToast(Bundle.main.localizedString(forKey: "City can't be empty", value: "", table: ""), duration: 3.0, position: .center)
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
    private func getStatesCities(cities:Bool,state:String = "") {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getStatesCityUrl = UrlName.baseUrl + (cities ? "\(UrlName.getCities)\(state)" : UrlName.getStates)
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: getStatesCityUrl, method: .get, parameters: nil, completionHandler: {
                (json, status) in
                    guard let jsonValue = json?.dictionaryValue else {
                        DispatchQueue.main.async {
                            self.dismissHUD(isAnimated: true)
                            self.view.makeToast(status, duration: 3.0, position: .bottom)
                        }
                        return
                    }
                    
                    if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                        if let stateCitieslist = jsonValue[APIField.dataKey]?.array {
                            if cities {
                                var cities = Array<CityModel>()
                                for city in stateCitieslist {
                                    let cityModel = CityModel.init(json: city)
                                    cities.append(cityModel)
                                }
                                self.cityList = cities
                                self.selectedCity = self.cityList.first ?? CityModel()

                            } else {
                                var states = Array<StateModel>()
                                for state in stateCitieslist {
                                    let stateModel = StateModel.init(json: state)
                                    states.append(stateModel)
                                }
                                self.stateList = states
                                self.selectedState = self.stateList.first ?? StateModel()
                            }
                            DispatchQueue.main.async {
                                self.pickerView.reloadAllComponents()
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

        }
    }
    func updateAddress() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addAddressUrl : String = UrlName.baseUrl + UrlName.updateAddressUrl + addressModel.addressID
            let parameters = [
                "address":addressTxtFld.text!,
                "city":cityTxtFld.text!,
                "district":stateTxtFld.text!,
                "phone_no":phoneNumberTxtFld.text!,
                "latitude":self.lat,
                "longitude":self.long,
                "customer_id":Defaults.getUserID(),
                "location_address": locationTxtFld.text!
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
                        self.view.makeToast(Bundle.main.localizedString(forKey: "Address added successfully", value: "", table: ""), duration: 0.5, position: .center)
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
                "address":addressTxtFld.text!,
                "city":cityTxtFld.text!,
                "district":stateTxtFld.text!,
                "phone_no":phoneNumberTxtFld.text!,
                "latitude":self.lat,
                "longitude":self.long,
                "customer_id":Defaults.getUserID(),
                "location_address": locationTxtFld.text!
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
                        self.view.makeToast(Bundle.main.localizedString(forKey: "Address added successfully", value: "", table: ""), duration: 0.5, position: .center)
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
extension AddAddressVC : UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case .state:
            return stateList.count
        default:
            return cityList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerType {
        case .state:
            return stateList[row].stateName
        default:
            return cityList[row].cityName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerType {
        case .state:
            if row < stateList.count {
                selectedState = stateList[row]
            }
        default:
            if row < cityList.count {
                selectedCity = cityList[row]
            }
        }
    }
    
}
extension AddAddressVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

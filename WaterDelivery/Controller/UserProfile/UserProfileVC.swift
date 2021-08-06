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
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryValue: UILabel!
    @IBOutlet weak var cusstomerID: UILabel!
    @IBOutlet weak var addressTBView: UITableView!
    @IBOutlet weak var taableHeight: NSLayoutConstraint!
    @IBOutlet weak var addresssParentView: UIView!{
        didSet {
            addresssParentView.setCornerRadiusOfView(cornerRadiusValue:15)
        }
    }
    @IBOutlet weak var generalnfoView: UIView!{
        didSet {
            generalnfoView.setCornerRadiusOfView(cornerRadiusValue:15)
        }
    }
    //MARK:- Local Variables
    var user = UserModel()
    var imagedict:[String:Data] = [:]
    var businesses = [BusinessModel]()
    var selectedBusinessType = BusinessModel()
    var dispatchGroup = DispatchGroup()
    var shippingAddressArray = Array<AddressModel>()
    var selectedAddress = AddressModel()

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAddress()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(addressTBView.contentSize.height)
        self.taableHeight.constant = self.addressTBView.contentSize.height
        addresssParentView.frame = CGRect.init(x: addresssParentView.frame.minX, y: addresssParentView.frame.minY, width: addresssParentView.frame.size.width, height: addresssParentView.frame.size.height + self.taableHeight.constant - 120)
        //addresssParentView.setShadow()
        generalnfoView.setShadow()
         
         //isScrollEnabled of table view  should be dissable because our table is inside scrollview.
        addressTBView.isScrollEnabled = false
    }
    //MARK:- Internal Methods
    func setupUI() {
        userImg.setCornerRadiusOfView(cornerRadiusValue: 75.00, setBorder: true, borderColor: .white, width: 2.0)
        saveBtn.setCornerRadiusOfView(cornerRadiusValue:30)
        setUpTBView()
    }
    func setUpTBView(){
        /// Register Cells
        self.addressTBView.register(UINib(nibName: ShippingAddressTVC.className(), bundle: nil), forCellReuseIdentifier: ShippingAddressTVC.className())
        addressTBView.tableFooterView = UIView()
        addressTBView.estimatedRowHeight = 80
        addressTBView.rowHeight = UITableView.automaticDimension
    }
    func updateUI() {
        userNameLbl.text = user.userName
        nameTxtfld.text = user.userName
        emailTxtfld.text = user.userEmail
        addressTxtfld.text = user.userAddress
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
        categoryValue.text = business?.businessName ?? "Search Category"
        cusstomerID.text = "\(Defaults.getUserID())"
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

    @objc func shippingAddrress(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            if let _ = addressTBView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? ShippingAddressTVC {
                for (index,_) in shippingAddressArray.enumerated() {
                    if index == sender.tag {
                        shippingAddressArray[index].addressSelected = true
                        self.selectedAddress = shippingAddressArray[index]
                    } else {
                        shippingAddressArray[index].addressSelected = false
                    }
                }
                addressTBView.reloadData()
            }
        }
    }
    
    @objc func editBtnAction(sender: UIButton){
        if sender.tag < shippingAddressArray.count {
            let updateAddressVC = AddAddressVC()
            updateAddressVC.addressScreenType = .updateAddress
            updateAddressVC.addressModel = shippingAddressArray[sender.tag]
            self.navigationController?.pushViewController(updateAddressVC, animated: true)
        }
    }
    
    @objc func deleteBtnAction(sender: UIButton){
        if sender.tag < shippingAddressArray.count {
            deleteAddress(addressID: shippingAddressArray[sender.tag].addressID)
        }
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
    @IBAction func openAddress(_ sender: UIButton) {
    }
    @IBAction func addAddressBtn(_ sender: UIButton) {
        let addAddressVC = AddAddressVC()
        addAddressVC.addressScreenType = .addAddress
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
}

//MARK:- API call
extension UserProfileVC: CategoryAPI {
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
                "country":"",
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
        getBusinessCategory { (businesses) in
            self.businesses = businesses
            UserData.sharedInstance.businessTypes = self.businesses
        }
    }
}

extension UserProfileVC: AddressProtocol{
    private func getAddress() {
        getAddressList(loaderRequired: false){ [weak self] in  self?.reloadAddressListSection()  }
    }
    private func reloadAddressListSection() {
        DispatchQueue.main.async {
            self.addressTBView.reloadData()
            self.taableHeight.constant = self.addressTBView.contentSize.height
            self.addresssParentView.frame = CGRect.init(x: self.addresssParentView.frame.minX, y: self.addresssParentView.frame.minY, width: self.addresssParentView.frame.size.width, height: self.addresssParentView.frame.size.height + self.taableHeight.constant - 120)
            self.view.layoutIfNeeded()
            }
    }
    
    private func deleteAddress(addressID: String) {
        deleteAddress(addressID: addressID){ [weak self] in  self?.reloadAddressListSection()  }
    }
}

//MARK:-UItableViewDataSource & UITableViewDelegate Methods
extension UserProfileVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.shippingAddressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShippingAddressTVC.className(), for: indexPath) as! ShippingAddressTVC
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnAction(sender:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(sender:)), for: .touchUpInside)
        if indexPath.row < shippingAddressArray.count {
            cell.adddressSelectionBtn.tag = indexPath.row
            cell.adddressSelectionBtn.addTarget(self, action: #selector(shippingAddrress(sender:)), for: .touchUpInside)
            cell.addressTitle.text = "Address \(indexPath.row + 1)"
            cell.setupCell(shipperAddress: shippingAddressArray[indexPath.row])
        }
        return cell
    }
    
}

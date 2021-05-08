//
//  AddressListVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 08/05/21.
//

import UIKit

class AddressListVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var addNewAddressBtn: UIButton!
    @IBOutlet weak var addressTBView: UITableView!
    
    //MARK:- Local Variables
    var addressList = Array<AddressModel>()

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAddressList()
    }
    
    //MARK:- Internal Methods
    func setUpTBView(){
        /// Register Cells
        self.addressTBView.register(UINib(nibName: AddressTVC.className(), bundle: nil), forCellReuseIdentifier: AddressTVC.className())
        addressTBView.tableFooterView = UIView()
        addressTBView.estimatedRowHeight = 150
        addressTBView.rowHeight = UITableView.automaticDimension
    }
    func setupUI() {
        setUpTBView()
        addNewAddressBtn.setCornerRadiusOfView(cornerRadiusValue: 30)
    }
    
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addNewAddressAction(_ sender: UIButton) {
        let addAddressVC = AddAddressVC()
        addAddressVC.addressScreenType = .addAddress
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    @objc func editBtnAction(sender: UIButton){
        if sender.tag < addressList.count {
            let updateAddressVC = AddAddressVC()
            updateAddressVC.addressScreenType = .updateAddress
            updateAddressVC.addressModel = addressList[sender.tag]
            self.navigationController?.pushViewController(updateAddressVC, animated: true)
        }
    }
    
    @objc func deleteBtnAction(sender: UIButton){
        if sender.tag < addressList.count {
            deleteAddress(addressID: addressList[sender.tag].addressID)
        }
    }
}

//MARK:-UITableViewDataSource Methods
extension AddressListVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTVC.className(), for: indexPath) as! AddressTVC
        cell.setupCell(addressModel: addressList[indexPath.row])
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnAction(sender:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(sender:)), for: .touchUpInside)
        return cell
    }
}

//MARK:-API call Methods

extension AddressListVC{
    func getAddressList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addressListURL : String = UrlName.baseUrl + UrlName.getAddressListUrl + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: addressListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let addresslist = jsonValue[APIField.dataKey]?.array {
                        var shippingAddress = Array<AddressModel>()
                        for address in addresslist {
                            let addressModel = AddressModel.init(json: address)
                            shippingAddress.append(addressModel)
                        }
                        self.addressList = shippingAddress
                    }
                    DispatchQueue.main.async {
                        self.addressTBView.reloadData()
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
    
    func deleteAddress(addressID: String) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addressListURL : String = UrlName.baseUrl + UrlName.deleteAddressUrl + "\(addressID)"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: addressListURL, method: .delete, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.getAddressList()
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

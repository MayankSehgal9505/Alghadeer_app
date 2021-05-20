//
//  CheckoutVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 06/05/21.
//

import UIKit

class CheckoutVC: UIViewController {
    
    //MARK:-IBOutlets

    @IBOutlet weak var checkOutTBView: UITableView!
    @IBOutlet weak var continueToPaymentBtn: UIButton!
    @IBOutlet weak var scheduleTimeView: UIView!
    
    //MARK:- Local Variables
    var paymentTypeCart = false
    private var effectView,vibrantView : UIVisualEffectView?
    var shippingAddressArray = Array<AddressModel>()
    var selectedAddress = AddressModel()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        self.checkOutTBView.register(UINib(nibName: ShippingTitleTVC.className(), bundle: nil), forCellReuseIdentifier: ShippingTitleTVC.className())
        self.checkOutTBView.register(UINib(nibName: ShippingAddressTVC.className(), bundle: nil), forCellReuseIdentifier: ShippingAddressTVC.className())
        self.checkOutTBView.register(UINib(nibName: InfoTVC.className(), bundle: nil), forCellReuseIdentifier: InfoTVC.className())
        self.checkOutTBView.register(UINib(nibName: ScheduleTimeTVC.className(), bundle: nil), forCellReuseIdentifier: ScheduleTimeTVC.className())
        self.checkOutTBView.register(UINib(nibName: PaymentTVC.className(), bundle: nil), forCellReuseIdentifier: PaymentTVC.className())
        self.checkOutTBView.register(UINib(nibName: CardTVC.className(), bundle: nil), forCellReuseIdentifier: CardTVC.className())
        self.checkOutTBView.register(UINib(nibName: SummaryTVC.className(), bundle: nil), forCellReuseIdentifier: SummaryTVC.className())
        
        checkOutTBView.tableFooterView = UIView()
        checkOutTBView.estimatedRowHeight = 150
        checkOutTBView.rowHeight = UITableView.automaticDimension
    }
    func setupUI() {
        setUpTBView()
        continueToPaymentBtn.setCornerRadiusOfView(cornerRadiusValue:30)
    }
    
    /// Hiding Picker View
    private func hidePickerView(){
        scheduleTimeView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    
    //MARK:-IBActions
    @IBAction func scheduleTimeCancelBtnActn(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func scheduleTimeSetBtnActn(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueToPaymentAction(_ sender: UIButton) {
        if (selectedAddress.addressID.isEmpty) {
            self.view.makeToast("Select delivery Address", duration: 3.0, position: .center)
        } else {
            cartCheckout()
        }
    }
    
    @objc func addAddressBtnTapped() {
        let addAddressVC = AddAddressVC()
        addAddressVC.addressScreenType = .addAddress
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    @objc func cardOptionChoosen(sender:UIButton) {
        if !sender.isSelected {
            paymentTypeCart = true
            sender.isSelected = !sender.isSelected
            if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? PaymentTVC {
                checkOutTBView.reloadSections(IndexSet.init(integer: 4), with: .top)
                cell.walletBtnChoosen.isSelected = !sender.isSelected
            }
        }
    }
    @objc func walletOptionChoosen(sender:UIButton) {
        if !sender.isSelected {
            paymentTypeCart = false
            sender.isSelected = !sender.isSelected
            if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? PaymentTVC {
                checkOutTBView.reloadSections(IndexSet.init(integer: 4), with: .top)
                cell.cardBtnChoosen.isSelected = !sender.isSelected
            }
        }
    }
    
    @objc func addMoneyToWallet(){
        let selectAmountVC = SelectAmountVC()
        selectAmountVC.delegate = self
        self.navigationController?.pushViewController(selectAmountVC, animated: true)
    }
    
    @objc func cardChoosen() {
        
    }
    
    @objc func shippingAddrress(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            if let _ = checkOutTBView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? ShippingAddressTVC {
                for (index,_) in shippingAddressArray.enumerated() {
                    if index == sender.tag-1 {
                        shippingAddressArray[index].addressSelected = true
                        self.selectedAddress = shippingAddressArray[index]
                    } else {
                        shippingAddressArray[index].addressSelected = false
                    }
                }
                checkOutTBView.reloadSections(IndexSet.init(integer: 0), with: .none)
            }
        }
    }
    
    @objc func editBtnAction(sender: UIButton){
        if sender.tag-1 < shippingAddressArray.count+1 {
            let updateAddressVC = AddAddressVC()
            updateAddressVC.addressScreenType = .updateAddress
            updateAddressVC.addressModel = shippingAddressArray[sender.tag-1]
            self.navigationController?.pushViewController(updateAddressVC, animated: true)
        }
    }
    
    @objc func deleteBtnAction(sender: UIButton){
        if sender.tag-1 < shippingAddressArray.count {
            deleteAddress(addressID: shippingAddressArray[sender.tag-1].addressID)
        }
    }
}
extension CheckoutVC{
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
                        self.shippingAddressArray = shippingAddress
                        self.selectedAddress = self.shippingAddressArray.first ?? AddressModel()
                        if self.shippingAddressArray.count >= 1 {
                            self.shippingAddressArray[0].addressSelected = true
                        }
                    }
                    DispatchQueue.main.async {
                        self.checkOutTBView.reloadSections(IndexSet.init(integer: 0), with: .none)
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
    func cartCheckout() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let checkOutURL : String = UrlName.baseUrl + UrlName.cartCheckOutUrl
            let parameters = [
                "customer_id": Defaults.getUserID(),
                "address_id":selectedAddress.addressID
            ] as [String : Any]
            print(parameters)
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: checkOutURL, method: .post, jsonObject: true,parameters: parameters, completionHandler: { (json, status) in
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
                        self.view.makeToast("Checkout successfull", duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.navigationController?.popViewController(animated: true)
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
extension CheckoutVC: SelectedAmountDelegate{
    func amountSelected(amount: String) {
        if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? PaymentTVC {
            cell.walletMoney.setTitle(amount, for: [])
        }
    }
}
//MARK:-UItableViewDataSource Methods
extension CheckoutVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     return 1 + shippingAddressArray.count
        case 1:     return 1
        case 2:     return 1
        case 3:     return 1
        case 4:     return paymentTypeCart ? 1 : 0
        case 5:     return 1
        default:    return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ShippingTitleTVC.className(), for: indexPath) as! ShippingTitleTVC
                cell.setupCellUI()
                cell.addAddressBtn.addTarget(self, action: #selector(addAddressBtnTapped), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: ShippingAddressTVC.className(), for: indexPath) as! ShippingAddressTVC
                cell.editBtn.tag = indexPath.row
                cell.deleteBtn.tag = indexPath.row
                cell.editBtn.addTarget(self, action: #selector(editBtnAction(sender:)), for: .touchUpInside)
                cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(sender:)), for: .touchUpInside)
                cell.adddressSelectionBtn.isHidden = shippingAddressArray.count == 1
                if indexPath.row-1 < shippingAddressArray.count {
                    cell.adddressSelectionBtn.tag = indexPath.row
                    cell.adddressSelectionBtn.addTarget(self, action: #selector(shippingAddrress(sender:)), for: .touchUpInside)
                    cell.setupCell(shipperAddress: shippingAddressArray[indexPath.row-1])
                }
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTVC.className(), for: indexPath) as! InfoTVC
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTimeTVC.className(), for: indexPath) as! ScheduleTimeTVC
            cell.setupCell()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTVC.className(), for: indexPath) as! PaymentTVC
            cell.cardBtnChoosen.addTarget(self, action: #selector(cardOptionChoosen), for: .touchUpInside)
            cell.walletBtnChoosen.addTarget(self, action: #selector(walletOptionChoosen), for: .touchUpInside)
            cell.walletMoney.addTarget(self, action: #selector(addMoneyToWallet), for: .touchUpInside)
            cell.setupCell()
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTVC.className(), for: indexPath) as! CardTVC
            cell.cardChoosen.addTarget(self, action: #selector(cardChoosen), for: .touchUpInside)
            cell.setupCell()
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTVC.className(), for: indexPath) as! SummaryTVC
            cell.setupCell()
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK:-UITableViewDelegate Methods

extension CheckoutVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
            self.view.window?.addSubview(scheduleTimeView)
            vibrantView = viewArray.first as? UIVisualEffectView
            effectView = (viewArray.last as? UIVisualEffectView)
            self.scheduleTimeView.isHidden = false
            CommonMethods.setPickerConstraintAccordingToDevice(pickerView: scheduleTimeView, view: self.view)
        default: break
        }
    }
}

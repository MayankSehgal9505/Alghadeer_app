//
//  CheckoutVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 06/05/21.
//

import UIKit

class CheckoutVC: UIViewController {
    //MARK:- Enums
    enum SectionType:Int, CaseIterable {
        case addAddressSelection = 0
        case addressList,info, scheduleTime, payment, summary
    }
    enum PaymentType:Int {
        case card = 0
        case wallet
    }
    //MARK:-IBOutlets

    @IBOutlet weak var checkOutTBView: UITableView!
    @IBOutlet weak var continueToPaymentBtn: UIButton!
    @IBOutlet weak var scheduleTimeView: UIView!
    @IBOutlet weak var timePickerView: UIPickerView!
    
    //MARK:- Local Variables
    
    var paymentType: PaymentType = .wallet
    private var effectView,vibrantView : UIVisualEffectView?
    var shippingAddressArray = Array<AddressModel>()
    var selectedAddress = AddressModel()
    private var walletBallance = WalletBalance()
    private var orderSummaryObj = OrderSummary()
    private var addedMoneyModel = AddMoneyModel()
    var timeArray = Array<TimeModel>()
    var deliveryTime = ""
    private var dispatchGp = DispatchGroup()

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCalls()
    }
    private func apiCalls(){
        func dispatchGpAPIS() {
            self.showHUD(progressLabel: AlertField.loaderString)
            self.dispatchGp.enter()
            self.dispatchGp.enter()
            self.dispatchGp.enter()
            self.dispatchGp.enter()
            getWalletDetails()
            getAddress()
            getTimeList()
            getSummaryData()
        }
        dispatchGpAPIS()
        dispatchGp.notify(queue: .main) {
            self.dismissHUD(isAnimated: true)
            self.checkOutTBView.reloadData()
        }
    }
    //MARK:- Internal Methods
    func setUpTBView(){
        
        /// Register Cells
        self.checkOutTBView.register(UINib(nibName: ShippingTitleTVC.className(), bundle: nil), forCellReuseIdentifier: ShippingTitleTVC.className())
        self.checkOutTBView.register(UINib(nibName: ShippingAddressTVC.className(), bundle: nil), forCellReuseIdentifier: ShippingAddressTVC.className())
        self.checkOutTBView.register(UINib(nibName: InfoTVC.className(), bundle: nil), forCellReuseIdentifier: InfoTVC.className())
        self.checkOutTBView.register(UINib(nibName: ScheduleTimeTVC.className(), bundle: nil), forCellReuseIdentifier: ScheduleTimeTVC.className())
        self.checkOutTBView.register(UINib(nibName: PaymentTVC.className(), bundle: nil), forCellReuseIdentifier: PaymentTVC.className())
        self.checkOutTBView.register(UINib(nibName: SummaryTVC.className(), bundle: nil), forCellReuseIdentifier: SummaryTVC.className())
        checkOutTBView.dataSource = self
        checkOutTBView.delegate = self
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
    
    private func moveToPaymentPage(){
        let paymentVC = PaymentVC()
        paymentVC.delegate = self
        paymentVC.urlString = addedMoneyModel.redirectUrl
        paymentVC.modalPresentationStyle = .fullScreen
        self.present(paymentVC, animated: true, completion: nil)
    }
    //MARK:-IBActions
    @IBAction func scheduleTimeCancelBtnActn(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func scheduleTimeSetBtnActn(_ sender: UIBarButtonItem) {
        hidePickerView()
        if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section:SectionType.scheduleTime.rawValue)) as? ScheduleTimeTVC {
                cell.deliveryTimeTxtFld.text = deliveryTime
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueToPaymentAction(_ sender: UIButton) {
        if (deliveryTime.isEmpty) {
            self.view.makeToast("Select Delivery Time", duration: 3.0, position: .center)
        }
         else if (selectedAddress.addressID.isEmpty) {
            self.view.makeToast("Select delivery Address", duration: 3.0, position: .center)
        } else {
            cartCheckout()
        }
    }
    // Payment Mthods
    @objc func openDeliverOptions(sender:UIButton) {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(scheduleTimeView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.scheduleTimeView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: scheduleTimeView, view: self.view)
    }
    // Payment Mthods
    @objc func cardOptionChoosen(sender:UIButton) {
        if !sender.isSelected {
            paymentType = .card
            sender.isSelected = !sender.isSelected
            if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: SectionType.payment.rawValue)) as? PaymentTVC {
                cell.walletBtnChoosen.isSelected = !sender.isSelected
            }
        }
    }
    
    @objc func walletOptionChoosen(sender:UIButton) {
        if !sender.isSelected {
            paymentType = .wallet
            sender.isSelected = !sender.isSelected
            if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: SectionType.payment.rawValue)) as? PaymentTVC {
                cell.cardBtnChoosen.isSelected = !sender.isSelected
            }
        }
    }
    
    @objc func addMoneyToWallet(){
        let selectAmountVC = SelectAmountVC()
        selectAmountVC.delegate = self
        self.navigationController?.pushViewController(selectAmountVC, animated: true)
    }
    
    //Address Methods
    @objc func addAddressBtnTapped() {
        let addAddressVC = AddAddressVC()
        addAddressVC.addressScreenType = .addAddress
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    @objc func shippingAddrress(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            if let _ = checkOutTBView.cellForRow(at: IndexPath.init(row: sender.tag, section: SectionType.addressList.rawValue)) as? ShippingAddressTVC {
                for (index,_) in shippingAddressArray.enumerated() {
                    if index == sender.tag {
                        shippingAddressArray[index].addressSelected = true
                        self.selectedAddress = shippingAddressArray[index]
                    } else {
                        shippingAddressArray[index].addressSelected = false
                    }
                }
                self.checkOutTBView.beginUpdates()
                checkOutTBView.reloadSections(IndexSet.init(integer: SectionType.addressList.rawValue), with: .none)
                self.checkOutTBView.endUpdates()
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
}

extension CheckoutVC: SelectedAmountDelegate{
    func amountSelected(amount: String) {
        if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? PaymentTVC {
            cell.walletMoney.setTitle(amount, for: [])
        }
    }
}
//MARK:-UItableViewDataSource & UITableViewDelegate Methods
extension CheckoutVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType.init(rawValue: section) else {return 0}
        switch sectionType {
        case .addAddressSelection: return 1
        case .addressList:      return shippingAddressArray.count
        case .info:             return 1
        case .scheduleTime:     return 1
        case .payment:          return 1
        case .summary:          return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SectionType.init(rawValue: indexPath.section) else {return UITableViewCell()}
        switch sectionType {
        case .addAddressSelection:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShippingTitleTVC.className(), for: indexPath) as! ShippingTitleTVC
            cell.setupCellUI()
            cell.addAddressBtn.addTarget(self, action: #selector(addAddressBtnTapped), for: .touchUpInside)
            return cell
        case .addressList:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShippingAddressTVC.className(), for: indexPath) as! ShippingAddressTVC
            cell.editBtn.tag = indexPath.row
            cell.deleteBtn.tag = indexPath.row
            cell.addressTitle.text = "Address \(indexPath.row)"
            cell.editBtn.addTarget(self, action: #selector(editBtnAction(sender:)), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(sender:)), for: .touchUpInside)
            //cell.adddressSelectionBtn.isHidden = shippingAddressArray.count == 1
            if indexPath.row < shippingAddressArray.count {
                cell.adddressSelectionBtn.tag = indexPath.row
                cell.adddressSelectionBtn.addTarget(self, action: #selector(shippingAddrress(sender:)), for: .touchUpInside)
                cell.setupCell(shipperAddress: shippingAddressArray[indexPath.row])
            }
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTVC.className(), for: indexPath) as! InfoTVC
            return cell
        case .scheduleTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTimeTVC.className(), for: indexPath) as! ScheduleTimeTVC
            cell.deliveryBtn.addTarget(self, action: #selector(openDeliverOptions), for: .touchUpInside)
            return cell
        case .payment:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTVC.className(), for: indexPath) as! PaymentTVC
            cell.cardBtnChoosen.addTarget(self, action: #selector(cardOptionChoosen), for: .touchUpInside)
            cell.walletBtnChoosen.addTarget(self, action: #selector(walletOptionChoosen), for: .touchUpInside)
            cell.walletMoney.addTarget(self, action: #selector(addMoneyToWallet), for: .touchUpInside)
            cell.setupCell(walletBalanceObj:walletBallance)
            switch paymentType {
            case .card:
                cell.cardBtnChoosen.isSelected = true
                cell.walletBtnChoosen.isSelected = false
            default:
                cell.walletBtnChoosen.isSelected = true
                cell.cardBtnChoosen.isSelected = false
            }
            return cell
        case .summary:
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTVC.className(), for: indexPath) as! SummaryTVC
            cell.setupCell(orderSummaryObj: orderSummaryObj)
            return cell
        }
    }
}
extension CheckoutVC : PaymentVCProtocol{
    func paymentSccessful(status: Int) {
        if let paymentStatus = PaymentStatus.init(rawValue: status) {
            switch paymentStatus {
            case .success:
                setPaymentStatus()
            default:
                break
            }
        } else {
            
        }
    }
}
//MARK:- Get Address List Methods
extension CheckoutVC: AddressProtocol {
    private func reloadAddressListSection() {
        DispatchQueue.main.async {
            self.checkOutTBView.beginUpdates()
            self.checkOutTBView.reloadSections(IndexSet.init(integer: SectionType.addressList.rawValue), with: .none)
            self.checkOutTBView.endUpdates()
        }
    }
    private func getAddress() {
        getAddressList(loaderRequired: false) { [weak self] in
            self?.dispatchGp.leave()
            self?.reloadAddressListSection()  }
    }
    
    private func deleteAddress(addressID: String) {
        deleteAddress(addressID: addressID){ [weak self] in  self?.reloadAddressListSection()  }
    }
    func getTimeList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let bannerListURL : String = UrlName.baseUrl + UrlName.deliveryTimeUrl
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: bannerListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dispatchGp.leave()
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let timeList = jsonValue[APIField.dataKey]?.array {
                        var timesArray = Array<TimeModel>()
                        for time in timeList {
                            let timeModel = TimeModel.init(json: time)
                            timesArray.append(timeModel)
                        }
                        self.timeArray = timesArray
                        DispatchQueue.main.async {
                            self.timePickerView.reloadAllComponents()
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                self.dispatchGp.leave()
            })
        }else{
            self.dispatchGp.leave()
            self.showNoInternetAlert()
        }
    }

}
//MARK:- API Call Methods
extension CheckoutVC: WalletAPI{
    private func setPaymentStatus() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let checkOutURL : String = UrlName.baseUrl + UrlName.paymentStatusUrl + "\(self.addedMoneyModel.transactionID)?orderId=\(addedMoneyModel.transactionOrderId)&customer_id=\(Defaults.getUserID())&wallet=\(paymentType.rawValue)"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: checkOutURL, method: .get, jsonObject: false,parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true , let data = jsonValue[APIField.dataKey]?.dictionaryValue, let _ = data["result"]?.dictionaryValue{
                    self.addedMoneyModel = AddMoneyModel.init(json:data["result"]!)
                    DispatchQueue.main.async {
                        self.view.makeToast("Checkout successfull", duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Utility.makeRootViewController()
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
    private func getWalletDetails() {
        getWalletDetails(dismissHud: false) { (walletBalance) in
            self.dispatchGp.leave()
            self.walletBallance = walletBalance
//            DispatchQueue.main.async {
//                self.checkOutTBView.beginUpdates()
//                self.checkOutTBView.reloadSections(IndexSet.init(integer: SectionType.payment.rawValue), with: .none)
//                self.checkOutTBView.endUpdates()
//            }
        }
    }
    private func getSummaryData() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let orderTotalUrl : String = UrlName.baseUrl + UrlName.orderTotalUrl
            let parameters = [
                "customer_id": Defaults.getUserID(),
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: orderTotalUrl, method: .post, jsonObject: false,parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dispatchGp.leave()
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let _ = jsonValue[APIField.dataKey]?.dictionary {
                        self.orderSummaryObj = OrderSummary.init(json: jsonValue[APIField.dataKey]!)
//                        DispatchQueue.main.async {
//                            self.checkOutTBView.beginUpdates()
//                            self.checkOutTBView.reloadSections(IndexSet.init(integer: SectionType.summary.rawValue), with: .none)
//                            self.checkOutTBView.endUpdates()
//                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.dispatchGp.leave()
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.dispatchGp.leave()
            self.showNoInternetAlert()
        }
    }
    private func cartCheckout() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let checkOutURL : String = UrlName.baseUrl + UrlName.orderCheckOutUrl
            let parameters = [
                "customer_id": Defaults.getUserID(),
                "address_id":selectedAddress.addressID,
                "wallet": "\(paymentType.rawValue)",
                "grandtotal": orderSummaryObj.orderGrandTotal,
                "delivery_time":deliveryTime,
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: checkOutURL, method: .post, jsonObject: true,parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    switch self.paymentType {
                    case .wallet:
                        DispatchQueue.main.async {
                            self.view.makeToast("Checkout successfull", duration: 0.5, position: .center)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                Utility.makeRootViewController()
                            }
                        }
                    default:
                        if let data = jsonValue[APIField.dataKey]?.dictionaryValue, let _ = data["result"]?.dictionaryValue{
                            self.addedMoneyModel = AddMoneyModel.init(json:data["result"]!)
                            DispatchQueue.main.async {
                                self.moveToPaymentPage()
                            }
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


//MARK:- Get Address List Methods
extension CheckoutVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.timeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.timeArray[row].deliveryTime
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deliveryTime = timeArray[row].deliveryTime
    }
}

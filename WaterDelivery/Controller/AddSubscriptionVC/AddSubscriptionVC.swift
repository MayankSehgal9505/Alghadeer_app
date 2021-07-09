//
//  AddSubscriptionVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 15/05/21.
//

import UIKit

class AddSubscriptionVC: CartBaseVC,AddAddressProtocol {
    
    //MARK:- Enum
    enum SectionType:Int, CaseIterable {
        case products = 0
        case selectProducts,addressList, subscriptionSlot
    }
    enum PickerType {
        case time,startDate,endDate
    }
    
    enum AddSubscriptionFor {
        case genericSubscription,singleProduct
    }
    //MARK:- IBOutlets
    @IBOutlet weak var addSubscriptionTBView: UITableView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var pickerLbl: UILabel!
    //MARK:- Local Variables
    var shippingAddressArray = Array<AddressModel>()
    var productArray = Array<ProductModel>()
    var timeArray = Array<TimeModel>()
    var selectedProductArray = Array<ProductModel>()
    var pickerType: PickerType = .startDate
    var selectedAddress = AddressModel()
    private var effectView,vibrantView : UIVisualEffectView?
    private var startDate = Date()
    private var endDate = Date()
    var deliveryTime = Date().dateStringWith(strFormat: "hh:mm a")
    private var dispatchGp = DispatchGroup()

    //MARK:- Properties
    var addingSubscriptionType: AddSubscriptionFor = .genericSubscription
    var productIDs: [String] = []

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCalls()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK:- Internal Methods
    private func apiCalls() {
        func dispatchGpAPIS() {
            self.showHUD(progressLabel: AlertField.loaderString)
            self.dispatchGp.enter()
            getAddress()
            self.dispatchGp.enter()
            getProductsList()
            self.dispatchGp.enter()
            getTimeList()
        }
        dispatchGpAPIS()
        dispatchGp.notify(queue: .main) {
            self.dismissHUD(isAnimated: true)
            self.addSubscriptionTBView.reloadData()
        }
    }
    
    private func setupUI() {
        setUpTBView()
    }
    
    private func setUpTBView(){
        /// Register Cells
        addSubscriptionTBView.register(UINib(nibName: SubscriptionProductsTVC.className(), bundle: nil), forCellReuseIdentifier: SubscriptionProductsTVC.className())        
        addSubscriptionTBView.register(UINib(nibName: SubscriptionSlotTVC.className(), bundle: nil), forCellReuseIdentifier: SubscriptionSlotTVC.className())
        addSubscriptionTBView.register(UINib(nibName: SubscriptionAddressTVC.className(), bundle: nil), forCellReuseIdentifier: SubscriptionAddressTVC.className())
        addSubscriptionTBView.register(UINib(nibName: SelectProductTVC.className(), bundle: nil), forCellReuseIdentifier: SelectProductTVC.className())
        addSubscriptionTBView.register(UINib(nibName: SubscriptionHeaderTVC.className(), bundle: nil), forCellReuseIdentifier: SubscriptionHeaderTVC.className())
        addSubscriptionTBView.tableFooterView = UIView()
        addSubscriptionTBView.estimatedRowHeight = 200
        addSubscriptionTBView.rowHeight = UITableView.automaticDimension
    }
    
    /// Hiding Picker View
    private func hidePickerView(){
        timeView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    //MARK:- SubscriptionSlotTVC Btn Actions
    @objc private func addSubscriptionBtnTapped() {
        if let cell = addSubscriptionTBView.cellForRow(at: IndexPath.init(row: 0, section:3)) as? SubscriptionSlotTVC {
            if (selectedProductArray.count <= 0) {
                self.view.makeToast("Select Product", duration: 3.0, position: .center)
            } else if (selectedAddress.addressID.isEmpty) {
                self.view.makeToast("Select delivery Address", duration: 3.0, position: .center)
            } else if (cell.startDateTxtFld.text?.isEmpty ??  true) {
                self.view.makeToast("Choose Start Date", duration: 3.0, position: .center)
            } else if (cell.endDateTxtFld.text?.isEmpty ??  true) {
                self.view.makeToast("Choose End Date", duration: 3.0, position: .center)
            } else if (endDate < startDate) {
                self.view.makeToast("End Date should be greater than start date", duration: 3.0, position: .center)
            } else if (cell.timeTxtFld.text?.isEmpty ??  true) {
                self.view.makeToast("Choose Delivery Time", duration: 3.0, position: .center)
            } else {
                checkoutSubscription()
            }
        }
    }
    @objc private func selectTimeAction() {
        pickerType = .time
        pickerLbl.text = "Select Delivery Time"
        pickerView.isHidden = true
        timePickerView.isHidden = false
        commonPickerCode()
    }
    
    @objc private func selectStartDateAction() {
        pickerType = .startDate
        pickerLbl.text = "Select Start Date"
        pickerView.datePickerMode = .date
        pickerView.minimumDate = Date()
        pickerView.isHidden = false
        timePickerView.isHidden = true
        commonPickerCode()
    }
    
    @objc private func selectEndDateAction() {
        pickerType = .endDate
        pickerLbl.text = "Select End Date"
        pickerView.datePickerMode = .date
        pickerView.minimumDate = Date()
        pickerView.isHidden = false
        timePickerView.isHidden = true
        commonPickerCode()
    }
    
    func commonPickerCode() {
        let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
        self.view.window?.addSubview(timeView)
        vibrantView = viewArray.first as? UIVisualEffectView
        effectView = (viewArray.last as? UIVisualEffectView)
        self.timeView.isHidden = false
        CommonMethods.setPickerConstraintAccordingToDevice(pickerView: timeView, view: self.view)
    }
    //MARK:- ShippingAddressTVC Btn Actions
    @objc func shippingAddrress(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            if let _ = addSubscriptionTBView.cellForRow(at: IndexPath.init(row: sender.tag, section: 2)) as? SubscriptionAddressTVC {
                for (index,_) in shippingAddressArray.enumerated() {
                    if index == sender.tag-1 {
                        shippingAddressArray[index].addressSelected = true
                        self.selectedAddress = shippingAddressArray[index]
                    } else {
                        shippingAddressArray[index].addressSelected = false
                    }
                }
                addSubscriptionTBView.reloadSections(IndexSet.init(integer: 2), with: .none)
            }
        }
    }
    
    @objc func addAddressBtnTapped() {
        let addAddressVC = AddAddressVC()
        addAddressVC.addressScreenType = .addAddress
        addAddressVC.delegate = self
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    func addressAdded() {
        getAddress(showLoader: true)
    }
    //MARK:- IBActions
    @IBAction func pickerDoneAction(_ sender: UIBarButtonItem) {
        hidePickerView()
        if let cell = addSubscriptionTBView.cellForRow(at: IndexPath.init(row: 0, section:3)) as? SubscriptionSlotTVC {
            switch pickerType {
            case .startDate:
                cell.startDateTxtFld.text = startDate.convertDate(using: "dd/MM/YYYY")
            case .endDate:
                cell.endDateTxtFld.text = endDate.convertDate(using: "dd/MM/YYYY")
            case .time:
                cell.timeTxtFld.text = deliveryTime
            }
        }
    }
    @IBAction func pickerCancelAction(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func datePickerValueChanges(_ sender: UIDatePicker) {
        switch pickerType {
        case .startDate:
            startDate = sender.date
        case .endDate:
            endDate = sender.date
        default:
            break
            //deliveryTime = sender.date.dateStringWith(strFormat: "hh:mm a")
        }
    }
    // MARK:- Selected product cell Method
    @objc func addQuantityBtn(sender:UIButton) {
        if sender.tag < selectedProductArray.count {
            if let cell = addSubscriptionTBView.cellForRow(at: IndexPath.init(row: sender.tag, section:1)) as? SelectProductTVC {
                if let currentQuanity = Int(cell.quanittyLbl.text ?? "0"), let productMaxQuantity = Int(selectedProductArray[sender.tag].quantity), currentQuanity < productMaxQuantity{
                    cell.quanittyLbl.text = String(currentQuanity + 1)
                    selectedProductArray[sender.tag].addQuantity = currentQuanity + 1
                } else {
                    self.view.makeToast("Product maximum quanity has been reached", duration: 3.0, position: .bottom)
                }
            }
        }
    }
    
    @objc func decreaseQuantityBtn(sender:UIButton) {
        if sender.tag < selectedProductArray.count {
            if let cell = addSubscriptionTBView.cellForRow(at: IndexPath.init(row: sender.tag, section:1)) as? SelectProductTVC {
                if let currentQuanity = Int(cell.quanittyLbl.text ?? "0"), currentQuanity > 0{
                    cell.quanittyLbl.text = String(currentQuanity - 1)
                    selectedProductArray[sender.tag].addQuantity = currentQuanity - 1
                    if currentQuanity == 1 {
                        // update element in product array
                        let selectedProduct = productArray.firstIndex { $0.productID == selectedProductArray[sender.tag].productID}
                        if let selectedProductIndex = selectedProduct {
                            for (index, _) in productArray.enumerated() {
                                if index == selectedProductIndex {
                                    productArray[index].productSelected = false
                                }
                            }
                        }
                        // remove product from selected product array
                        let selectedItemIndex = selectedProductArray.firstIndex { $0.productID == selectedProductArray[sender.tag].productID}
                        if let index = selectedItemIndex {
                            selectedProductArray.remove(at: index)
                        }
                        addSubscriptionTBView.reloadData()
                    }
                }
            }
        }
    }
}
//MARK:-SubscriptionProductsProtocol Methods
extension AddSubscriptionVC: SubscriptionProductsProtocol{
    func productClicked(selectedIndex: Int) {
        if selectedIndex < productArray.count {
            for (index, _) in productArray.enumerated() {
                if index == selectedIndex {
                    productArray[index].productSelected = !productArray[index].productSelected
                    if (productArray[index].productSelected) {
                        selectedProductArray.append(productArray[selectedIndex])
                    } else {
                        // app crashed here so ccommenntedd that 7 used selected product here
                        /*let selectedItemIndex = productArray.firstIndex { $0.productID == productArray[index].productID}
                        if let index = selectedItemIndex {
                            selectedProductArray.remove(at: index)
                        }*/
                        let selectedItemIndex = selectedProductArray.firstIndex { $0.productID == productArray[index].productID}
                        if let index = selectedItemIndex {
                            selectedProductArray.remove(at: index)
                        }

                    }
                }
            }
            addSubscriptionTBView.reloadData()
        }
    }
}

//MARK:-UItableViewDataSource & UITableViewDelegate  Methods
extension AddSubscriptionVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType.init(rawValue: section) else {return 0}
        switch sectionType {
        case .products: return 1
        case .selectProducts: return selectedProductArray.count
        //case 2: return shippingAddressArray.count > 1 ? 1 + shippingAddressArray.count : shippingAddressArray.count
        case .addressList: return 1 + shippingAddressArray.count
        case .subscriptionSlot: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionProductsTVC.className(), for: indexPath) as! SubscriptionProductsTVC
            cell.setupCell(productList: productArray)
            cell.subscriptionProductDelegate = self
            cell.updateCellWith()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectProductTVC.className(), for: indexPath) as! SelectProductTVC
            cell.setupCellUI(index: indexPath.row)
            cell.incQuantityBtn.addTarget(self, action: #selector(addQuantityBtn(sender:)), for: .touchUpInside)
            cell.reduceQuantityBtn.addTarget(self, action: #selector(decreaseQuantityBtn(sender:)), for: .touchUpInside)
            cell.setupcell(productData:selectedProductArray[indexPath.row])
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionHeaderTVC.className(), for: indexPath) as! SubscriptionHeaderTVC
                cell.addAddressBtn.setCornerRadiusOfView(cornerRadiusValue:13)
                cell.addAddressBtn.addTarget(self, action: #selector(addAddressBtnTapped), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionAddressTVC.className(), for: indexPath) as! SubscriptionAddressTVC
                cell.addressSelectionBtn.isHidden = shippingAddressArray.count == 1
                if indexPath.row-1 < shippingAddressArray.count {
                    cell.addressSelectionBtn.tag = indexPath.row
                    cell.addressSelectionBtn.addTarget(self, action: #selector(shippingAddrress(sender:)), for: .touchUpInside)
                    cell.setupCell(shipperAddress: shippingAddressArray[indexPath.row-1])
                }
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionSlotTVC.className(), for: indexPath) as! SubscriptionSlotTVC
            cell.selectStartDateBtn.addTarget(self, action: #selector(selectStartDateAction), for: .touchUpInside)
            cell.selectEndDateBtn.addTarget(self, action: #selector(selectEndDateAction), for: .touchUpInside)
            cell.selectTimeBtn.addTarget(self, action: #selector(selectTimeAction), for: .touchUpInside)
            cell.addSubscriptionBtn.addTarget(self, action: #selector(addSubscriptionBtnTapped), for: .touchUpInside)
            cell.setupCell()
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CGFloat((productArray.count/3 + (productArray.count%3 > 0 ? 1 : 0)) * 220)
        case 1:
            return 130
        default: return UITableView.automaticDimension
        }
    }
}
//MARK:-API Call Methods
extension AddSubscriptionVC{
    func checkoutSubscription() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let checkOutSubscriptionURL : String = UrlName.baseUrl + UrlName.addSubscriptionUrl
            var products: [[String : Any]] = [[String : Any]]()
            for product in selectedProductArray {
                let product = [
                    "product_id": Int(product.productID) ?? 0,
                    "unit_measure": "litter",
                    "price": Double(product.unitPrice) ?? 0,
                    "quantity": product.addQuantity
                ] as [String : Any]
                products.append(product)
            }
            let parameters = [
                "customer_id": Int(Defaults.getUserID()) ?? 0,
                "address_id":Int(selectedAddress.addressID) ?? 0,
                "start_date":startDate.convertDate(using: "dd-MM-yyyy"),
                "end_date":endDate.convertDate(using: "dd-MM-yyyy"),
                "delivery_time":deliveryTime,
                "data":products
            ] as [String : Any]
            print(parameters)
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: checkOutSubscriptionURL, method: .post, jsonObject: true,parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.view.makeToast("Product Subscribed", duration: 0.5, position: .center)
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

    func getProductsList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let bannerListURL : String = UrlName.baseUrl + UrlName.getProductListUrl
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
                    if let productList = jsonValue[APIField.dataKey]?.array {
                        var productArray = Array<ProductModel>()
                        for product in productList {
                            let productModel = ProductModel.init(json: product)
                            productArray.append(productModel)
                        }
                        if self.addingSubscriptionType == .singleProduct {
                            let filteredproductArray = productArray.filter { productModel -> Bool in
                                return self.productIDs.contains(productModel.productID)
                            }
                            self.productArray = filteredproductArray
                        } else {
                            self.productArray = productArray
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
//MARK:- Get Address List Methods
extension AddSubscriptionVC: AddressProtocol {
    private func reloadAddressListSection() {
        DispatchQueue.main.async {
            self.addSubscriptionTBView.beginUpdates()
            self.addSubscriptionTBView.reloadSections(IndexSet.init(integer: 2), with: .none)
            self.addSubscriptionTBView.endUpdates()
        }
    }
    private func getAddress(showLoader: Bool = false) {
        getAddressList(loaderRequired: showLoader) { [weak self] in
            DispatchQueue.main.async{
                if showLoader {
                    self?.addSubscriptionTBView.reloadData()
                } else {
                    self?.dispatchGp.leave()
                }
            }
        }
            //self?.reloadAddressListSection()  }
    }
}
//MARK:- Get Address List Methods
extension AddSubscriptionVC: UIPickerViewDataSource, UIPickerViewDelegate {
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


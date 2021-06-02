//
//  SelectAmountVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit
protocol SelectedAmountDelegate: class {
    func amountSelected(amount:String)
}
class SelectAmountVC: UIViewController {
    //MARK:-IBOutlets
    @IBOutlet weak var selectAmountTBView: UITableView!
    
    //MARK:- Local Variables
    var availableAmounts = [WalletAmount(amount: "100", amountSelected: false),WalletAmount(amount: "200", amountSelected: false),WalletAmount(amount: "400", amountSelected: false),WalletAmount(amount: "600", amountSelected: false),WalletAmount(amount: "700", amountSelected: false),WalletAmount(amount: "1000", amountSelected: false),WalletAmount(amount: "1200", amountSelected: false),WalletAmount(amount: "1300", amountSelected: false), WalletAmount(amount: "", amountSelected: false)]
    var delegate: SelectedAmountDelegate?
    var selectedAmount = WalletAmount()
    var addedMoneyModel = AddMoneyModel()
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Internal Methods
    func setUpTBView(){
        /// Register Cells
        self.selectAmountTBView.register(UINib(nibName: SelectAmountTVC.className(), bundle: nil), forCellReuseIdentifier: SelectAmountTVC.className())
        selectAmountTBView.tableFooterView = UIView()
        selectAmountTBView.estimatedRowHeight = 60
        selectAmountTBView.rowHeight = UITableView.automaticDimension
    }
    func setupUI() {
        setUpTBView()
    }
    
    private func moveToPaymentPage(){
        let paymentVC = PaymentVC()
        paymentVC.delegate = self
        paymentVC.urlString = addedMoneyModel.redirectUrl
        self.present(paymentVC, animated: true, completion: nil)
    }
    //MARK:-IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMoneyToWalletAction(_ sender: UIButton) {
        if selectedAmount.amount.isEmpty {
            self.view.makeToast("Please select/ enter amount which you want to add in you wallet", duration: 3.0, position: .center)
        } else {
            addMoneyInWallet()
        }
    }
    
    @objc func amountChoosen(sender:UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            if let _ = selectAmountTBView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? SelectAmountTVC {
                for (index,_) in availableAmounts.enumerated() {
                    if index == sender.tag {
                        availableAmounts[index].amountSelected = true
                        self.selectedAmount = availableAmounts[index]
                    } else {
                        availableAmounts[index].amountSelected = false
                    }
                }
                selectAmountTBView.reloadSections(IndexSet.init(integer: 0), with: .none)
            }
        }
    }
    
    @objc func enteringAmount(sender:UITextField) {
        if let cell = selectAmountTBView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? SelectAmountTVC {
            for (index,_) in availableAmounts.enumerated() {
                if index == sender.tag {
                    cell.manualAmount.text = sender.text!
                    availableAmounts[index].amount = sender.text!
                    availableAmounts[index].amountSelected = true
                    self.selectedAmount = availableAmounts[index]
                } else {
                    availableAmounts[index].amountSelected = false
                }
            }
            selectAmountTBView.reloadSections(IndexSet.init(integer: 0), with: .none)
        }
    }
}
extension SelectAmountVC : PaymentVCProtocol{
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
//MARK:- API Call Methods
extension SelectAmountVC {
    func setPaymentStatus() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let checkOutURL : String = UrlName.baseUrl + UrlName.paymentStatusUrl + "\(self.addedMoneyModel.transactionID)?orderId=\(addedMoneyModel.transactionOrderId)&customer_id=\(Defaults.getUserID())"
            print(checkOutURL)
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: checkOutURL, method: .get, jsonObject: false,parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true , let data = jsonValue[APIField.dataKey]?.dictionaryValue, let _ = data["result"]?.dictionaryValue{
                    self.addedMoneyModel = AddMoneyModel.init(json:data["result"]!)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
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
    func addMoneyInWallet() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let checkOutURL : String = UrlName.baseUrl + UrlName.addMoneyInWallet
            let parameters = [
                "customer_id": Defaults.getUserID(),
                "amount": selectedAmount.amount
            ] as [String : Any]
            print(parameters)
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: checkOutURL, method: .post, jsonObject: false,parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true , let data = jsonValue[APIField.dataKey]?.dictionaryValue, let _ = data["result"]?.dictionaryValue{
                    self.addedMoneyModel = AddMoneyModel.init(json:data["result"]!)
                    DispatchQueue.main.async {
                        self.moveToPaymentPage()
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

//MARK:-UItableViewDataSource Methods
extension SelectAmountVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableAmounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectAmountTVC.className(), for: indexPath) as! SelectAmountTVC
        cell.manualAmount.isHidden = indexPath.row != availableAmounts.count-1
        cell.Amount.isHidden = !cell.manualAmount.isHidden
        cell.setupCell(wallet: availableAmounts[indexPath.row])
        cell.selectedAmountBtn.tag = indexPath.row
        cell.manualAmount.tag = indexPath.row
        cell.selectedAmountBtn.addTarget(self, action: #selector(amountChoosen(sender:)), for: .touchUpInside)
        cell.manualAmount.addTarget(self, action: #selector(enteringAmount(sender:)), for: .editingChanged)
        return cell
    }
}

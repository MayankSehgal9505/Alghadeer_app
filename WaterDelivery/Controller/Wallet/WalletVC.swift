//
//  WalletVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 20/05/21.
//

import UIKit
//MARK:- Wallet API Protocol
protocol WalletAPI {}
extension WalletAPI where Self: UIViewController {
    func getWalletDetails(obtainedResult: @escaping(WalletBalance) -> Void) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let walletBalanceUrl : String = UrlName.baseUrl + UrlName.walletBalance + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: walletBalanceUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    obtainedResult(WalletBalance())
                    self.dismissHUD(isAnimated: true)
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let wallet = jsonValue[APIField.dataKey] {
                        let walletBallance = WalletBalance.init(json: wallet)
                        obtainedResult(walletBallance)
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            obtainedResult(WalletBalance.init())
            self.showNoInternetAlert()
        }
    }
}

class WalletVC: UIViewController{
    //MARK:- Enums
    enum SectionType: Int, CaseIterable {
        case walletHistory = 0
    }

    //MARK:- IBOutlets
    @IBOutlet weak var walletTBView: UITableView!
    @IBOutlet weak var netWalletView: UIView! {didSet {netWalletView.setCornerRadiusOfView(cornerRadiusValue: 13.0)}}
    @IBOutlet weak var netAvailableBalanceLblValue: UILabel!
    @IBOutlet weak var youraccountBalanceLblValue: UILabel!
    @IBOutlet weak var totalWalletMoneyValue: UILabel!
    @IBOutlet weak var addMoneyBtn: UIButton!{didSet {addMoneyBtn.setCornerRadiusOfView(cornerRadiusValue: 15.0)}}
    @IBOutlet weak var creditBtn: UIButton!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var debitedBtn: UIButton!
    @IBOutlet weak var underLineViewleading: NSLayoutConstraint!
    //MARK:- Local Variables
    private var walletBallance = WalletBalance()
    private var walletTransactions = [WalletTransactionModel]()
    private var dispatchGp = DispatchGroup()
    var selectedTextColor = UIColor.init(red: 40/255, green: 63/255, blue: 82/255, alpha: 1.0)
    var unSelectedTextColor = UIColor.black
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTBView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHUD(progressLabel: AlertField.loaderString)
        getWalletDetails()
        getAllWlalletTransactions()
        dispatchGp.notify(queue: .main, work:DispatchWorkItem.init(block: {
            self.dismissHUD(isAnimated: true)
        }))
    }
    //MARK:- Internal Methods
    private func setUpTBView(){
        /// Register Cells
        walletTBView.register(UINib(nibName: WalletHistoryTVC.className(), bundle: nil), forCellReuseIdentifier: WalletHistoryTVC.className())
        walletTBView.tableFooterView = UIView()
        walletTBView.estimatedRowHeight = 80
        walletTBView.rowHeight = UITableView.automaticDimension
    }
    private func updateUI(){
        self.netAvailableBalanceLblValue.text = "AED \(walletBallance.walletAmount)"
        self.youraccountBalanceLblValue.text = "AED \(walletBallance.walletAmount)"
        self.totalWalletMoneyValue.text = "AED \(walletBallance.walletAmount)"
    }
    //MARK:- IBActions
    @IBAction func addMoneyAction(_ sender: UIButton) {
        let selectAmountVC = SelectAmountVC()
        self.navigationController?.pushViewController(selectAmountVC, animated: true)
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func crediedAction(_ sender: UIButton) {
        debitedBtn.setTitleColor(unSelectedTextColor, for: [])
        creditBtn.setTitleColor(selectedTextColor, for: [])
        UIView.animate(withDuration: 0.25) {
            self.underLineViewleading.constant = self.creditBtn.frame.minX
        }
    }
    @IBAction func debitedAction(_ sender: UIButton) {
        debitedBtn.setTitleColor(selectedTextColor, for: [])
        creditBtn.setTitleColor(unSelectedTextColor, for: [])
        UIView.animate(withDuration: 0.25) {
            self.underLineViewleading.constant = self.debitedBtn.frame.minX
        }
    }
}
//MARK:- API Methods

extension WalletVC: WalletAPI {
    private func getAllWlalletTransactions() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            dispatchGp.enter()
            let walletBalanceUrl : String = UrlName.baseUrl + UrlName.walletTransactions + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: walletBalanceUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dispatchGp.leave()
                    self.dismissHUD(isAnimated: true)
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let transactions = jsonValue[APIField.dataKey]?.array {
                        var walletTransactions = [WalletTransactionModel]()
                        for walletTransaction in transactions {
                            let walletTransactionModel = WalletTransactionModel.init(json: walletTransaction)
                            walletTransactions.append(walletTransactionModel)
                        }
                        self.walletTransactions = walletTransactions
                        DispatchQueue.main.async {
                            self.walletTBView.beginUpdates()
                            self.walletTBView.reloadSections(IndexSet.init(integer: SectionType.walletHistory.rawValue), with: .none)
                            self.walletTBView.endUpdates()
                        }
                    }
                }
                self.dispatchGp.leave()
            })
        }else{
            dispatchGp.leave()
            self.showNoInternetAlert()
        }
    }
    private func getWalletDetails() {
        dispatchGp.enter()
        getWalletDetails { (walletBalance) in
            self.dispatchGp.leave()
            self.walletBallance = walletBalance
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
}
//MARK:- UITableViewDataSource & UITableViewDelegate Methods
extension WalletVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SectionType.init(rawValue: section) else {
            return 0
        }
        switch section {
            case .walletHistory:  return walletTransactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionType.init(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .walletHistory:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletHistoryTVC.className(), for: indexPath) as! WalletHistoryTVC
            cell.setupCell(walletTransactionObj:walletTransactions[indexPath.row])
            return cell
        }

    }
}

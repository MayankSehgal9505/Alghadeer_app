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
        case walletCurrentStatus = 0
        case walletHistory
    }

    //MARK:- IBOutlets
    @IBOutlet weak var walletTBView: UITableView!
    
    //MARK:- Local Variables
    private var walletBallance = WalletBalance()
    private var walletTransactions = [WalletTransactionModel]()
    private var dispatchGp = DispatchGroup()
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
        walletTBView.register(UINib(nibName: WalletStatusTVC.className(), bundle: nil), forCellReuseIdentifier: WalletStatusTVC.className())
        walletTBView.register(UINib(nibName: WalletHistoryTVC.className(), bundle: nil), forCellReuseIdentifier: WalletHistoryTVC.className())
        walletTBView.tableFooterView = UIView()
        walletTBView.estimatedRowHeight = 150
        walletTBView.rowHeight = UITableView.automaticDimension
    }
    
    private func updateUI(){

    }
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addMoneyBtAction() {
        let selectAmountVC = SelectAmountVC()
        self.navigationController?.pushViewController(selectAmountVC, animated: true)
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
                self.walletTBView.beginUpdates()
                self.walletTBView.reloadSections(IndexSet.init(integer: SectionType.walletCurrentStatus.rawValue), with: .none)
                self.walletTBView.endUpdates()
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
            case .walletCurrentStatus:  return 1
            case .walletHistory:  return walletTransactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionType.init(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .walletCurrentStatus:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletStatusTVC.className(), for: indexPath) as! WalletStatusTVC
            cell.addMoneyBtn.addTarget(self, action: #selector(addMoneyBtAction), for: .touchUpInside)
            cell.setupCell(walletBalanceObj: walletBallance)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletHistoryTVC.className(), for: indexPath) as! WalletHistoryTVC
            cell.setupCell(walletTransactionObj:walletTransactions[indexPath.row])
            return cell
        }

    }
}

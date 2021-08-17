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
    func getWalletDetails(dismissHud:Bool = true,obtainedResult: @escaping(WalletBalance) -> Void) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            if (dismissHud) {
                self.showHUD(progressLabel: AlertField.loaderString)
            }
            let walletBalanceUrl : String = UrlName.baseUrl + UrlName.walletBalance + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: walletBalanceUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    obtainedResult(WalletBalance())
                    if (dismissHud) {
                        self.dismissHUD(isAnimated: true)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let wallet = jsonValue[APIField.dataKey] {
                        let walletBallance = WalletBalance.init(json: wallet)
                        obtainedResult(walletBallance)
                    }
                } else {
                    obtainedResult(WalletBalance.init())
                }
                DispatchQueue.main.async {
                    if (dismissHud) {
                        self.dismissHUD(isAnimated: true)
                    }
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
    enum RowType: Int, CaseIterable {
        case monthType = 0
        case walletHistory = 1
    }

    enum WalletHistoryType{
        case debited
        case credited
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
    @IBOutlet weak var noHistoryView: UIView!
    @IBOutlet weak var netAvailableBalanceLbl: UILabel!
    @IBOutlet weak var yourAccountBalanceLbl: UILabel!
    @IBOutlet weak var totalWalletMoneyLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!

    
    //MARK:- Local Variables
    private var walletBallance = WalletBalance()
    private var walletTransactions = [WalletTransaction]()
    private var dispatchGp = DispatchGroup()
    var selectedTextColor = UIColor.init(red: 40/255, green: 63/255, blue: 82/255, alpha: 1.0)
    var unSelectedTextColor = UIColor.black
    var walletHistoryType:WalletHistoryType = .debited
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTBView()
        netAvailableBalanceLbl.text = Bundle.main.localizedString(forKey: "Net Available Balance", value: "", table: "")
        yourAccountBalanceLbl.text = Bundle.main.localizedString(forKey: "Your Account Balance", value: "", table: "")
        totalWalletMoneyLbl.text = Bundle.main.localizedString(forKey: "Total Wallet Money", value: "", table: "")
        noteLbl.text = Bundle.main.localizedString(forKey: "Notes: Wallet balance will be deducted at the time of delivery of order", value: "", table: "")
        creditBtn.setTitle(Bundle.main.localizedString(forKey: "Credited", value: "", table: ""), for: [])
        debitedBtn.setTitle(Bundle.main.localizedString(forKey: "Debited", value: "", table: ""), for: [])
        addMoneyBtn.setTitle(Bundle.main.localizedString(forKey: "Add Money", value: "", table: ""), for: [])
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
        if (walletHistoryType == .credited) {
            return
        } else {
            self.showHUD(progressLabel: AlertField.loaderString)
            walletTransactions.removeAll()
            self.walletTBView.reloadData()
            walletHistoryType = .credited
            debitedBtn.setTitleColor(unSelectedTextColor, for: [])
            creditBtn.setTitleColor(selectedTextColor, for: [])
            UIView.animate(withDuration: 0.25) {
                self.underLineViewleading.constant = self.creditBtn.frame.minX
            }
            getAllWlalletTransactions(showLoder: true)
        }
    }
    @IBAction func debitedAction(_ sender: UIButton) {
        if (walletHistoryType == .debited) {
            return
        } else {
            self.showHUD(progressLabel: AlertField.loaderString)
            walletTransactions.removeAll()
            self.walletTBView.reloadData()
            walletHistoryType = .debited
            debitedBtn.setTitleColor(selectedTextColor, for: [])
            creditBtn.setTitleColor(unSelectedTextColor, for: [])
            UIView.animate(withDuration: 0.25) {
                self.underLineViewleading.constant = self.debitedBtn.frame.minX
            }
            getAllWlalletTransactions(showLoder: true)
        }
    }
}
//MARK:- API Methods

extension WalletVC: WalletAPI {
    private func getAllWlalletTransactions(showLoder:Bool = false) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            dispatchGp.enter()
            let walletBalanceUrl : String = UrlName.baseUrl + (walletHistoryType == .debited ? UrlName.walletTransactionsDebit : UrlName.walletTransactionsCredit) + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: walletBalanceUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dispatchGp.leave()
                    self.dismissHUD(isAnimated: true)
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let transactions = jsonValue[APIField.dataKey]?.array {
                        var walletTransactions = [WalletTransaction]()
                        for walletTransaction in transactions {
                            let walletTransactionModel = WalletTransaction.init(json: walletTransaction)
                            walletTransactions.append(walletTransactionModel)
                        }
                        self.walletTransactions = walletTransactions
                        DispatchQueue.main.async {
                            if showLoder {
                                self.dismissHUD(isAnimated: true)
                            }
                            if walletTransactions.count == 0 {
                                self.noHistoryView.isHidden = false
                                self.walletTBView.isHidden = true
                            } else {
                                self.noHistoryView.isHidden = true
                                self.walletTBView.isHidden = false
                            }
                            self.walletTBView.reloadData()
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
        return walletTransactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + walletTransactions[section].walletTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
                }
                return cell
            }()
            cell.backgroundColor = .clear
            cell.textLabel?.text = walletTransactions[indexPath.section].date
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletHistoryTVC.className(), for: indexPath) as! WalletHistoryTVC
            cell.setupCell(walletTransactionObj:walletTransactions[indexPath.section].walletTransactions[indexPath.row-1])
            return cell
        }
    }
}

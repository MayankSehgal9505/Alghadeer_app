//
//  SubscriptionVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 14/05/21.
//

import UIKit
//MARK:- enums
enum SubscriptionTab {
    case active
    case paused
    case cancelled
    
    var subscriptionName:String {
        switch self {
        case .active: return "INI"
        case .paused: return "PD"
        default: return "CN"
        }
    }
    
    var noSubscriptionMsg:String {
    switch self {
    case .active: return "No active Subscription"
    case .paused: return "No paused Subscription"
    default: return "No cancelled Subscription"
    }
}

}

class SubscriptionVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var cardCountView: UIView! {didSet {self.cardCountView.makeViewCircle()}}
    @IBOutlet weak var cardCountlbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var activeSubscriptionBtn: UIButton!
    @IBOutlet weak var pausedSubscriptionBtn: UIButton!
    @IBOutlet weak var cancelledSubscriptioBtn: UIButton!
    @IBOutlet weak var subscriptionTBView: UITableView!
    @IBOutlet weak var noSubscriptionTxt: UILabel!
    //MARK:- Local Variables
    let inactiveTabColor = UIColor.init(red: 153/255, green: 152/255, blue: 155/255, alpha: 1.0)
    let activeTabColor = UIColor.init(red: 23/255, green: 85/255, blue: 152/255, alpha: 1.0)
    private var selectedSubscriptionTab:SubscriptionTab = .active {
        didSet {
            setupTabs()
        }
    }
    
    var subscriptions = [SubscriptionModel]()
    var filteredSubscriptions = [SubscriptionModel]()
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSubscriptionList()
    }
    //MARK:- Internal Methods
    private func setupUI() {
        setUpTBView()
        setupTabs()
        cartView(hidden: true, count: "0")
    }
    
    private func setUpTBView(){
        /// Register Cells
        subscriptionTBView.register(UINib(nibName: SubscriptionTVC.className(), bundle: nil), forCellReuseIdentifier: SubscriptionTVC.className())
        subscriptionTBView.tableFooterView = UIView()
        subscriptionTBView.estimatedRowHeight = 200
        subscriptionTBView.rowHeight = UITableView.automaticDimension
    }
    private func setupTabs() {
        switch selectedSubscriptionTab {
        case .active:
            pausedSubscriptionBtn.backgroundColor = inactiveTabColor
            cancelledSubscriptioBtn.backgroundColor = inactiveTabColor
            activeSubscriptionBtn.backgroundColor = activeTabColor
        case .paused:
            pausedSubscriptionBtn.backgroundColor = activeTabColor
            cancelledSubscriptioBtn.backgroundColor = inactiveTabColor
            activeSubscriptionBtn.backgroundColor = inactiveTabColor
        default:
            pausedSubscriptionBtn.backgroundColor = inactiveTabColor
            cancelledSubscriptioBtn.backgroundColor = activeTabColor
            activeSubscriptionBtn.backgroundColor = inactiveTabColor
        }
    }

    func cartView(hidden: Bool, count:String) {
        cardCountView.isHidden = hidden
        cardCountlbl.text = count
    }
    
    //MARK:- IBActions
    @IBAction func notificationBtnAction(_ sender: UIButton) {
    }
    @IBAction func cartBtnAction(_ sender: UIButton) {
        let cartVC = CartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addBtnAction(_ sender: UIButton) {
        let addSubscriptionVC = AddSubscriptionVC()
        self.navigationController?.pushViewController(addSubscriptionVC, animated: true)
    }
    @IBAction func activeBtnAction(_ sender: UIButton) {
        if selectedSubscriptionTab != .active {
            selectedSubscriptionTab = .active
            // update filter array here
            setupTabs()
            getSubscriptionList()
        }
    }
    
    @IBAction func pauseBtnAction(_ sender: UIButton) {
        if selectedSubscriptionTab != .paused {
            selectedSubscriptionTab = .paused
            // update filter array here
            setupTabs()
            getSubscriptionList()
        }
    }
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        if selectedSubscriptionTab != .cancelled {
            selectedSubscriptionTab = .cancelled
            // update filter array here
            setupTabs()
            getSubscriptionList()
        }
    }
    
    @objc func pauseReactivateAction(sender: UIButton) {
        
    }
    
    @objc func cancelAction(sender: UIButton) {
        
    }
}
//MARK:-API Call Methods
extension SubscriptionVC{
    func getSubscriptionList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let subscriptionURL : String = UrlName.baseUrl + UrlName.getSubscriptionUrl + Defaults.getUserID() + "/\(selectedSubscriptionTab.subscriptionName)"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: subscriptionURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let allSubscriptions = jsonValue[APIField.dataKey]?.array {
                        var subscriptions = Array<SubscriptionModel>()
                        for subscription in allSubscriptions {
                            let subscriptionModel = SubscriptionModel.init(json: subscription)
                            subscriptions.append(subscriptionModel)
                        }
                        self.subscriptions = subscriptions
                        // add active subs in filtered subs
                    }
                    DispatchQueue.main.async {
                        self.subscriptionTBView.reloadData()
                        self.subscriptionTBView.isHidden = self.subscriptions.count == 0
                        self.noSubscriptionTxt.text = self.selectedSubscriptionTab.noSubscriptionMsg
                        self.noSubscriptionTxt.isHidden = self.subscriptions.count != 0
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
    
    func getCartCountList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let cartCountURL : String = UrlName.baseUrl + UrlName.getCartCountUrl + Defaults.getUserID()
            let parameters = [
                "customer_id":Defaults.getUserID(),
            ] as [String : Any]
            NetworkManager.sharedInstance.commonApiCall(url: cartCountURL, method: .get, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        if let cartCountString = jsonValue["TotalCount"]?.stringValue, let cartCount = Int(cartCountString), cartCount > 0 {
                            self.cartView(hidden: false, count: cartCountString)
                        } else {
                            self.cartView(hidden: true, count: "0")
                        }
                    }
                }
            })
        }
    }
}
//MARK:-UItableViewDataSource Methods
extension SubscriptionVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionTVC.className(), for: indexPath) as! SubscriptionTVC
        cell.setupCell(index: indexPath.row,tabType: selectedSubscriptionTab)
        cell.pauseReactivateBtn.addTarget(self, action: #selector(pauseReactivateAction(sender:)), for: .touchUpInside)
        cell.cancelBtn.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        cell.setupCellData(subscriptionModel:subscriptions[indexPath.row])
        return cell
    }
}

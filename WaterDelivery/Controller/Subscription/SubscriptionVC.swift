//
//  SubscriptionVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 14/05/21.
//

import UIKit
//MARK:- enums
enum SubscriptionTab: Int {
    case active = 0
    case paused,cancelled
    
    var subscriptionName:String {
        switch self {
            case .active: return "INI"
            case .paused: return "PD"
            default: return "CN"
        }
    }
    
    var noSubscriptionMsg:String {
        switch self {
            case .active: return Bundle.main.localizedString(forKey: "No Data found", value: "", table: "")
            case .paused: return Bundle.main.localizedString(forKey: "No Data found", value: "", table: "")
            default: return Bundle.main.localizedString(forKey: "No Data found", value: "", table: "")
        }
    }
}
class SubscriptionVC: CartBaseVC{

    //MARK:- IBOutlets
    @IBOutlet weak var subscriptionLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton! {
        didSet {
            addBtn.setCornerRadiusOfView(cornerRadiusValue: 7)
            addBtn.setTitle(Bundle.main.localizedString(forKey: "Add", value: "", table: ""), for: [])
        }
    }
    @IBOutlet weak var subscriptionTBView: UITableView!
    @IBOutlet weak var noSubscriptionTxt: UILabel!
    @IBOutlet var subscriptionBtns: [UIButton]! {
        didSet {
            subscriptionBtns.forEach { $0.setCornerRadiusOfView(cornerRadiusValue: 10)
                $0.setTitle(Bundle.main.localizedString(forKey: $0.currentTitle!, value: "", table: ""), for: [])
            }
        }
    }
    //MARK:- Local Variables
    private let inactiveTabColor = UIColor.init(red: 83/255, green: 116/255, blue: 159/255, alpha: 1.0)
    private let activeTabColor = UIColor.init(red: 23/255, green: 62/255, blue: 118/255, alpha: 1.0)
    private var selectedSubscriptionTab:SubscriptionTab = .active {
        didSet {
            setupTabs()
            getSubscriptionList()
        }
    }
    
    private var subscriptions = [SubscriptionModel]()
    private var filteredSubscriptions = [SubscriptionModel]()
    
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
        setSubscriptionBtnTag()
        subscriptionLbl.text = Bundle.main.localizedString(forKey: "Subscriptions", value: "", table: "")
    }
    
    private func setSubscriptionBtnTag() {
        for (index,_) in subscriptionBtns.enumerated() {
            guard let tabType = SubscriptionTab.init(rawValue: index) else {return}
            subscriptionBtns[index].tag = tabType.rawValue
        }
    }
    private func setUpTBView(){
        /// Register Cells
        subscriptionTBView.register(UINib(nibName: SubscriptionTVC.className(), bundle: nil), forCellReuseIdentifier: SubscriptionTVC.className())
        subscriptionTBView.tableFooterView = UIView()
        subscriptionTBView.estimatedRowHeight = 200
        subscriptionTBView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTabs() {
        for (index,_) in subscriptionBtns.enumerated() {
            subscriptionBtns[index].backgroundColor = selectedSubscriptionTab.rawValue == index ? activeTabColor : inactiveTabColor
        }
    }

    @objc private func pauseReactivateAction(sender: UIButton) {
        if sender.tag < subscriptions.count {
            updateSubscription(subscriptionObj: subscriptions[sender.tag], status: selectedSubscriptionTab == .active ? "PD" : "INI" )
        }
    }
    @objc private func cancelAction(sender: UIButton) {
        if sender.tag < subscriptions.count {
            updateSubscription(subscriptionObj: subscriptions[sender.tag], status: "CN")
        }
    }
    //MARK:- IBActions
    @IBAction func notificationBtnAction(_ sender: UIButton) {
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addBtnAction(_ sender: UIButton) {
        let addSubscriptionVC = AddSubscriptionVC()
        self.navigationController?.pushViewController(addSubscriptionVC, animated: true)
    }
    @IBAction func subscriptionAction(_ sender: UIButton) {
        guard let tabType = SubscriptionTab.init(rawValue: sender.tag) else {return}
        if selectedSubscriptionTab != tabType {
            selectedSubscriptionTab = tabType
        }
    }
}
//MARK:-API Call Methods
extension SubscriptionVC{
    func getSubscriptionList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let subscriptionURL : String = UrlName.baseUrl + UrlName.getSubscriptionUrl + Defaults.getUserID() + "/\(selectedSubscriptionTab.subscriptionName)" + "/\(Defaults.getEnglishLangauge() == "en" ? 1 : 2)"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: subscriptionURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let allSubscriptions = jsonValue[APIField.dataKey]?.array {
                        var subscriptions = Array<SubscriptionModel>()
                        for subscription in allSubscriptions {
                            let subscriptionModel = SubscriptionModel.init(json: subscription)
                            subscriptions.append(subscriptionModel)
                        }
                        self.subscriptions = subscriptions
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
    
    func updateSubscription(subscriptionObj: SubscriptionModel, status: String) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let updateSubscriptionURL : String = UrlName.baseUrl + UrlName.updateSubscriptionUrl + subscriptionObj.productOrderID
            let parameters = [
                "status":status,
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: updateSubscriptionURL, method: .put, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.view.makeToast("Subscription updated", duration: 3.0, position: .bottom)
                        self.getSubscriptionList()
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

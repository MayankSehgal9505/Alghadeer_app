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
    //MARK:- Local Variables
    let inactiveTabColor = UIColor.init(red: 153/255, green: 152/255, blue: 155/255, alpha: 1.0)
    let activeTabColor = UIColor.init(red: 23/255, green: 85/255, blue: 152/255, alpha: 1.0)
    private var selectedSubscriptionTab:SubscriptionTab = .active {
        didSet {
            setupTabs()
        }
    }
    
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupUI()
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
            setupTabs()
            subscriptionTBView.reloadData()
        }
    }
    
    @IBAction func pauseBtnAction(_ sender: UIButton) {
        if selectedSubscriptionTab != .paused {
            selectedSubscriptionTab = .paused
            setupTabs()
            subscriptionTBView.reloadData()
        }
    }
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        if selectedSubscriptionTab != .cancelled {
            selectedSubscriptionTab = .cancelled
            setupTabs()
            subscriptionTBView.reloadData()
        }
    }
}
//MARK:-API Call Methods
extension SubscriptionVC{
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionTVC.className(), for: indexPath) as! SubscriptionTVC
        cell.setupCell(tabType: selectedSubscriptionTab)
        return cell
    }
}

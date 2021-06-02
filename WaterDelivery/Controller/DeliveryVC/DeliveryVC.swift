//
//  DeliveryVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 20/05/21.
//

import UIKit

class DeliveryVC: UIViewController {
    //MARK:- Enums
    enum RowType:Int {
        case month = 0
        case deliveryInfo
    }
    //MARK:- IBOutlets

    @IBOutlet weak var deliveryTBView: UITableView!
    @IBOutlet weak var noDeliveryProduct: UILabel!
    //MARK:- Local Variables
    var orderList = [Order]()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTBView()
        getDeliveredProductList()
    }
    //MARK:- Internal Methods
    private func setUpTBView(){
        /// Register Cells
        deliveryTBView.register(UINib(nibName: DeliveryTVC.className(), bundle: nil), forCellReuseIdentifier: DeliveryTVC.className())
        deliveryTBView.register(UINib(nibName: DeliveryHeaderTVC.className(), bundle: nil), forCellReuseIdentifier: DeliveryHeaderTVC.className())
        deliveryTBView.tableFooterView = UIView()
        deliveryTBView.estimatedRowHeight = 150
        deliveryTBView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK:- IBActions

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableViewDataSource & UITableViewDelegate Methods
extension DeliveryVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + orderList[section].deliveredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = RowType.init(rawValue: indexPath.row) ?? .deliveryInfo
        switch rowType {
        case .month:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryHeaderTVC.className(), for: indexPath) as! DeliveryHeaderTVC
            cell.setupCell(monthName:orderList[indexPath.section].orderMonth)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryTVC.className(), for: indexPath) as! DeliveryTVC
            cell.setupCell(deliveryProductObj: orderList[indexPath.section].deliveredProducts[indexPath.row-1])
            return cell
        }

    }
}

//MARK:- API Calls
extension DeliveryVC {
    func getDeliveredProductList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let orderListUrl : String = UrlName.baseUrl + UrlName.orderListUrl
            let parameters = [
            "customer_id":Defaults.getUserID()
            ] as [String : Any]
            print(parameters)
            NetworkManager.viewControler = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NetworkManager.sharedInstance.commonApiCall(url: orderListUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
                    guard let jsonValue = json?.dictionaryValue else {
                        DispatchQueue.main.async {
                            self.dismissHUD(isAnimated: true)
                            self.view.makeToast(status, duration: 3.0, position: .bottom)
                        }
                        return
                    }
                    //print(jsonValue)
                    if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                        if let orders = jsonValue[APIField.dataKey]?.array {
                            var orderList = Array<Order>()
                            for order in orders {
                                let orderModel = Order.init(json: order)
                                orderList.append(orderModel)
                            }
                            self.orderList = orderList
                        }
                        DispatchQueue.main.async {
                            self.deliveryTBView.isHidden = self.orderList.count <= 0
                            self.noDeliveryProduct.isHidden = !self.deliveryTBView.isHidden
                            self.deliveryTBView.reloadData()
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
            }
        }else{
            self.showNoInternetAlert()
        }
    }
}


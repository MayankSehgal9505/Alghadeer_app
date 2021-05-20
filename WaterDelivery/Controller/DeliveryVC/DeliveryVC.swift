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
    //MARK:- Local Variables
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTBView()
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = RowType.init(rawValue: indexPath.row) ?? .deliveryInfo
        switch rowType {
        case .month:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryHeaderTVC.className(), for: indexPath) as! DeliveryHeaderTVC
            cell.setupCell()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryTVC.className(), for: indexPath) as! DeliveryTVC
            cell.setupCell()
            return cell
        }

    }
}

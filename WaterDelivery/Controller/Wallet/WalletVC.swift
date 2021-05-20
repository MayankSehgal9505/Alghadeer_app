//
//  WalletVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 20/05/21.
//

import UIKit

class WalletVC: UIViewController {
    //MARK:- Enums
    enum SectionType: Int, CaseIterable {
        case walletCurrentStatus = 0
        case walletHistory
    }

    //MARK:- IBOutlets
    @IBOutlet weak var walletTBView: UITableView!
    
    //MARK:- Local Variables
    
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTBView()
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
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addMoneyBtAction() {
        let selectAmountVC = SelectAmountVC()
        self.navigationController?.pushViewController(selectAmountVC, animated: true)
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
            case .walletHistory:  return 5
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
            cell.setupCell()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletHistoryTVC.className(), for: indexPath) as! WalletHistoryTVC
            cell.setupCell()
            return cell
        }

    }
}

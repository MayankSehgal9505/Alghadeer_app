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
    var amount = ["100","200","400","600","700","1000","1200","1300"]
    var delegate: SelectedAmountDelegate?
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
    
    //MARK:-IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func amountChoosen(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag < amount.count {
            delegate?.amountSelected(amount: amount[sender.tag])
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK:-UItableViewDataSource Methods
extension SelectAmountVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectAmountTVC.className(), for: indexPath) as! SelectAmountTVC
        cell.setupCell(amount: amount[indexPath.row])
        cell.selectedAmountBtn.tag = indexPath.row
        cell.selectedAmountBtn.addTarget(self, action: #selector(amountChoosen(sender:)), for: .touchUpInside)
        return cell
    }
}

//
//  WalletStatusTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 20/05/21.
//

import UIKit

class WalletStatusTVC: UITableViewCell {

    @IBOutlet weak var accountBalanceValue: UILabel!
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var addMoneyBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(walletBalanceObj:WalletBalance) {
        accountBalanceValue.text = "AED \((walletBalanceObj.walletAmount))"
        walletBalance.text = "AED \(walletBalanceObj.walletAmount)"
    }
}

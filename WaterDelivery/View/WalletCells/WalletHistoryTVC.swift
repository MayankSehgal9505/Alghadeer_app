//
//  WalletHistoryTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 20/05/21.
//

import UIKit

class WalletHistoryTVC: UITableViewCell {
    @IBOutlet weak var productItem: UILabel!
    @IBOutlet weak var productPurchaseDate: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(walletTransactionObj:WalletTransactionModel) {
        productItem.text = walletTransactionObj.comment
        productPurchaseDate.text = ""
        productAmount.text = "AED \(walletTransactionObj.amt)"
    }
    
}

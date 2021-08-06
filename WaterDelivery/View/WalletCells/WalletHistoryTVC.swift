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
        productItem.text = "Order Id: \(walletTransactionObj.comment)"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd yyyy"

        let date: Date? = dateFormatterGet.date(from: walletTransactionObj.transactionDate)
        productPurchaseDate.text = dateFormatterPrint.string(from: date!)
        if walletTransactionObj.trans_type == "1" {
            productAmount.text = "AED -\(walletTransactionObj.amt)"
            productAmount.textColor = .red
        } else {
            productAmount.text = "AED \(walletTransactionObj.amt)"
            productAmount.textColor = .blue     
        }
    }
    
}

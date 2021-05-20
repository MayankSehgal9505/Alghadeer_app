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
    
    func setupCell() {
        productItem.text = "Al Ain Bottled Dinking Water"
        productPurchaseDate.text = "2 March 10:00 AM"
        productAmount.text = "AED 0.00"
    }
    
}

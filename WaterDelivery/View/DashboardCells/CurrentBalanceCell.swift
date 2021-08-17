//
//  CurrentBalanceCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 15/07/21.
//

import UIKit

class CurrentBalanceCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var currentWalletBalanceText: UILabel!
    @IBOutlet weak var refreshText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCellUI() {
        currentWalletBalanceText.text = Bundle.main.localizedString(forKey: "Current Wallet Balance", value: nil, table: nil)
        refreshText.text = Bundle.main.localizedString(forKey: "Please click the refresh button to update wallet balance", value: nil, table: nil)
    }
    
}

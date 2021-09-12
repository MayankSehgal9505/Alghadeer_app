//
//  SubscriptionHeaderTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 18/05/21.
//

import UIKit

class SubscriptionHeaderTVC: UITableViewCell {

    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var selectAddressLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        selectAddressLbl.text = Bundle.main.localizedString(forKey: "Select Addrees", value: "", table: "")
        addAddressBtn.setTitle(Bundle.main.localizedString(forKey: "ADD ADDRESS", value: "", table: ""), for: [])
    }
}

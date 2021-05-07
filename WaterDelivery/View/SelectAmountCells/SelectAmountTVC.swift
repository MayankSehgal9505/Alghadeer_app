//
//  SelectAmountTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class SelectAmountTVC: UITableViewCell {

    @IBOutlet weak var selectedAmountBtn: UIButton!
    @IBOutlet weak var Amount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(amount: String) {
        Amount.text = amount
    }
    
}

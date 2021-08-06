//
//  DeliveryHeaderTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 20/05/21.
//

import UIKit

class DeliveryHeaderTVC: UITableViewCell {

    @IBOutlet weak var deliveryMonth: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(monthName:String) {
        deliveryMonth.text = monthName
    }
}

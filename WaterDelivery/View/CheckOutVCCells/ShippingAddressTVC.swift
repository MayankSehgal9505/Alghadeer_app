//
//  ShippingAddressTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 06/05/21.
//

import UIKit

class ShippingAddressTVC: UITableViewCell {

    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var shipperName: UILabel!
    @IBOutlet weak var shipperstreetAddress: UILabel!
    @IBOutlet weak var shipperCountry: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        greyView.setCornerRadiusOfView(cornerRadiusValue:28)
        self.shipperName.text = "Mayank Sehgal"
        self.shipperstreetAddress.text = "100/11 Chakarwarti Maholla, Thanesar"
        self.shipperName.text = "Kurukshetra, Haryana, India 136118"
    }
}

//
//  ShippingTitleTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 06/05/21.
//

import UIKit

class ShippingTitleTVC: UITableViewCell {

    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var selectDeliveryAddressText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellUI(){
        selectDeliveryAddressText.text = Bundle.main.localizedString(forKey: "Select Delivery Address", value: nil, table: nil)
        addAddressBtn.setCornerRadiusOfView(cornerRadiusValue:13)
        greyView.setCornerRadiusOfView(cornerRadiusValue:28)
    }
}

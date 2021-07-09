//
//  SubscriptionAddressTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 16/05/21.
//

import UIKit

class SubscriptionAddressTVC: UITableViewCell {

    @IBOutlet weak var addressParentView: UIView!
    @IBOutlet weak var reeceiverName: UILabel!
    @IBOutlet weak var receiverAddress: UILabel!
    @IBOutlet weak var addressSelectionBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(shipperAddress:AddressModel) {
        addressParentView.setCornerRadiusOfView(cornerRadiusValue: 25)
        self.reeceiverName.text = "\(shipperAddress.shippingFname) \(shipperAddress.shippingLname)"
        self.receiverAddress.text = "\(shipperAddress.shippingAddress), \(shipperAddress.shippingCity), \(shipperAddress.shippingState) \(shipperAddress.shippingPostCode) \n \(shipperAddress.shippingCountry)"
        self.addressSelectionBtn.isSelected = shipperAddress.addressSelected
    }
}

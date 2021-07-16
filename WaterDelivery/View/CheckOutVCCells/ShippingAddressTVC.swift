//
//  ShippingAddressTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 06/05/21.
//

import UIKit

class ShippingAddressTVC: UITableViewCell {

    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var manageAddressView: UIView!
    @IBOutlet weak var shippingTxtView: UIView!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var shipperName: UILabel!
    @IBOutlet weak var shipperstreetAddress: UILabel!
    @IBOutlet weak var shipperCountry: UILabel!
    @IBOutlet weak var adddressSelectionBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(shipperAddress:AddressModel) {
        editBtn.setCornerRadiusOfView(cornerRadiusValue:15)
        deleteBtn.setCornerRadiusOfView(cornerRadiusValue:15)
        greyView.setCornerRadiusOfView(cornerRadiusValue:28)
        self.shipperName.text = "\(shipperAddress.shippingFname) \(shipperAddress.shippingLname)"
        self.shipperstreetAddress.text = "\(shipperAddress.shippingAddress), \(shipperAddress.shippingCity), \(shipperAddress.shippingState) \(shipperAddress.shippingPostCode) \n \(shipperAddress.shippingCountry)"
        self.shipperCountry.text = "Phone Number: \(shipperAddress.shippingPhoneNumber)"
        self.adddressSelectionBtn.isSelected = shipperAddress.addressSelected
    }
}

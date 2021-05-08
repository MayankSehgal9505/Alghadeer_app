//
//  AddressTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 08/05/21.
//

import UIKit

class AddressTVC: UITableViewCell {

    @IBOutlet weak var recieverName: UILabel!
    @IBOutlet weak var receiverAddress: UILabel!
    @IBOutlet weak var receiverContact: UILabel!
    @IBOutlet weak var greyView: UIView!
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
    
    func setupCell(addressModel:AddressModel) {
        greyView.setCornerRadiusOfView(cornerRadiusValue:20)
        editBtn.setCornerRadiusOfView(cornerRadiusValue:15)
        deleteBtn.setCornerRadiusOfView(cornerRadiusValue:15)
        self.recieverName.text = "\(addressModel.shippingFname) \(addressModel.shippingLname)"
        self.receiverAddress.text = "\(addressModel.shippingAddress), \(addressModel.shippingCity), \(addressModel.shippingState) \(addressModel.shippingPostCode) \n \(addressModel.shippingCountry)"
        self.receiverContact.text = "Phone Number: \(addressModel.shippingPhoneNumber)"
    }
}

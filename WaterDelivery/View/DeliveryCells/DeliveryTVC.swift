//
//  DeliveryTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 20/05/21.
//

import UIKit

class DeliveryTVC: UITableViewCell {

    @IBOutlet weak var deliveryTypeLbl: UILabel!
    @IBOutlet weak var deliveryDate: UILabel!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var deliveyPrice: UILabel!
    @IBOutlet weak var deliveryBaseView: UIView!
    @IBOutlet weak var deliveryStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(deliveryProductObj:DeliveredProductsModel) {
        deliveryBaseView.setCornerRadiusOfView(cornerRadiusValue:10)
        deliveryTypeLbl.text = deliveryProductObj.deliveredProductType.deliveredProductStr
        orderID.text = deliveryProductObj.orderID
        deliveryDate.text = "\(deliveryProductObj.deliveryTime)"
        deliveryAddress.text = "\(deliveryProductObj.address.shippingAddress), \(deliveryProductObj.address.shippingCity), \(deliveryProductObj.address.shippingState) \(deliveryProductObj.address.shippingCountry)"
        deliveyPrice.text = "AED \(deliveryProductObj.totalAmount)"
        deliveryStatus.text = deliveryProductObj.status
    }
}

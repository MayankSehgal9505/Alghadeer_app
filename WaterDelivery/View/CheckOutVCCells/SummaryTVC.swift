//
//  SummaryTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class SummaryTVC: UITableViewCell {

    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var vatAmount: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(orderSummaryObj: OrderSummary) {
        greyView.setCornerRadiusOfView(cornerRadiusValue:20)
        subtotal.text = "AED \(orderSummaryObj.orderAmount)"
        vatAmount.text = "AED \(orderSummaryObj.orderVat)"
        grandTotal.text = "AED \(orderSummaryObj.orderGrandTotal)"
    }
}

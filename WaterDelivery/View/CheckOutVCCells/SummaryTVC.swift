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

        // Configure the view for the selected state
    }
    
    func setupCell() {
        greyView.setCornerRadiusOfView(cornerRadiusValue:20)
        subtotal.text = "AED 18.00"
        vatAmount.text = "AED 0.90"
        grandTotal.text = "AED 18.90"
    }
}

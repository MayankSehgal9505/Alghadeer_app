//
//  SummaryTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class SummaryTVC: UITableViewCell {

    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var grandTotalLbl: UILabel!
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
        summaryLbl.text = Bundle.main.localizedString(forKey: "Summary", value: nil, table: nil)
        subTotalLbl.text = Bundle.main.localizedString(forKey: "Subtotal", value: nil, table: nil)
        vatLbl.text = Bundle.main.localizedString(forKey: "VAT", value: nil, table: nil)
        grandTotalLbl.text = Bundle.main.localizedString(forKey: "Grand Total", value: nil, table: nil)
        greyView.setCornerRadiusOfView(cornerRadiusValue:20)
        
        subtotal.text = "AED \(orderSummaryObj.orderAmount)"
        vatAmount.text = "AED \(orderSummaryObj.orderVat)"
        grandTotal.text = "AED \(orderSummaryObj.orderGrandTotal)"
        if Defaults.getEnglishLangauge() == "ar" {
            subtotal.textAlignment = .left
            vatAmount.textAlignment = .left
            grandTotal.textAlignment = .left
        } else {
            subtotal.textAlignment = .right
            vatAmount.textAlignment = .right
            grandTotal.textAlignment = .right
        }
    }
}

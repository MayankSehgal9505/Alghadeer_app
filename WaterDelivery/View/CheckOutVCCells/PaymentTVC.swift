//
//  PaymentTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class PaymentTVC: UITableViewCell {

    @IBOutlet weak var creditDebitCardLbl: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var useMyWalletLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var walletPaymentView: UIView!
    @IBOutlet weak var walletBtnChoosen: UIButton!
    @IBOutlet weak var walletMoney: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardBtnChoosen: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(walletBalanceObj:WalletBalance) {
        paymentLbl.text = Bundle.main.localizedString(forKey: "Payment", value: nil, table: nil)
        useMyWalletLbl.text = Bundle.main.localizedString(forKey: "Use From My Wallet", value: nil, table: nil)
        walletBalanceLbl.text = Bundle.main.localizedString(forKey: "Wallet Balance will be deducted at the time of delivery of product", value: nil, table: nil)
        creditDebitCardLbl.text = Bundle.main.localizedString(forKey: "Credit/Debit Card", value: nil, table: nil)
        walletMoney.setTitle(walletBalanceObj.walletAmount, for: [])
        walletMoney.setCornerRadiusOfView(cornerRadiusValue: 0.0, setBorder: true, borderColor: .blue, width: 1.0)
        walletPaymentView.setCornerRadiusOfView(cornerRadiusValue:20)
        cardView.setCornerRadiusOfView(cornerRadiusValue:20)
    }
    
}

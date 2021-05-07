//
//  CardTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class CardTVC: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cardChoosen: UIButton!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var expiryDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(){
        baseView.setCornerRadiusOfView(cornerRadiusValue: 5)
        baseView.layer.borderWidth = 1.0
        baseView.layer.borderColor = UIColor.blue.cgColor
        cardNumber.text = "**** **** **** 5987"
        expiryDetail.text = "Expires 09/25"
    }
}

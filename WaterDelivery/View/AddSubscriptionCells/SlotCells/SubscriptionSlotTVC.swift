//
//  SubscriptionSlotTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 15/05/21.
//

import UIKit

class SubscriptionSlotTVC: UITableViewCell {

    @IBOutlet weak var addSubscriptionBtn: UIButton!
    @IBOutlet weak var selectTimeBtn: UIButton!
    @IBOutlet weak var selectStartDateBtn: UIButton!
    @IBOutlet weak var selectEndDateBtn: UIButton!
    @IBOutlet weak var startDateTxtFld: UITextField!
    @IBOutlet weak var endDateTxtFld: UITextField!
    @IBOutlet weak var timeTxtFld: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        addSubscriptionBtn.setCornerRadiusOfView(cornerRadiusValue:25)
    }
}

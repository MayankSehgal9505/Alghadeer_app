//
//  SubscriptionSlotTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 15/05/21.
//

import UIKit

class SubscriptionSlotTVC: UITableViewCell {

    @IBOutlet weak var enterStartDateLbl: UILabel!
    @IBOutlet weak var enterEndDateLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
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
        enterStartDateLbl.text = Bundle.main.localizedString(forKey: "Enter start date", value: "", table: "")
        enterEndDateLbl.text = Bundle.main.localizedString(forKey: "Enter end date", value: "", table: "")
        deliveryTimeLbl.text = Bundle.main.localizedString(forKey: "Select Time of Delivery", value: "", table: "")
        addSubscriptionBtn.setTitle(Bundle.main.localizedString(forKey: "Add Subscriptions", value: "", table: ""), for: [])
        startDateTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .left : .right
        endDateTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .left : .right
        timeTxtFld.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .left : .right
        addSubscriptionBtn.setCornerRadiusOfView(cornerRadiusValue:25)
    }
}

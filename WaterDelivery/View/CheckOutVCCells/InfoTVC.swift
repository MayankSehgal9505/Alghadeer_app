//
//  InfoTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class InfoTVC: UITableViewCell {

    @IBOutlet weak var infoText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell() {
        infoText.text = Bundle.main.localizedString(forKey: "Bottle deposit will be deducted at the time of delivery", value: nil, table: nil)
    }
}

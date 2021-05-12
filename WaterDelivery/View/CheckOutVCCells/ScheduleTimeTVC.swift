//
//  ScheduleTimeTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class ScheduleTimeTVC: UITableViewCell {

    @IBOutlet weak var greyView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        greyView.setCornerRadiusOfView(cornerRadiusValue:13)
    }
}
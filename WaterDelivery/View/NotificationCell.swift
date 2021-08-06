//
//  NotificationCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 04/08/21.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var tiitle: UILabel!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(notificationModelObj:NotificationModel) {
        notificationView.setCornerRadiusOfView(cornerRadiusValue: 10, setBorder: false, borderColor: .lightGray, width: 1.0)
        img.makeViewCircle()
        tiitle.text = notificationModelObj.notificationTitle
        msg.text = notificationModelObj.notificationMessage
        time.text = notificationModelObj.notificationDate
    }
}

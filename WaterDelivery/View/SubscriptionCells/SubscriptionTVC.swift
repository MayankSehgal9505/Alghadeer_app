//
//  SubscriptionTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 14/05/21.
//

import UIKit

class SubscriptionTVC: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageBGView: UIView!
    @IBOutlet weak var subscribedProductImg: UIImageView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var pauseReactivateBtn: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var produuctAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(index:Int,tabType:SubscriptionTab) {
        pauseReactivateBtn.tag = index
        cancelBtn.tag = index
        pauseReactivateBtn.setTitle(tabType == .active ? "Pause" : "Reactivate", for: [])
        baseView.setCornerRadiusOfView(cornerRadiusValue:10)
        imageBGView.setCornerRadiusOfView(cornerRadiusValue:10)
        cancelBtn.setCornerRadiusOfView(cornerRadiusValue:20)
        pauseReactivateBtn.setCornerRadiusOfView(cornerRadiusValue:20)
        buttonsView.isHidden = tabType == .cancelled
    }
    
    func setupCellData(subscriptionModel:SubscriptionModel) {
        /*if let imageURL = URL.init(string: subsccriptionModel.productImage) {
            subscribedProductImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            subscribedProductImg.image = UIImage(named: "placeholder")
        }
        productName.text = ""
        produuctAddress.text = ""*/
    }
}

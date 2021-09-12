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
    @IBOutlet weak var totalPriceValue: UILabel!
    @IBOutlet weak var subscriptionDatesValue: UILabel!
    @IBOutlet weak var unitPriceValue: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var deliveryAddressLbl: UILabel!
    @IBOutlet weak var subscriptionDatesLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
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
        pauseReactivateBtn.setTitle((Bundle.main.localizedString(forKey: tabType == .active ? "Pause" : "Reactivate", value: "", table: "")), for: [])
        baseView.setCornerRadiusOfView(cornerRadiusValue:10)
        imageBGView.setCornerRadiusOfView(cornerRadiusValue:10)
        imageBGView.setShadow()
        cancelBtn.setCornerRadiusOfView(cornerRadiusValue:20)
        pauseReactivateBtn.setCornerRadiusOfView(cornerRadiusValue:20)
        buttonsView.isHidden = tabType == .cancelled
        cancelBtn.setTitle((Bundle.main.localizedString(forKey: "Cancel", value: "", table: "")), for: [])
        deliveryAddressLbl.text = (Bundle.main.localizedString(forKey: "Delivery Address -", value: "", table: ""))
        subscriptionDatesLbl.text = (Bundle.main.localizedString(forKey: "Subscription Dates", value: "", table: ""))
        deliveryTimeLbl.text = (Bundle.main.localizedString(forKey: "Delivery Time", value: "", table: ""))
    }
    
    func setupCellData(subscriptionModel:SubscriptionModel) {
        if let imageURL = URL.init(string: subscriptionModel.productImg) {
            subscribedProductImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            subscribedProductImg.image = UIImage(named: "placeholder")
        }
        productName.text = subscriptionModel.productName
        unitPriceValue.text = "\(Bundle.main.localizedString(forKey: "price of Unit:", value: "", table: "")) \(subscriptionModel.productUnitPrice)"
        produuctAddress.text = "\(subscriptionModel.address.shippingAddress) \(subscriptionModel.address.shippingCity) \(subscriptionModel.address.shippingPostCode) \(subscriptionModel.address.shippingCountry)"
        subscriptionDatesValue.text = "\(subscriptionModel.subscriptionStartDate) - \(subscriptionModel.subscriptionEndDate)"
        deliveryTime.text = subscriptionModel.productDeliveryTime
        subscriptionDatesValue.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .left : .right
        deliveryTime.textAlignment = Defaults.getEnglishLangauge() == "ar" ? .left : .right
        totalPriceValue.text = "\(Bundle.main.localizedString(forKey: "Total", value: "", table: "")) AED:\(subscriptionModel.totalAmount)"
        quantityLbl.text = "\(Bundle.main.localizedString(forKey: "QTY +", value: "", table: "")) \(subscriptionModel.productQuantity)"
    }
}

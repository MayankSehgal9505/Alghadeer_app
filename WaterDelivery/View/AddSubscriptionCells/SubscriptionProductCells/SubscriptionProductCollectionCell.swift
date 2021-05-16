//
//  SubscriptionProductCollectionCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 16/05/21.
//

import UIKit

class SubscriptionProductCollectionCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var subscriptionProductBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(productData:ProductModel){
        baseView.setCornerRadiusOfView(cornerRadiusValue: 12)
        baseView.backgroundColor = productData.productSelected ? UIColor.init(red: 166/255, green: 208/255, blue: 243/255, alpha: 1.0): UIColor.init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        productName.text = productData.name
        if let imageURL = URL.init(string: productData.productImage) {
            productImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            productImg.image = UIImage(named: "placeholder")
        }
    }
}

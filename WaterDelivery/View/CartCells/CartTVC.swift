//
//  CartTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 01/05/21.
//

import UIKit
import SDWebImage
class CartTVC: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var quantitylbl: UILabel!
    @IBOutlet weak var capacityLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var decreasequantitybtn: UIButton!
    @IBOutlet weak var addquantityBtn: UIButton!
    @IBOutlet weak var crossBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellUI(index: Int){
        crossBtn.makeViewCircle()
        quantityView.setCornerRadiusOfView(cornerRadiusValue: 15)
        quantityView.layer.borderWidth = 1.0
        quantityView.layer.borderColor = UIColor.gray.cgColor
        addquantityBtn.tag = index
        decreasequantitybtn.tag = index
        crossBtn.tag = index
    }
    
    func setUpCellData(cartItemObj:CartItemModel) {
        productname.text = cartItemObj.productName
        quantitylbl.text = cartItemObj.cartQuantity
        capacityLbl.text = cartItemObj.productDetails
        if let totalPrice = Double(cartItemObj.totalPrice) {
            priceLbl.text = "AED \(totalPrice)"
        }
        SDWebImageManager.shared.loadImage(with: URL.init(string: cartItemObj.productImage), options: .highPriority, progress: nil, completed: { [weak self](image, data, error, cacheType, finished, url) in
            guard let sself = self else { return }
            if let _ = error {
                // Do something with the error
                return
            }
            guard let img = image else {
                // No image handle this error
                return
            }
            sself.productImg.image = img
        })
    }
}

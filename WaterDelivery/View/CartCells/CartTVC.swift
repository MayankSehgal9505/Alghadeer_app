//
//  CartTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 01/05/21.
//

import UIKit
import Kingfisher
class CartTVC: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var quantitylbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var decreasequantitybtn: UIButton!
    @IBOutlet weak var addquantityBtn: UIButton!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var qtyText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellUI(index: Int){
        parentView.setCornerRadiusOfView(cornerRadiusValue: 15.0)
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
        priceLbl.text = "AED \(cartItemObj.price) \(Bundle.main.localizedString(forKey: "(incl. VAT)", value: nil, table: nil))"
        qtyText.text = Bundle.main.localizedString(forKey: "QTY", value: nil, table: nil)
        if let imageURL = URL.init(string: cartItemObj.productImage) {
            productImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            productImg.image = UIImage(named: "placeholder")
        }
    }
}

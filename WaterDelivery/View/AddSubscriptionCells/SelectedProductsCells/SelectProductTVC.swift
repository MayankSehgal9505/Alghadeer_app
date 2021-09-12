//
//  SelectProductTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 16/05/21.
//

import UIKit

class SelectProductTVC: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageBaseView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var reduceQuantityBtn: UIButton!
    @IBOutlet weak var incQuantityBtn: UIButton!
    @IBOutlet weak var quanittyLbl: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCellUI(index: Int) {
        quantityText.text = Bundle.main.localizedString(forKey: "Qty:", value: "", table: "")
        reduceQuantityBtn.tag = index
        incQuantityBtn.tag = index
        baseView.setCornerRadiusOfView(cornerRadiusValue: 12)
        imageBaseView.setCornerRadiusOfView(cornerRadiusValue: 12)
        quantityView.setCornerRadiusOfView(cornerRadiusValue: 13)
        quantityView.layer.borderWidth = 1.0
        quantityView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setupcell(productData:ProductModel) {
        productName.text = productData.name
        quanittyLbl.text = productData.initialQuantity
        if let imageURL = URL.init(string: productData.productImage) {
            productImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            productImg.image = UIImage(named: "placeholder")
        }
    }
}

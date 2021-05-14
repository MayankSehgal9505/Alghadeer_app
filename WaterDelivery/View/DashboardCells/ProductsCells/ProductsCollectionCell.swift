//
//  ProductsCollectionCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import UIKit
import Kingfisher

class ProductsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageBaseView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var productPriceDtailsView: UIView!
    @IBOutlet weak var productprice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(productModel:ProductModel){
        imageBaseView.backgroundColor = .white
        productPriceDtailsView.isHidden = true
        productName.text = productModel.name
        if let imageURL = URL.init(string: productModel.productImage) {
            productImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            productImage.image = UIImage(named: "placeholder")
        }
    }
    
    func setupCellwithDetails(productModel:ProductModel){
        //imageBaseView.backgroundColor = UIColor.init(red: 166/255, green: 208/255, blue: 243/255, alpha: 1.0)
        productPriceDtailsView.isHidden = false
        productprice.text = "AED \(productModel.sellingPrice)"
        productName.text = productModel.name
        if let imageURL = URL.init(string: productModel.productImage) {
            productImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            productImage.image = UIImage(named: "placeholder")
        }
    }
}

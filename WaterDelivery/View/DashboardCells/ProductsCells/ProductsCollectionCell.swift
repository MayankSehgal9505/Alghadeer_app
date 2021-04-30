//
//  ProductsCollectionCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import UIKit
import SDWebImage

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
        SDWebImageManager.shared.loadImage(with: URL.init(string: productModel.productImage), options: .highPriority, progress: nil, completed: { [weak self](image, data, error, cacheType, finished, url) in
            guard let sself = self else { return }
            if let _ = error {
                // Do something with the error
                return
            }
            guard let img = image else {
                // No image handle this error
                return
            }
            sself.productImage.image = img
        })
    }
    
    func setupCellwithDetails(productModel:ProductModel){
        //imageBaseView.backgroundColor = UIColor.init(red: 166/255, green: 208/255, blue: 243/255, alpha: 1.0)
        productPriceDtailsView.isHidden = false
        productprice.text = "AED \(productModel.sellingPrice)"
        productName.text = productModel.name
        SDWebImageManager.shared.loadImage(with: URL.init(string: productModel.productImage), options: .highPriority, progress: nil, completed: { [weak self](image, data, error, cacheType, finished, url) in
            guard let sself = self else { return }
            if let _ = error {
                // Do something with the error
                return
            }
            guard let img = image else {
                // No image handle this error
                return
            }
            sself.productImage.image = img
        })
    }
}

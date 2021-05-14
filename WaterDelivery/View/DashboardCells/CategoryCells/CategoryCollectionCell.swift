//
//  CategoryCollectionCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import UIKit
import Kingfisher

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var categoryID: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(categoryModel:CategoryModel){
        categoryName.text = categoryModel.name
        categoryDetail.text = categoryModel.details
        if let imageURL = URL.init(string: categoryModel.categoryImage) {
            categoryID.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            categoryID.image = UIImage(named: "placeholder")
        }
    }

}

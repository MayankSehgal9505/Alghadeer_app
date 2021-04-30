//
//  CategoryCollectionCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import UIKit
import SDWebImage

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
        SDWebImageManager.shared.loadImage(with: URL.init(string: categoryModel.categoryImage), options: .highPriority, progress: nil, completed: { [weak self](image, data, error, cacheType, finished, url) in
            guard let sself = self else { return }
            if let _ = error {
                // Do something with the error
                return
            }
            guard let img = image else {
                // No image handle this error
                return
            }
            sself.categoryID.image = img
        })
    }

}

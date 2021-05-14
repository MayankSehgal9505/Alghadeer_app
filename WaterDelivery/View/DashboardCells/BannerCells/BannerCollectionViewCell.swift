//
//  BannerCollectionViewCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 27/04/21.
//

import UIKit
import Kingfisher
class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bannerImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(bannerModel:BannerModel){
        if let imageURL = URL.init(string: bannerModel.imageUrl) {
            bannerImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            bannerImg.image = UIImage(named: "placeholder")
        }
    }
    
}

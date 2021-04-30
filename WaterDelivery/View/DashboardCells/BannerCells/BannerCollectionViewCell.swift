//
//  BannerCollectionViewCell.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 27/04/21.
//

import UIKit
import SDWebImage
class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bannerImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(bannerModel:BannerModel){
        SDWebImageManager.shared.loadImage(with: URL.init(string: bannerModel.imageUrl), options: .highPriority, progress: nil, completed: { [weak self](image, data, error, cacheType, finished, url) in
            guard let sself = self else { return }
            if let _ = error {
                // Do something with the error
                return
            }
            guard let img = image else {
                // No image handle this error
                return
            }
            sself.bannerImg.image = img
        })
    }
    
}

//
//  DetailVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 22/04/21.
//

import UIKit
import SDWebImage
class DetailVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var navTitle: UILabel!
    
    //MARK:- Properties
    var product = ProductModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        navTitle.text = product.name
        self.cartButton.setCornerRadiusOfView(cornerRadiusValue: 25)
        productName.text = product.name
        productPrice.text = "AED \(product.sellingPrice)"
        productDescription.text = product.details
        SDWebImageManager.shared.loadImage(with: URL.init(string: product.productImage), options: .highPriority, progress: nil, completed: { [weak self](image, data, error, cacheType, finished, url) in
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
        })    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

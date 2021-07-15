//
//  ProductsTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import UIKit
protocol ProductDetailProtocol: class {
    func productBtnClicked(selectedIndex: Int)
}
class ProductsTVC: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var favouriteProductsLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var productArray = Array<ProductModel>()
    weak var productDelegate: ProductDetailProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib.init(nibName: ProductsCollectionCell.className(), bundle: nil), forCellWithReuseIdentifier: ProductsCollectionCell.className())
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = collectionViewFlowLayout
    }

    
    func setupCell() {
        parentView.setCornerRadiusOfView(cornerRadiusValue:15)
        parentView.setShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func productBtnTapped(sender:UIButton) {
        productDelegate?.productBtnClicked(selectedIndex: sender.tag)
    }
    
}

extension ProductsTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith() {
        self.collectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProductsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionCell.className(), for: indexPath) as! ProductsCollectionCell
        cell.setupCell(productModel: productArray[indexPath.item])
        cell.productBtn.tag = indexPath.item
        cell.productBtn.addTarget(self, action: #selector(productBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: self.contentView.frame.width/2, height: 240)
        return size
    }
}

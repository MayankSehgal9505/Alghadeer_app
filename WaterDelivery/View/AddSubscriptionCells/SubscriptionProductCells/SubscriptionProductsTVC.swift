//
//  SubscriptionProductsTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 16/05/21.
//

import UIKit
protocol SubscriptionProductsProtocol: class {
    func productClicked(selectedIndex: Int)
}

class SubscriptionProductsTVC: UITableViewCell {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    var products = Array<ProductModel>()
    weak var subscriptionProductDelegate: SubscriptionProductsProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        productsCollectionView.register(UINib.init(nibName: SubscriptionProductCollectionCell.className(), bundle: nil), forCellWithReuseIdentifier: SubscriptionProductCollectionCell.className())
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.scrollDirection = .vertical
        //collectionViewFlowLayout.inse
        self.productsCollectionView.collectionViewLayout = collectionViewFlowLayout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(productList: Array<ProductModel>) {
        products = productList
    }
    
    @objc func subscriptionBtnTapped(sender:UIButton) {
        subscriptionProductDelegate?.productClicked(selectedIndex: sender.tag)
    }
}

extension SubscriptionProductsTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith() {
        self.productsCollectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SubscriptionProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionProductCollectionCell.className(), for: indexPath) as! SubscriptionProductCollectionCell
        cell.setupCell(productData: products[indexPath.item])
        cell.subscriptionProductBtn.tag = indexPath.item
        cell.subscriptionProductBtn.addTarget(self, action: #selector(subscriptionBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: self.contentView.frame.width/3, height: 200)
        return size
    }
}

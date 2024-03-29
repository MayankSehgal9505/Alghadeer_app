//
//  CategoryTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import UIKit
protocol CategoryProtocol: class {
    func categoryBtnClicked(selectedIndex: Int)
}
class CategoryTVC: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var categoryArray = Array<CategoryModel>()
    weak var categoryDelegate: CategoryProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib.init(nibName: CategoryCollectionCell.className(), bundle: nil), forCellWithReuseIdentifier: CategoryCollectionCell.className())
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = collectionViewFlowLayout
    }

    
    func setupCell(categoryList: Array<CategoryModel>) {
        categoryArray = categoryList
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func categoryBtnTapped(sender:UIButton) {
        categoryDelegate?.categoryBtnClicked(selectedIndex: sender.tag)
    }
}

extension CategoryTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith() {
        self.collectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.className(), for: indexPath) as! CategoryCollectionCell
        cell.setupCell(categoryModel: categoryArray[indexPath.item])
        cell.categoryBtn.tag = indexPath.item
        cell.categoryBtn.addTarget(self, action: #selector(categoryBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: self.contentView.frame.width/2-20, height: 340)
        return size
    }
}

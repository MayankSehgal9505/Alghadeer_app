//
//  BannerTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 28/04/21.
//

import UIKit

class BannerTVC: UITableViewCell {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var bannerArray = Array<BannerModel>()
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib.init(nibName: BannerCollectionViewCell.className(), bundle: nil), forCellWithReuseIdentifier: BannerCollectionViewCell.className())
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = collectionViewFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

    }

    
    func setupCell(bannerList: Array<BannerModel>) {
        bannerArray = bannerList
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension BannerTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith() {
        self.collectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.className(), for: indexPath) as! BannerCollectionViewCell
        cell.setupCell(bannerModel: bannerArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: self.contentView.frame.width, height: 250)
        return size
    }
}

extension BannerTVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
}
}

//
//  CategoryProductsVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 30/04/21.
//

import UIKit

class CategoryProductsVC: CartBaseVC {

    //MARK:- IBOutlet
    @IBOutlet weak var navtitle: UILabel!
    @IBOutlet weak var categoryProductCollectionView: UICollectionView!
    
    //MARK:- Properties
    var categoryObj = CategoryModel()
    var productArray = Array<ProductModel>()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navtitle.text = categoryObj.name
        setupColllectionCell()
        getCategoryProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK:- Internal Methods
    private func setupColllectionCell(){
        categoryProductCollectionView.register(UINib.init(nibName: ProductsCollectionCell.className(), bundle: nil), forCellWithReuseIdentifier: ProductsCollectionCell.className())
        self.categoryProductCollectionView.delegate = self
        self.categoryProductCollectionView.dataSource = self
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 20.0
        collectionViewFlowLayout.minimumInteritemSpacing = 2.0
        collectionViewFlowLayout.scrollDirection = .vertical
        self.categoryProductCollectionView.collectionViewLayout = collectionViewFlowLayout
    }
    
    //MARK:- IBActions
    @objc private func productBtnTapped(sender:UIButton) {
        if sender.tag < productArray.count {
            let productDetailVC = DetailVC()
            productDetailVC.product = productArray[sender.tag]
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- API Call Methods
extension CategoryProductsVC {
    func getCategoryProducts() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let bannerListURL : String = UrlName.baseUrl + UrlName.getProductListByCategoryID + "\(categoryObj.categoryID)/0"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: bannerListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let productList = jsonValue[APIField.dataKey]?.array {
                        for product in productList {
                            let productModel = ProductModel.init(json: product)
                            self.productArray.append(productModel)
                        }
                    }
                    DispatchQueue.main.async {
                        self.categoryProductCollectionView.reloadData()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
}
//MARK:- UICollectionViewDataSource & UICollectionViewDelegateFlowLayout Methods

extension CategoryProductsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProductsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionCell.className(), for: indexPath) as! ProductsCollectionCell
        cell.setupCellwithDetails(productModel: productArray[indexPath.item])
        cell.productBtn.tag = indexPath.item
        cell.productBtn.addTarget(self, action: #selector(productBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: self.view.frame.width/2-20, height: 350)
        return size
    }
}

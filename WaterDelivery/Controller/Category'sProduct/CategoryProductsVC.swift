//
//  CategoryProductsVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 30/04/21.
//

import UIKit

class CategoryProductsVC: UIViewController {

    @IBOutlet weak var cartCountLbl: UILabel!
    @IBOutlet weak var cartCountView: UIView!{didSet {self.cartCountView.makeViewCircle()}}
    @IBOutlet weak var navtitle: UILabel!
    @IBOutlet weak var categoryProductCollectionView: UICollectionView!
    var categoryObj = CategoryModel()
    var productArray = Array<ProductModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        navtitle.text = categoryObj.name
        setupColllectiionCell()
        getCategoryProducts()
        getCartCountList()
        cartView(hidden: true, count: "0")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupColllectiionCell(){
        categoryProductCollectionView.register(UINib.init(nibName: ProductsCollectionCell.className(), bundle: nil), forCellWithReuseIdentifier: ProductsCollectionCell.className())
        self.categoryProductCollectionView.delegate = self
        self.categoryProductCollectionView.dataSource = self
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 20.0
        collectionViewFlowLayout.minimumInteritemSpacing = 2.0
        collectionViewFlowLayout.scrollDirection = .vertical
        self.categoryProductCollectionView.collectionViewLayout = collectionViewFlowLayout
    }
    func cartView(hidden: Bool, count:String) {
        cartCountView.isHidden = hidden
        cartCountLbl.text = count
    }
    @objc func productBtnTapped(sender:UIButton) {
        if sender.tag < productArray.count {
            let productDetailVC = DetailVC()
            productDetailVC.product = productArray[sender.tag]
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goToCart(_ sender: UIButton) {
        moveToCartsVC()
    }
    private func moveToCartsVC() {
        let cartVC = CartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
}
extension CategoryProductsVC {
    func getCategoryProducts() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let bannerListURL : String = UrlName.baseUrl + UrlName.getProductListByCategoryID + "\(categoryObj.categoryID)/0"
            NetworkManager.sharedInstance.commonApiCall(url: bannerListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
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
    
    func getCartCountList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let cartCountURL : String = UrlName.baseUrl + UrlName.getCartCountUrl + Defaults.getUserID()
            let parameters = [
                "customer_id":Defaults.getUserID(),
            ] as [String : Any]
            NetworkManager.sharedInstance.commonApiCall(url: cartCountURL, method: .get, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        if let cartCountString = jsonValue["TotalCount"]?.stringValue, let cartCount = Int(cartCountString), cartCount > 0 {
                            self.cartView(hidden: false, count: cartCountString)
                        } else {
                            self.cartView(hidden: true, count: "0")
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.dismissHUD(isAnimated: true)
                }
            })
        }
    }
}
extension CategoryProductsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
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

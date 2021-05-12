//
//  DashboardVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit

class DashboardVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var cartCountView: UIView! {didSet {self.cartCountView.makeViewCircle()}}
    @IBOutlet weak var cartCountlbl: UILabel!
    var bannerArray = Array<BannerModel>()
    var categoryArray = Array<CategoryModel>()
    var productArray = Array<ProductModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getBanneerList()
        getProductsList()
        getCategorysList()
        getCartCountList()
        getUserProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerArray.removeAll()
        categoryArray.removeAll()
        productArray.removeAll()
        tbView.reloadData()
    }
    func setupUI(){
        setUpTBView()
        cartView(hidden: true, count: "0")
    }
    
    func cartView(hidden: Bool, count:String) {
        cartCountView.isHidden = hidden
        cartCountlbl.text = count
    }
    /// Set Collection View
    func setUpTBView(){
        /// Register Cells

        self.tbView.register(UINib(nibName: BannerTVC.className(), bundle: nil), forCellReuseIdentifier: BannerTVC.className())
        self.tbView.register(UINib(nibName: ProductsTVC.className(), bundle: nil), forCellReuseIdentifier: ProductsTVC.className())
        self.tbView.register(UINib(nibName: CategoryTVC.className(), bundle: nil), forCellReuseIdentifier: CategoryTVC.className())

    }
    private func moveToCartsVC() {
        let cartVC = CartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBAction func goToCartBtnAction(_ sender: UIButton) {
        moveToCartsVC()
    }
    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        self.frostedViewController.presentMenuViewController()
    }

}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Method
extension DashboardVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BannerTVC.className(), for: indexPath) as? BannerTVC {
                cell.bannerArray = self.bannerArray
                cell.pageControl.numberOfPages = self.bannerArray.count
                cell.updateCellWith()
                return cell
            }
            return UITableViewCell()

        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTVC.className(), for: indexPath) as? ProductsTVC {
                cell.productArray = self.productArray
                cell.productDelegate = self
                cell.updateCellWith()
                return cell
            }
            return UITableViewCell()
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTVC.className(), for: indexPath) as? CategoryTVC {
                cell.categoryArray = self.categoryArray
                cell.categoryDelegate = self
                cell.updateCellWith()
                return cell
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return bannerArray.count > 0 ? 360 : 0
        case 1:
            return productArray.count > 0 ? 360 : 0
        default:
            return CGFloat((categoryArray.count/2 + categoryArray.count%2) * 400)
        }
    }
}
extension DashboardVC: ProductDetailProtocol{
    func productBtnClicked(selectedIndex: Int) {
        if selectedIndex < productArray.count {
            let productDetailVC = DetailVC()
            productDetailVC.product = productArray[selectedIndex]
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
}

extension DashboardVC: CategoryProtocol{
    func categoryBtnClicked(selectedIndex: Int) {
        if selectedIndex < categoryArray.count {
            let productDetailVC = CategoryProductsVC()
            productDetailVC.categoryObj = categoryArray[selectedIndex]
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
}
extension DashboardVC {
    func getBanneerList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let bannerListURL : String = UrlName.baseUrl + UrlName.getBannerUrl
            NetworkManager.viewControler = self
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
                    if let bannerlist = jsonValue[APIField.dataKey]?.array {
                        for banner in bannerlist {
                            let bannerModel = BannerModel.init(json: banner)
                            self.bannerArray.append(bannerModel)
                        }
                    }
                    DispatchQueue.main.async {
                        //self.tbView.reloadSections(IndexSet.init(integer: 0), with: .none)

                        self.tbView.reloadData()
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
    
    func getProductsList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let bannerListURL : String = UrlName.baseUrl + UrlName.getProductListUrl
            NetworkManager.viewControler = self
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
                        self.tbView.reloadSections(IndexSet.init(integer: 1), with: .none)
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
    
    func getCategorysList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let bannerListURL : String = UrlName.baseUrl + UrlName.getCategoryListUrl
            NetworkManager.viewControler = self
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
                    if let categorylist = jsonValue[APIField.dataKey]?.array {
                        for category in categorylist {
                            let category = CategoryModel.init(json: category)
                            self.categoryArray.append(category)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tbView.reloadSections(IndexSet.init(integer: 2), with: .none)
                    }
                }
                else {
                    if let tokenExpire = jsonValue[APIField.statusKey]?.stringValue,tokenExpire == APIField.expiredToken {
                        DispatchQueue.main.async {
                        self.showSessionExpiredAlert()
                        }
                    } else {
                        DispatchQueue.main.async {
                        self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                        }
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
    
    func getUserProfile() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let getUserDetailsUrl : String = UrlName.baseUrl + UrlName.getUserDetailUrl + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: getUserDetailsUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                //print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let userDict = jsonValue[APIField.dataKey] {
                        let user = UserModel.init(json: userDict)
                        UserData.sharedInstance.userModel = user
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserInfo"), object: self)
                        }
                    }
                }
            })
        }
    }
}

//
//  DashboardVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit

class DashboardVC: CartBaseVC {
    
    // MARK:- Enums
    private enum DashboardSections :Int, CaseIterable{
        case banner = 0
        case products, category
    }
    // MARK:- IBOutlets
    @IBOutlet weak var tbView: UITableView!
    
    // MARK:- Local Variables
    private var bannerArray = Array<BannerModel>()
    private var categoryArray = Array<CategoryModel>()
    private var productArray = Array<ProductModel>()
    private var dispatchGp = DispatchGroup()
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTBView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        apiCalls()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerArray.removeAll()
        categoryArray.removeAll()
        productArray.removeAll()
        tbView.reloadData()
    }
    
    // MARK:- Internal Methods
    /// Set Table View
    private func setUpTBView(){
        /// Register Cells
        self.tbView.register(UINib(nibName: BannerTVC.className(), bundle: nil), forCellReuseIdentifier: BannerTVC.className())
        self.tbView.register(UINib(nibName: ProductsTVC.className(), bundle: nil), forCellReuseIdentifier: ProductsTVC.className())
        self.tbView.register(UINib(nibName: CategoryTVC.className(), bundle: nil), forCellReuseIdentifier: CategoryTVC.className())
    }

    private func apiCalls(){
        func dispatchGpAPIS() {
            getUserProfile()
            self.showHUD(progressLabel: AlertField.loaderString)
            self.dispatchGp.enter()
            self.dispatchGp.enter()
            self.dispatchGp.enter()
            getBannerList()
            getProductsList()
            getCategorysList()
        }
        dispatchGpAPIS()
        dispatchGp.notify(queue: .main) {
            self.dismissHUD(isAnimated: true)
            self.tbView.reloadData()
        }
    }
    // MARK:- IBActions
    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        self.frostedViewController.presentMenuViewController()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate Method
extension DashboardVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DashboardSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DashboardSections.init(rawValue: section) else {return 0}
        switch section {
        case .banner:       return bannerArray.isEmpty ? 0 : 1
        case .products:     return productArray.isEmpty ? 0 : 1
        case .category:     return categoryArray.isEmpty ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DashboardSections.init(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerTVC.className(), for: indexPath) as! BannerTVC
            cell.bannerArray = self.bannerArray
            cell.pageControl.numberOfPages = self.bannerArray.count
            cell.updateCellWith()
            return cell
        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTVC.className(), for: indexPath) as! ProductsTVC
            cell.favouriteProductsLbl.isHidden = false
            cell.productArray = self.productArray
            cell.productDelegate = self
            cell.updateCellWith()
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTVC.className(), for: indexPath) as! CategoryTVC
            cell.shopByCategoryLbl.isHidden = false
            cell.categoryArray = self.categoryArray
            cell.categoryDelegate = self
            cell.updateCellWith()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = DashboardSections.init(rawValue: indexPath.section) else {return 0}
        switch section {
        case .banner:       return bannerArray.count > 0 ? 360 : 0
        case .products:     return productArray.count > 0 ? 360 : 0
        case .category:     return CGFloat((categoryArray.count/2 + categoryArray.count%2) * 400)
        }
    }
}
extension DashboardVC: ProductDetailProtocol{
    func productBtnClicked(selectedIndex: Int) {
        if selectedIndex < productArray.count {
            let productDetailVC = DetailVC()
            productDetailVC.product = productArray[selectedIndex]
            productDetailVC.productID = productArray[selectedIndex].productID
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
    func getBannerList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let bannerListURL : String = UrlName.baseUrl + UrlName.getBannerUrl
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: bannerListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dispatchGp.leave()
                    DispatchQueue.main.async {
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let bannerlist = jsonValue[APIField.dataKey]?.array {
                        for banner in bannerlist {
                            let bannerModel = BannerModel.init(json: banner)
                            self.bannerArray.append(bannerModel)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                self.dispatchGp.leave()
            })
        }else{
            self.dispatchGp.leave()
            self.showNoInternetAlert()
        }
    }
    
    func getProductsList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let bannerListURL : String = UrlName.baseUrl + UrlName.getProductListUrl
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: bannerListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dispatchGp.leave()
                    DispatchQueue.main.async {
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
                }
                else {
                    DispatchQueue.main.async {
                        self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                self.dispatchGp.leave()
            })
        }else{
            self.dispatchGp.leave()
            self.showNoInternetAlert()
        }
    }
    
    func getCategorysList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let bannerListURL : String = UrlName.baseUrl + UrlName.getCategoryListUrl
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: bannerListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dispatchGp.leave()
                    DispatchQueue.main.async {
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let categorylist = jsonValue[APIField.dataKey]?.array {
                        for category in categorylist {
                            let category = CategoryModel.init(json: category)
                            self.categoryArray.append(category)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                self.dispatchGp.leave()
            })
        }else{
            self.dispatchGp.leave()
            self.showNoInternetAlert()
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

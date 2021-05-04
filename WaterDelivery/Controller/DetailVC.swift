//
//  DetailVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 22/04/21.
//

import UIKit
import SDWebImage
class DetailVC: UIViewController {
    //MARK:-enums
    enum ActionType {
        case addToCart
        case goToCart
    }
    //MARK:- IBOutlet
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var addToCartBTn: UIButton!
    @IBOutlet weak var cartCountView: UIView! {didSet {self.cartCountView.makeViewCircle()}}
    @IBOutlet weak var cartCountlbl: UILabel!
    
    //MARK:- Properties
    var product = ProductModel()
    var actionPerformed: ActionType = .addToCart
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartCountList()
        cartView(hidden: true, count: "0")
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
        })
    }
    
    func cartView(hidden: Bool, count:String) {
        cartCountView.isHidden = hidden
        cartCountlbl.text = count
    }
    @IBAction func goToCart(_ sender: UIButton) {
        moveToCartsVC()
    }
    private func moveToCartsVC() {
        let cartVC = CartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addToCartBtnTapped(_ sender: UIButton) {
        switch actionPerformed {
        case .addToCart:
            updateProductInCart(product: product)
        case .goToCart:
            moveToCartsVC()
        }
    }
}

extension DetailVC {
    func updateProductInCart(product:ProductModel) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addToCartUrl : String = UrlName.baseUrl + UrlName.addToCartUrl
            let parameters = [
                "customer_id":Defaults.getUserID(),
                "product_id":product.productID,
                "unit_atrributes_id":product.unitAttributeId,
                "unit_measure":product.attributeName,
                "price":product.unitPrice,
                "quantity":"1",
                "event":"add"
            ] as [String : Any]
            print(parameters)
            NetworkManager.sharedInstance.commonApiCall(url: addToCartUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
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
                        self.view.makeToast("Item added to cart", duration: 3.0, position: .center)
                        self.addToCartBTn.setTitle("Go To Cart", for: [])
                        self.actionPerformed = .goToCart
                        self.getCartCountList()
                    }
                } else {
                    DispatchQueue.main.async {
                        if let errordict = jsonValue["Errors"]?.dictionaryObject {
                            if errordict.keys.count == 0 {
                                self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
                            } else {
                                self.view.makeToast(errordict[errordict.keys.first!] as? String ?? "", duration: 3.0, position: .center)

                            }
                        } else {
                            self.view.makeToast("Something went wrong, try again later", duration: 3.0, position: .center)
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
            let cartCountURL : String = UrlName.baseUrl + UrlName.getCartCountUrl + Defaults.getUserID()
            let parameters = [
                "customer_id":Defaults.getUserID(),
            ] as [String : Any]
            NetworkManager.sharedInstance.commonApiCall(url: cartCountURL, method: .get, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        if let cartCountString = jsonValue["TotalCount"]?.stringValue, let cartCount = Int(cartCountString), cartCount > 0 {
                            self.cartView(hidden: false, count: cartCountString)
                        } else {
                            self.cartView(hidden: true, count: "0")
                            self.addToCartBTn.setTitle("Add To Cart", for: [])
                        }
                    }
                }
            })
        }
    }
}

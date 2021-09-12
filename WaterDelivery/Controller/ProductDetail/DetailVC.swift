//
//  DetailVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 22/04/21.
//

import UIKit
import Kingfisher
class DetailVC: CartBaseVC {
    //MARK:-enums
    enum ActionType {
        case addToCart
        case goToCart
    }
    //MARK:- IBOutlet
    @IBOutlet var curveViews: [UIView]! {
        didSet {
            curveViews.forEach { view in
                view.setCornerRadiusOfView(cornerRadiusValue:15)
            }
        }
    }
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var addToCartBTn: UIButton! {didSet {addToCartBTn.setCornerRadiusOfView(cornerRadiusValue: 25)}}
    @IBOutlet weak var QuantityView: UIView! {didSet {
        QuantityView.layer.borderWidth = 1.0
        QuantityView.layer.borderColor = UIColor.gray.cgColor
        QuantityView.setCornerRadiusOfView(cornerRadiusValue: 15)}}
    @IBOutlet weak var decreaseQuantityBtn: UIButton!
    @IBOutlet weak var increaseQuantityBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var quantityParentView: UIView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var totalAmountTxt: UILabel!
    @IBOutlet weak var inclusiveVatText: UILabel!
    @IBOutlet weak var inclusiveVatText2: UILabel!
    @IBOutlet weak var notificationview: UIButton!
    
    //MARK:- Properties
    var product = ProductModel()
    var actionPerformed: ActionType = .addToCart
    var productCurrentQuantity = 0
    var productID = ""
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
        self.addToCartBTn.setTitle(self.productCurrentQuantity == 0 ? Bundle.main.localizedString(forKey: "Add to Cart", value: nil, table: nil) :  Bundle.main.localizedString(forKey: "view Cart", value: nil, table: nil), for: [])
        self.notificationview.isHidden = Defaults.getSkipLogin()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        curveViews.forEach { $0.setShadow() }
    }
    //MARK:- Internal Methods
    private func setupView(){
        navTitle.text = product.name
        productName.text = product.name
        productPrice.text = "AED \(product.unitPrice)"
        productDescription.text = product.details
        if let imageURL = URL.init(string: product.productImage) {
            productImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            productImg.image = UIImage(named: "placeholder")
        }
        descriptionText.text = Bundle.main.localizedString(forKey: "Description", value: nil, table: nil)
        quantityText.text = Bundle.main.localizedString(forKey: "QTY", value: nil, table: nil)
        totalAmountTxt.text = Bundle.main.localizedString(forKey: "Total Amount", value: nil, table: nil)
        inclusiveVatText.text = Bundle.main.localizedString(forKey: "(incl. VAT)", value: nil, table: nil)
        inclusiveVatText2.text = Bundle.main.localizedString(forKey: "(incl. VAT)", value: nil, table: nil)
    }

    //MARK:- IBActions
    @IBAction func increaseBtnAction(_ sender: UIButton) {
        updateProductInCart(product: product, str: "add")
    }
    @IBAction func decreaseBtnAction(_ sender: UIButton) {
        if let lbl = Int(quantityLbl.text!), lbl > 0{
            updateProductInCart(product: product, str: productCurrentQuantity == 1 ? "remove" : "delete")
        }
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addToCartBtnTapped(_ sender: UIButton) {
        if Defaults.getSkipLogin() {
            let alert = UIAlertController(title: "Guest Login", message: "Please Login/Signup to continue further", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "Ok",style: .default,handler: {(_: UIAlertAction!) in
                Defaults.resetDefaults()
                Utility.checkIfAlreadyLogin()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            switch actionPerformed {
            case .addToCart:
                updateProductInCart(product: product, str: "add")
            case .goToCart:
                super.goToCartBtnAction(sender)
            }
        }
    }
}

//MARK:- API Calls
extension DetailVC {
    private func getProductQuantity(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let productQuantityUrl : String = UrlName.baseUrl + UrlName.getCartQuantityUrl
            let parameters = [
                "customer_id":Defaults.getUserID(),
                "product_id":productID,
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: productQuantityUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true, let data = jsonValue["Quantity"], let quant = Int(data.string ?? "0") {
                    self.productCurrentQuantity = quant
                    DispatchQueue.main.async {
                        self.quantityParentView.isHidden = self.productCurrentQuantity == 0
                        self.quantityLbl.text = "\(self.productCurrentQuantity)"
                        self.totalPriceLbl.text = self.productCurrentQuantity == 0 ? "AED \(Double(self.product.sellingPrice) ?? 0.0)" : "AED \(Double(self.productCurrentQuantity) * (Double(self.product.sellingPrice) ?? 0.0))"
                        self.addToCartBTn.setTitle(self.productCurrentQuantity == 0 ? Bundle.main.localizedString(forKey: "Add to Cart", value: nil, table: nil) :  Bundle.main.localizedString(forKey: "view Cart", value: nil, table: nil), for: [])
                        
                       

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

    private func getProductDetail(){
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let productDetailUrl : String = UrlName.baseUrl + UrlName.getProductDetailUrl + productID + "/\(Defaults.getEnglishLangauge() == "en" ? 1 : 2)"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: productDetailUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true, let data = jsonValue[APIField.dataKey] {
                    self.product = ProductModel.init(json: data)
                    DispatchQueue.main.async {
                        self.setupView()
                        if Defaults.getSkipLogin() {
                            self.quantityParentView.isHidden = true
                            self.totalPriceLbl.text = "AED \(Double(1.0) * (Double(self.product.sellingPrice) ?? 0.0))"
                        } else {
                            self.getProductQuantity()
                        }
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

    private func updateProductInCart(product:ProductModel,str: String) {
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
                "event":str
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: addToCartUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.productCurrentQuantity = str == "add" ? self.productCurrentQuantity + 1: self.productCurrentQuantity - 1
                        self.view.makeToast(str == "add" ? "Item added successfully into cart" :"Item removed successfully from cart", duration: 0.5, position: .bottom)
                        self.getCartCountList()
                        self.getProductQuantity()
                        self.quantityLbl.text = "\(self.productCurrentQuantity)"
                        self.totalPriceLbl.text = "AED \(Double(self.productCurrentQuantity) * (Double(self.product.sellingPrice) ?? 0.0))"
                        self.addToCartBTn.setTitle(self.productCurrentQuantity == 0 ? Bundle.main.localizedString(forKey: "Add to Cart", value: nil, table: nil) :  Bundle.main.localizedString(forKey: "view Cart", value: nil, table: nil), for: [])
                        self.actionPerformed = self.productCurrentQuantity == 0 ? .addToCart : .goToCart
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
}

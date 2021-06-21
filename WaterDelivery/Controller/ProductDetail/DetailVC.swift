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
    @IBOutlet weak var quantView: UIView!
    //MARK:- Properties
    var product = ProductModel()
    var actionPerformed: ActionType = .addToCart
    var productCurrentQuantity = 1
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        Defaults.setSkipLogin(true)
    }
    
    //MARK:- Internal Methods
    private func setupView(){
        navTitle.text = product.name
        productName.text = product.name
        productPrice.text = "AED \(product.sellingPrice)"
        productDescription.text = product.details
        if let imageURL = URL.init(string: product.productImage) {
            productImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            productImg.image = UIImage(named: "placeholder")
        }
    }

    //MARK:- IBActions
    @IBAction func increaseBtnAction(_ sender: UIButton) {
        if var currentQuantity = Int(quantityLbl.text!),let productMaxQuantity = Int(product.quantity) {
            if currentQuantity < productMaxQuantity {
                currentQuantity += 1
                productCurrentQuantity = currentQuantity
                self.quantityLbl.text = "\(currentQuantity)"
            } else {
                self.view.makeToast("Product maximum quanntity has been reached", duration: 3.0, position: .center)
            }
        }
    }
    @IBAction func decreaseBtnAction(_ sender: UIButton) {
        if var currentQuantity = Int(quantityLbl.text!) {
            if currentQuantity == 1 {
                self.view.makeToast("Product minimum quanntity has been reached", duration: 3.0, position: .center)
            } else {
                currentQuantity -= 1
                productCurrentQuantity = currentQuantity
                self.quantityLbl.text = "\(currentQuantity)"
            }
        }
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addToCartBtnTapped(_ sender: UIButton) {
        if Defaults.getSkipLogin() {
            let alert = UIAlertController(title: "", message: "Please signup/login to continue further", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Signup/login",style: .default,handler: {(_: UIAlertAction!) in
                Defaults.resetDefaults()
                Utility.checkIfAlreadyLogin(vc: self)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            switch actionPerformed {
            case .addToCart:
                updateProductInCart(product: product)
            case .goToCart:
                super.goToCartBtnAction(sender)
            }
        }
    }
}

//MARK:- API Calls
extension DetailVC {
    private func updateProductInCart(product:ProductModel) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addToCartUrl : String = UrlName.baseUrl + UrlName.addToCartUrl
            let parameters = [
                "customer_id":Defaults.getUserID(),
                "product_id":product.productID,
                "unit_atrributes_id":product.unitAttributeId,
                "unit_measure":product.attributeName,
                "price":product.unitPrice,
                "quantity":"\(productCurrentQuantity)",
                "event":"add"
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
                        self.view.makeToast("Item added to cart", duration: 3.0, position: .center)
                        self.addToCartBTn.setTitle("View Cart", for: [])
                        self.actionPerformed = .goToCart
                        self.quantView.isHidden = true
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
}

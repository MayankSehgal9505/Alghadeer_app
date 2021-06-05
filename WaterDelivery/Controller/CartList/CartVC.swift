//
//  CartVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 01/05/21.
//

import UIKit

class CartVC: UIViewController {

    //MARK:- enums
    enum ProductQuantity {
        case noAlteration
        case addQuantity
        case decreaseQuantity
        case removeProduct
        var eventString:String {
            switch self {
            case .noAlteration: return ""
            case .addQuantity: return "add"
            case .decreaseQuantity: return "delete"
            case .removeProduct: return "remove"
            }
        }
    }
    //MARK:- IBOutlets
    @IBOutlet weak var cartTBView: UITableView!
    @IBOutlet weak var promoTxtFld: UITextField!
    @IBOutlet weak var totalItemCount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var subscribeBtn: UIButton! {    didSet {    self.subscribeBtn.setCornerRadiusOfView(cornerRadiusValue: 25)  }   }
    @IBOutlet weak var checkOutBtn: UIButton! {    didSet {    self.checkOutBtn.setCornerRadiusOfView(cornerRadiusValue: 25)  }   }
    @IBOutlet weak var cartEmptyView: UIView!
    
    //MARK:- Local Variables

    var eventType: ProductQuantity = .noAlteration
    var cartModel = CartModel()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getCartList()
        setupView()
    }
    //MARK:- Internal Methods
    private func setupView(){
        setupTextfields()
        setUpTBView()
    }
    
    private func setupTextfields() {
        setPadding(textField: promoTxtFld)
        promoTxtFld.delegate = self
    }
    
    func setUpTBView(){
        /// Register Cells
        self.cartTBView.register(UINib(nibName: CartTVC.className(), bundle: nil), forCellReuseIdentifier: CartTVC.className())
        cartTBView.tableFooterView = UIView()
        cartTBView.estimatedRowHeight = 150
        cartTBView.rowHeight = 240
    }
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        self.view.makeToast("Under Development", duration: 3.0, position: .bottom)
    }
    @IBAction func subscribeBtnAction(_ sender: UIButton) {
        self.view.makeToast("Under Development", duration: 3.0, position: .bottom)

        //let addSubscriptionVC = AddSubscriptionVC()
        //addSubscriptionVC.addingSubscriptionType = .singleProduct
        
        //addSubscriptionVC.productArray =
        //self.navigationController?.pushViewController(addSubscriptionVC, animated: true)
        
    }
    @IBAction func checkOutBtnAction(_ sender: UIButton) {
        let checkOutVC = CheckoutVC()
        self.navigationController?.pushViewController(checkOutVC, animated: true)
    }
    
    @objc func decreaseQuantityBtn(sender:UIButton) {
        if sender.tag < cartModel.cartItems.count {
            eventType = .decreaseQuantity
            updateProductInCart(cartItem: cartModel.cartItems[sender.tag])
        }
    }
    
    @objc func addQuantityBtn(sender:UIButton) {
        if sender.tag < cartModel.cartItems.count {
            eventType = .addQuantity
            updateProductInCart(cartItem: cartModel.cartItems[sender.tag])
        }
    }
    
    @objc func removeCartItem(sender:UIButton) {
        if sender.tag < cartModel.cartItems.count {
            eventType = .removeProduct
            updateProductInCart(cartItem: cartModel.cartItems[sender.tag])
        }
    }
}

extension CartVC: UITextFieldDelegate {
}


extension CartVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVC.className(), for: indexPath) as! CartTVC
        cell.setupCellUI(index: indexPath.row)
        cell.addquantityBtn.addTarget(self, action: #selector(addQuantityBtn(sender:)), for: .touchUpInside)
        cell.decreasequantitybtn.addTarget(self, action: #selector(decreaseQuantityBtn(sender:)), for: .touchUpInside)
        cell.crossBtn.addTarget(self, action: #selector(removeCartItem(sender:)), for: .touchUpInside)
        cell.setUpCellData(cartItemObj: cartModel.cartItems[indexPath.row])
        return cell
    }
}

extension CartVC {
    func getCartList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getCartListUrl : String = UrlName.baseUrl + UrlName.getCartItemsUrl + Defaults.getUserID()
            let parameters = [
                "customer_id":Defaults.getUserID(),
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: getCartListUrl, method: .get, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let cartlist = jsonValue[APIField.dataKey]?.array {
                        var cartItems = Array<CartItemModel>()
                        for cartItem in cartlist {
                            let cartItem = CartItemModel.init(json: cartItem)
                            cartItems.append(cartItem)
                        }
                        self.cartModel.cartItems = cartItems
                    }
                    self.cartModel.totalPrice = jsonValue["total_price"]?.stringValue ?? ""
                    DispatchQueue.main.async {
                        self.cartEmptyView.isHidden = self.cartModel.cartItems.count > 0
                        self.cartTBView.reloadData()
                        let text = self.cartModel.cartItems.count == 1 ? "Item": "Items"
                        self.totalItemCount.text = "\(self.cartModel.cartItems.count) \(text)"
                        self.totalAmount.text = "Total AED \(self.cartModel.totalPrice)"
                    }
                }else {
                    DispatchQueue.main.async {
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
    
    func updateProductInCart(cartItem:CartItemModel) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addToCartUrl : String = UrlName.baseUrl + UrlName.addToCartUrl
            
            let parameters = [
                "customer_id":Defaults.getUserID(),
                "product_id":cartItem.productID,
                "unit_atrributes_id":"",
                "unit_measure":"litter",
                "price":cartItem.itemPrice,
                "quantity": eventType == .removeProduct ? cartItem.cartQuantity : "1",
                "event":eventType == .decreaseQuantity && cartItem.cartQuantity == "1" ?   "remove"   : eventType.eventString
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
                        self.getCartList()
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

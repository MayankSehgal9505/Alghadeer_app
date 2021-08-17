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
    @IBOutlet weak var promocodeView: UIView!{    didSet {    self.promocodeView.setCornerRadiusOfView(cornerRadiusValue: 15)  }   }
    @IBOutlet weak var totalPriceView: UIView! {    didSet {    self.totalPriceView.setCornerRadiusOfView(cornerRadiusValue: 15)  }   }
    @IBOutlet weak var cartTBView: UITableView!
    @IBOutlet weak var promoTxtFld: UITextField!
    @IBOutlet weak var totalItemCount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var subscribeBtn: UIButton! {    didSet {    self.subscribeBtn.setCornerRadiusOfView(cornerRadiusValue: 15)  }   }
    @IBOutlet weak var checkOutBtn: UIButton! {    didSet {    self.checkOutBtn.setCornerRadiusOfView(cornerRadiusValue: 15)  }   }
    @IBOutlet weak var cartEmptyView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var percentageOffLbl: UILabel!
    @IBOutlet weak var couponAmount: UILabel!
    @IBOutlet weak var finalAmountLbll: UILabel!
    @IBOutlet weak var cartText: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    
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
        promoTxtFld.placeholder = Bundle.main.localizedString(forKey: "Promo code", value: nil, table: nil)
        cartText.text = Bundle.main.localizedString(forKey: "Cart", value: nil, table: nil)
        subscribeBtn.setTitle(Bundle.main.localizedString(forKey: "Subscribe", value: nil, table: nil), for: [])
        applyBtn.setTitle(Bundle.main.localizedString(forKey: "Apply", value: nil, table: nil), for: [])
        checkOutBtn.setTitle(Bundle.main.localizedString(forKey: "Checkout", value: nil, table: nil), for: [])
    }
    
    private func setupTextfields() {
        setPadding(textField: promoTxtFld)
    }
    
    func setUpTBView(){
        /// Register Cells
        self.cartTBView.register(UINib(nibName: CartTVC.className(), bundle: nil), forCellReuseIdentifier: CartTVC.className())
        cartTBView.tableFooterView = UIView()
        cartTBView.estimatedRowHeight = 150
        cartTBView.rowHeight = UITableView.automaticDimension
    }
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        if ((self.promoTxtFld.text?.isEmpty)!) {
            self.view.makeToast("Enter your Coupon", duration: 3.0, position: .bottom)
        } else {
            applyPromoCode()
        }
    }
    @IBAction func subscribeBtnAction(_ sender: UIButton) {
        let addSubscriptionVC = AddSubscriptionVC()
        addSubscriptionVC.addingSubscriptionType = .singleProduct
        addSubscriptionVC.productIDs = cartModel.cartItems.map{$0.productID}
        self.navigationController?.pushViewController(addSubscriptionVC, animated: true)
        
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
    func applyPromoCode() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let promoCodeUrl : String = UrlName.baseUrl + UrlName.promoCodeUrl
            let parameters = [
                "amount": Double(self.totalAmount.text!) ?? 0.0,
                "couponcode":self.promoTxtFld.text!,
                "customer_id":Defaults.getUserID(),
            ] as [String : Any]
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: promoCodeUrl, method: .post, parameters: parameters, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                print(jsonValue)
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true,let data = jsonValue[APIField.dataKey]?.dictionaryValue {
                    DispatchQueue.main.async {
                        self.discountView.isHidden = false
                        self.percentageOffLbl.text = "\(data["coupon_value"]?.stringValue ?? "0") % Off"
                        let totalPriceDouble = (Double(self.cartModel.totalPrice) ?? 0.0 ) * (Double(data["coupon_value"]?.stringValue ?? "0") ?? 0.0 )
                        self.couponAmount.text = "Coupon Amount \(totalPriceDouble/100)"
                        self.finalAmountLbll.text = "Final Amount \((Double(self.cartModel.totalPrice) ?? 0.0 )-(totalPriceDouble/100))"
                    }
                }else {
                    DispatchQueue.main.async {
                        self.view.makeToast("Coupon code not valid", duration: 3.0, position: .bottom)
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
                        let text = self.cartModel.cartItems.count == 1 ? Bundle.main.localizedString(forKey: "Item", value: nil, table: nil): Bundle.main.localizedString(forKey: "Items", value: nil, table: nil)
                        self.totalItemCount.text =  "\(self.cartModel.cartItems.count) \(text)"
                        self.totalAmount.text = "\(Bundle.main.localizedString(forKey: "Total", value: nil, table: nil)) AED \(self.cartModel.totalPrice)"
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

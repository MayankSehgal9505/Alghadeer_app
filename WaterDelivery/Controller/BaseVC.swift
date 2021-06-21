//
//  BaseVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 06/06/21.
//

import Foundation
import UIKit
protocol CartListAPI:class {}
extension CartListAPI where Self : CartBaseVC{
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
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        if let cartCountString = jsonValue["TotalCount"]?.stringValue, let cartCount = Int(cartCountString), cartCount > 0 {
                            self.cartView(hidden: false, count: cartCountString)
                        } else {
                            self.cartView(hidden: true, count: "0")
                        }
                    }
                }
            })
        }
    }
}
class CartBaseVC: UIViewController,CartListAPI {
    
    // MARK:- IBOutlets
    @IBOutlet weak var cartCountView: UIView! {didSet {self.cartCountView.makeViewCircle()}}
    @IBOutlet weak var cartCountlbl: UILabel!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        cartView(hidden: true, count: "0")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartCountList()
    }

    // MARK:- Internal Methods
    fileprivate func cartView(hidden: Bool, count:String) {
        cartCountView.isHidden = hidden
        cartCountlbl.text = count
    }
    
    private func moveToCartsVC() {
        let cartVC = CartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    // MARK:- IBActions 

    @IBAction func goToCartBtnAction(_ sender: UIButton) {
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
            moveToCartsVC()
        }
    }
}

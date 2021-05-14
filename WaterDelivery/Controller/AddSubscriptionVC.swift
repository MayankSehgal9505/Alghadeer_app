//
//  AddSubscriptionVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 15/05/21.
//

import UIKit

class AddSubscriptionVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var cartCountView: UIView! {didSet {self.cartCountView.makeViewCircle()}}
    @IBOutlet weak var cartCountLbl: UILabel!
    //MARK:- Local Variables
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getCartCountList()
        setupUI()
    }

    //MARK:- Internal Methods
    private func setupUI() {
        cartView(hidden: true, count: "0")
    }
    
    private func setUpTBView(){

    }
    
    func cartView(hidden: Bool, count:String) {
        cartCountView.isHidden = hidden
        cartCountLbl.text = count
    }
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartBtnAction(_ sender: UIButton) {
        let cartVC = CartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
}

//MARK:-API Call Methods
extension AddSubscriptionVC{
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
            })
        }
    }
}

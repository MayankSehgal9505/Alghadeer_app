//
//  GetAddresses.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 11/06/21.
//

import Foundation
import UIKit
protocol AddressProtocol:class {
    var shippingAddressArray: Array<AddressModel> {get set}
    var selectedAddress: AddressModel {get set}
}
extension AddressProtocol where Self : UIViewController{
    func getAddressList(loaderRequired: Bool = true,completion: @escaping ()->Void) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            if (loaderRequired) {   self.showHUD(progressLabel: AlertField.loaderString)    }
            let addressListURL : String = UrlName.baseUrl + UrlName.getAddressListUrl + Defaults.getUserID()
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: addressListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        if (loaderRequired) { self.dismissHUD(isAnimated: true)   }
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let addresslist = jsonValue[APIField.dataKey]?.array {
                        var shippingAddress = Array<AddressModel>()
                        for address in addresslist {
                            let addressModel = AddressModel.init(json: address)
                            shippingAddress.append(addressModel)
                        }
                        self.shippingAddressArray = shippingAddress
                        self.selectedAddress = self.shippingAddressArray.first ?? AddressModel()
                        if self.shippingAddressArray.count >= 1 {
                            self.shippingAddressArray[0].addressSelected = true
                        }
                    }
                    completion()
                }
                else {
                    DispatchQueue.main.async {
                    self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                    }
                }
                DispatchQueue.main.async {
                    if (loaderRequired) { self.dismissHUD(isAnimated: true) }
                }
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    
    func deleteAddress(addressID: String,completion: @escaping ()->Void) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let addressListURL : String = UrlName.baseUrl + UrlName.deleteAddressUrl + "\(addressID)"
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: addressListURL, method: .delete, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    DispatchQueue.main.async {
                        self.getAddressList {
                            completion()
                        }
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
}

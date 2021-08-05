//
//  Constants.swift
//  Equal Infotech
//
//  Created by Equal Infotech on 15/05/19.
//  Copyright © 2019 Equal Infotech. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Identifier
struct Identifier {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
}

// MARK:- Screen Sizes
struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
}

// MARK:- Colour
struct Color {
    static let primaryColour = "#c70005" //199 0 5
    //29 91 254 //1D5BFE
    // Device Model iPhone XS Max
}

//MARK: - URL
struct UrlName {
    // base url
    static let baseUrl = "http://demo.equalinfotech.com/Waterdelivery/api/"
    
    //SSO URLS
    static let loginUrl = "Auth/login"
    static let loginOtpUrl = "Auth/otp"
    static let resendOtpUrl = "User_registration/resendotp"
    static let verifyOTPUrl = "User_registration/verification"
    //Dasshboard urls
    static let getBannerUrl = "Master/GetBanner"
    static let getCategoryListUrl = "Category/CategoryList/0"
    static let getProductListUrl = "Product/productList/0/1"
    static let getProductDetailUrl = "Product/productDetails/"
    static let getCartQuantityUrl = "cart/getquantity"
    static let getCategoryDetailUrl = "Category/categoryDetails/"   // Un used api
    static let getProductListByCategoryID = "Category/ByCcategoryIdGetProductList/"

    //Cart Items Url
    static let addToCartUrl = "Cart/addToCart"
    static let getCartItemsUrl = "Cart/cartList/"
    static let getCartCountUrl = "Cart/cartTotalCount/"
    static let promoCodeUrl = "Coupon/couponCode"

    // Address URLs
    static let getAddressListUrl = "Address/getAddressList/"
    static let addAddressUrl = "Address/add"
    static let addAddressNewUrl = "Address/addAddress_post"
    static let updateAddressUrl = "Address/update/"
    static let deleteAddressUrl = "Address/deleteAddress/"
    static let getStates = "Address/getCityList"
    static let getCities = "Address/getDistrictList/"
    // User Profile URLS
    static let getUserDetailUrl = "User_registration/getUser/"
    static let updateUserDetailUrl = "User_registration/userUpdate/"
    static let updateUserImgUrl = "User_registration/profile"
    
    // businesss urls
    static let getBusinessUrl = "Master/GetBusinessType"
    static let setBusinessUrl = "User_registration/businessTypesUpdate/"
    // FAQ URL
    static let faqUrl = "Common/faqContact/faq"
    
    // CONTACT US URL
    static let contactUrl = "Common/faqContact/contactus"
    static let enquiryUrl = "Address/contactus"
    // LogOut Url
    static let logOutUrl = "Auth/logout"

    // Subscription apis
    static let addSubscriptionUrl = "SubscriptionOrder/addSubscriptionOrder"
    static let getSubscriptionUrl = "SubscriptionOrder/SubscriptionOrderList/"
    static let updateSubscriptionUrl = "SubscriptionOrder/subscriptionUpdate/"
    static let deliveryTimeUrl = "SubscriptionOrder/DeliveryTimeslot"

    
    // My Deliveries Urls
    static let orderListUrl = "Order/OrderList"

    // Order Checkout
    static let cartCheckOutUrl = "Order/checkout"
    static let orderCheckOutUrl = "Payment/Ordercheckout"
    static let orderTotalUrl = "Payment/OrderTotal"
    //wallet urls
    static let walletBalance = "Common/walletBalance/"
    static let walletTransactionsDebit = "Common/walletTransactionDebit/"
    static let walletTransactionsCredit = "Common/walletTransactionCredit/"
    static let addMoneyInWallet = "Payment/WalletCheckouts"
    static let paymentStatusUrl = "Payment/checkouts/"
    
    
    static let notifications = "Customer/getNotification/"
}

struct WalletCallBacks {
    static let successURLS = "https://pay.test.pointcheckout.com/hosted/payment-confirmation"
    static let cancelURLS = "https://pay.test.pointcheckout.com/hosted/cancel"
    static let completionUrls = [successURLS,cancelURLS]
}

// MARK:- Web Service Params
struct APIField {
    static let getMethod = "GET"
    static let postMethod = "POST"
    static let devicename = "IOS"
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let errorKey = "error"
    static let dataKey = "data"
    static let reg_idKey = "reg_id"
    static let messageKey = "message"
    static let codeKey = "code"
    static let successKey = "success"
    static let statusKey = "status"
    static let tokenKey = "token"
    static let expiredToken = "Expired token"
}

// MARK: - User Defaults
struct UserDefaultsKey {
    static let isAlreadyLoginString = "isAlreadyLogin"
    static let loginData = "loginData"
    static let userId = "userId"
    static let defaultToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjIzMCIsImVtYWlsIjoic3ByYiIsImlhdCI6MTYyNDI4MTY4MiwiZXhwIjo0Nzc3ODgxNjgyfQ.32Gv4qxC6dttp4sbMKmFh1i-Ku69WUgsAoDVzQcRIyg"
}

// MARK: - AlertField Names
struct AlertField {
    static let emptycategoString = "Please select category"
    static let emptyReffString = "Select a referral source"
    static let emptyServeString = "Please enter Suburb/State/postcode"
    static let emptyDobString = "Please enter Dob"
    static let emptyNameString = "Please enter name."
    static let emptyFnameString = "Please enter first name."
    static let emptyLnameString = "Please enter last name."
    static let emptyLearnString = "Please select learn type."
    static let emptyTeachString = "Please select teach type."
    static let emptyLanguageString = "Please select Language."
    static let emptyCountryString = "Please enter Country."
    static let emptyEmailString = "Please enter email address."
    static let emptyPassString = "Please enter password."
    static let emptyCPassString = "Please enter confirm password."
    static let passNotMatchString = "Password does not match the confirm password."
    static let emptyReasonString = "Plese select reason."
    static let blankAmountString = "Please enter the amount"
    static let blankCardString = "Please enter card number"
    static let blankCVVString = "Please enter CVV"
    static let blankMMString = "Please enter month"
    static let blankYrString = "Please enter year"
    static let emptyOtpString = "Please enter otp number"
    static let emptyMobileString = "Please enter mobile number"
    static let emailNotValidString = "Email address is not valid."
    static let mobileNotValidString = "Mobile number is not valid."
    static let wrongOtpString = "Please enter the correct otp to continue."
    static let okString = "Ok"
    static let cancelString = "Cancel"
    static let scanAlertTitle = "Scanning not supported"
    static let scanAlertMessage = "Your device does not support scanning a code from an item. Please use a device with a camera."
    static let warningString = "Warning!"
    static let loaderString = "Loading..."
    static let noInternetString = "Seems like your internet services are disabled, please go to Settings and turn on Internet Services."
    static let oopsString = "OOPS!!!"
    static let saveMsgString = "Your image has been saved to your photos."
    static let saveString = "Saved!"
    static let errorString = "Error"
    static let noString = "NO"
    static let yesString = "YES"
    static let alertString = "Alert!"
    static let wentWrongString = "Something went wrong, Please try again later"
    static let NaString = "N/A"
}

struct SideMenu {
    //MARK:- SideMenu Controller
    static let sideMenuOptionslabel = ["Home","My Profile","Wallet","Subscriptions","My Deliveries","Refer a Friend","FAQ","Contact Us","Select Language","Logout"]
    static let sideMenuOptionImage = ["home","user","wallet","subscription","delivery","refer-friend","faq","contact-icon","language","logout"]
}


enum ViewControllerID {
    static let mainViewController = "MainViewController"
    static let leftMenuViewController = "LeftMenuViewController"
    static let rightMenuViewController = "RightMenuViewController"
    static let secondViewController = "SecondViewController"
    static let nonMenuViewController = "NonMenuViewController"
    static let customTabbarViewController = "CustomTabBarViewController"
    static let settingsViewController = "SettingsViewController"
}

enum ViewID {
    static let leftHeaderView = "LeftHeaderView"
}

enum StoryboardID {
    static let main = "Main"
}
//Class ends here

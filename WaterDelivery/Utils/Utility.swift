//
//  Utility.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 30/04/21.
//

import Foundation
import UIKit
import REFrostedViewController
class Utility {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /// If user is already logged in
    static func checkIfAlreadyLogin(vc: UIViewController) {
        if Defaults.isUserLoggedIn() {
            //makeRootViewController(vc: vc)
            loginRootVC()

        } else {
            loginRootVC()
        }
    }

    static func makeRootViewController(vc:UIViewController){
        let homeVcObj = DashboardVC.init(nibName: DashboardVC.className(), bundle: nil)
        //let homeVcObj = CheckoutVC.init(nibName: CheckoutVC.className(), bundle: nil)
        let centrenav  = UINavigationController(rootViewController:homeVcObj)
        let sideMenuVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenuVC.className()) as! SideMenuVC
        let container = REFrostedViewController(contentViewController: centrenav, menuViewController: sideMenuVc)
        container?.direction = .left
        container?.limitMenuViewSize = true
        container?.panGestureEnabled = true
        container?.menuViewSize = CGSize(width: UIScreen.main.bounds.size.width * 0.73 , height: UIScreen.main.bounds.size.height)
        vc.navigationController?.pushViewController(container!, animated: true)
    }
    
    static func loginRootVC() {
        //let loginVC = LoginVC()
        let subscription = SubscriptionVC()
        let rootVC = UINavigationController(rootViewController: subscription)
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.makeKeyAndVisible()
    }
}

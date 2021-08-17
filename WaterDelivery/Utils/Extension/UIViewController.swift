//
//  UIViewController.swift
//  TabbarWithSideMenu
//
//  Created by Sunil Prajapati on 20/04/18.
//  Copyright © 2018 sunil.prajapati. All rights reserved.
//

import UIKit
import MBProgressHUD
import REFrostedViewController

extension UIViewController {
    
    /// Showing loader on API call
    ///
    /// - Parameter progressLabel: Loader message
    func showHUD(progressLabel:String){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = Bundle.main.localizedString(forKey: progressLabel, value: nil, table: nil)
    }

     ///Dismiss loader after API response
    ///
    /// - Parameter isAnimated: animation
    func dismissHUD(isAnimated:Bool) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
    /// Method to show alert when no internet connection
    func showSessionExpiredAlert(){
        let alertView = UIAlertController(title: "Session Expired", message: "Your session has been expired, logging out from app", preferredStyle: .alert)
        let action = UIAlertAction(title: AlertField.okString, style: .default, handler: { (alert) in
            //Sign out action
            Defaults.resetDefaults()
            Utility.checkIfAlreadyLogin()
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    /// Method to show alert when no internet connection
    func showNoInternetAlert(){
        let alertView = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertField.okString, style: .default, handler: { (alert) in
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    /// Showing generic alert
    ///
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: description of alert
    @objc func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: AlertField.okString, style: .default))
        present(ac, animated: true)
    }


    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    // set Padding Of textfield
       func setPadding(textField: UITextField){
           textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
           textField.leftViewMode = .always
       }
    
    func setCornerWithColor(aView: UIView, radius:CGFloat, color: UIColor = UIColor(red: 21/255.0, green: 75/255.0, blue: 214/255.0, alpha: 1)){
        aView.setCornerRadiusOfView(cornerRadiusValue: radius)
        aView.layer.borderWidth = 1.0
        aView.layer.borderColor = color.cgColor
    }
    
    /**
     go back Alert
     - Show alert with title and alert message and basic two actions
     */
    func showNoDataAlert(message:String) {
        let alert = UIAlertController(title: AlertField.alertString, message: message,         preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertField.okString,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    //Load the UIView using Nibname
    func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    //Check current viewcontroller is presented, Pushed or not
    func isModal() -> Bool {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first != self {
                return false
            }
        }
        if self.presentingViewController != nil {
            return true
        }
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    //Get topViewController from UIApllication Window or Current Navigation Controller
    public func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    func makeRootViewController(){
            let homeVcObj = DashboardVC.init(nibName: DashboardVC.className(), bundle: nil)
            //let homeVcObj = CheckoutVC.init(nibName: CheckoutVC.className(), bundle: nil)
            let centrenav  = UINavigationController(rootViewController:homeVcObj)
            let sideMenuVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenuVC.className()) as! SideMenuVC
            let container = REFrostedViewController(contentViewController: centrenav, menuViewController: sideMenuVc)
            container?.direction = .left
            container?.limitMenuViewSize = true
            container?.panGestureEnabled = true
            container?.menuViewSize = CGSize(width: UIScreen.main.bounds.size.width * 0.73 , height: UIScreen.main.bounds.size.height)
        self.navigationController?.pushViewController(container!, animated: true)
    }
}

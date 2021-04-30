//
//  ViewController.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /// If user is already logged in
    func checkIfAlreadyLogin() {
        if Defaults.isUserLoggedIn() {
            makeRootViewController()
        } else {
            let obj = LoginVC.init(nibName: LoginVC.className(), bundle: nil)
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        Utility.checkIfAlreadyLogin(vc: self)
    }

}


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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        Utility.checkIfAlreadyLogin(vc: self)
    }

}


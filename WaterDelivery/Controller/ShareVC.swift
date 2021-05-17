//
//  ShareVC.swift
//  LoT
//
//  Created by Vedvyas Rauniyar on 13/02/21.
//

import UIKit

class ShareVC: UIViewController {

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        self.frostedViewController.presentMenuViewController()
    }

}

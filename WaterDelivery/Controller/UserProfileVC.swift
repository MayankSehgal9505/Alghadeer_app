//
//  UserProfileVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 07/05/21.
//

import UIKit

class UserProfileVC: UIViewController {

    //MARK:- IBOutlets
    //MARK:- Local Variables
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:- Internal Methods

    
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

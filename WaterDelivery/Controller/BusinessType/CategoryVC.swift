//
//  CategoryVC.swift
//  WaterDelivery
//
//  Created by Vedvyas Rauniyar on 20/04/21.
//

import UIKit

class CategoryVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var categoView,emailView: UIView!
    @IBOutlet weak var categotyTF,emailTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView(){
        self.nextButton.setCornerRadiusOfView(cornerRadiusValue: 25)
        self.setCornerWithColor(aView: self.categoView, radius: 0)
        self.setCornerWithColor(aView: self.emailView, radius: 0)
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        showOptions()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
         if (self.categotyTF.text?.isEmpty)! {
            self.view.makeToast(AlertField.emptycategoString, duration: 3.0, position: .bottom)
            return
        }
        else if (self.emailTF.text?.isEmpty)! {
           self.view.makeToast(AlertField.emptyEmailString, duration: 3.0, position: .bottom)
           return
        }
        else if (!self.isValidEmail(emailStr: emailTF.text!)) {
            self.view.makeToast(AlertField.emailNotValidString, duration: 3.0, position: .bottom)
            return
        }
         else {
            Defaults.setUserLoggedIn(userLoggedIn: true)
            makeRootViewController()
         //   loginAPI()
        }
    }
}

extension CategoryVC {
    func showOptions(){
        let alert = UIAlertController(title: "Please select category", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Business", style: .default , handler:{ (UIAlertAction)in
                self.categotyTF.text = "Business"
           }))
           alert.addAction(UIAlertAction(title: "Individual", style: .default , handler:{ (UIAlertAction)in
            self.categotyTF.text = "Individual"
           }))
           self.present(alert, animated: true, completion: {
               print("completion block")
           })
    }
}

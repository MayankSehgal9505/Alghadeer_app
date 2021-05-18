//
//  ShareVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 18/05/21.
//

import UIKit

class ShareVC: UIViewController {
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.text = UserData.sharedInstance.userModel.userName

    }

    func commonMethod() {
        // text to share
        let text = "I would like to share app"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func backBBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func mailTapped(_ sender: UIButton) { commonMethod()

    }
    @IBAction func whatsappTapped(_ sender: UIButton) {
        commonMethod()
    }
    @IBAction func LineTapped(_ sender: UIButton) {
        commonMethod()
    }
    @IBAction func gplusDowload(_ sender: UIButton) {
        commonMethod()
    }
    @IBAction func fbTapped(_ sender: UIButton) {
        commonMethod()
    }
    
    @IBAction func twitterBtn(_ sender: UIButton) {commonMethod()
    }
}

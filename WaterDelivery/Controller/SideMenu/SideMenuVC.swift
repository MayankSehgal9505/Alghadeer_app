//
//  SideMenuVC.swift
//  Mtrac 2.0
//
//  Created by Innobins on 12/14/18.
//  Copyright © 2018 innobins. All rights reserved.
//

import UIKit
import REFrostedViewController

class SideMenuVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    //MARK: Variables
   
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = "v\(appVersion)"
            appVersionLabel.isHidden = false
        } else {
            appVersionLabel.isHidden = true
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    func setUpTableView() {
        self.sideMenuTableView.register(UINib.init(nibName: SideMenuHeaderCell.className(), bundle: nil), forCellReuseIdentifier: SideMenuHeaderCell.className())
        self.sideMenuTableView.estimatedRowHeight = 50.0
        self.sideMenuTableView.rowHeight = UITableView.automaticDimension
        self.sideMenuTableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0);
        
    }
    func moveToController(_ controllerToMove: UIViewController)  {
        self.frostedViewController.hideMenuViewController()
        if let nav = self.frostedViewController.contentViewController as? UINavigationController {
            nav.popToRootViewController(animated: false)
            nav.pushViewController(controllerToMove, animated: false)
        }
    }
    /**
     Simple Alert
     - Show alert with title and alert message and basic two actions
     */
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Logout?", message: "You can always access your content by signing back in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Logout",style: .default,handler: {(_: UIAlertAction!) in
            //Sign out action
            self.resetData()
            self.makeInitialViewController()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetData(){
        Defaults.resetDefaults()
    }
    
    func makeInitialViewController(){
           let vcObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewController.className()) as! ViewController
            let centrenav  = UINavigationController(rootViewController:vcObj)
            let sideMenuVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SideMenuVC.className()) as! SideMenuVC
            let container = REFrostedViewController(contentViewController: centrenav, menuViewController: sideMenuVc)
            container?.direction = .left
            container?.limitMenuViewSize = true
            container?.panGestureEnabled = true
            container?.menuViewSize = CGSize(width: UIScreen.main.bounds.size.width * 0.73 , height: UIScreen.main.bounds.size.height)
        self.navigationController?.pushViewController(container!, animated: true)
    }
    
    //MARK:- IBActions
    @objc func userProfileAction() {
        
    }
    
    @objc func crossBtnAction() {
        self.frostedViewController.hideMenuViewController()
    }
}

extension SideMenuVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else {
            return SideMenu.sideMenuOptionslabel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuHeaderCell.className(), for: indexPath) as! SideMenuHeaderCell
            cell.userProfileBtn.addTarget(self, action: #selector(userProfileAction), for: .touchUpInside)
            cell.crossBtn.addTarget(self, action:  #selector(crossBtnAction), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.className(), for: indexPath) as! SideMenuTableViewCell
            cell.setUpCell(index: indexPath.row)
            return cell
        }
    }
}
extension SideMenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controllerToMove: UIViewController!
        switch indexPath.row {
        
       // ["Home","My Profile","Wallet","Subscriptions","My Deliveries","Refer a Friend","FAQ","Scanner","Contact Us","Logout"]
        case 0:
            controllerToMove = DashboardVC(nibName: DashboardVC.className(), bundle: nil)
            moveToController(controllerToMove)
        case 1:
            self.view.makeToast("Unnder Development", duration: 3.0, position: .bottom)
            //controllerToMove = UserProfileVC(nibName: UserProfileVC.className(), bundle: nil)
            //moveToController(controllerToMove)
        case 2:
            print("Wallet")
        case 3:
            print("Subscriptions")
        case 4:
            print("My Deliveries")
        case 5:
            print("Refer a Friend")
        case 6:
            print("FAQ")
        case 7:
            print("Scanner ")
        case 8:
            print("Contact Us")
        case 9:
            self.showLogoutAlert()
        default:
          print("Error in getting VC")
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 210
        }
        else {
            return 45
        }
    }
    
}


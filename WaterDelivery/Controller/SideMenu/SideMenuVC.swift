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
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccepted(notification:)), name: NSNotification.Name(rawValue: "updateUserInfo"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateUserInfo"), object: nil)
    }

    @objc func updateAccepted(notification: Notification) {
        sideMenuTableView.reloadSections(IndexSet.init(integer: 0), with: .none)
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
    @objc func changeOfLanguage(){
        if Defaults.getEnglishLangauge() == "en"{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.view.layoutIfNeeded()
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.view.layoutIfNeeded()
        }
    }
    /**
     Simple Alert
     - Show alert with title and alert message and basic two actions
     */
    func showLogoutAlert() {
        let alert = UIAlertController(title: Bundle.main.localizedString(forKey: "Logout?", value: nil, table: nil), message: Bundle.main.localizedString(forKey: "You can always access your content by signing back in", value: nil, table: nil), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Bundle.main.localizedString(forKey: "Cancel", value: nil, table: nil), style: .default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: Bundle.main.localizedString(forKey: "Logout", value: nil, table: nil),style: .default,handler: {(_: UIAlertAction!) in
            self.callLogOut()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetData(){
        Defaults.resetDefaults()
    }
    private func showLoginPopup() {
        self.frostedViewController.hideMenuViewController()
        let alert = UIAlertController(title: "Guest Login", message: "Please Login/Signup to continue further", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Ok",style: .default,handler: {(_: UIAlertAction!) in
            Defaults.resetDefaults()
            Utility.checkIfAlreadyLogin()
        }))
        self.present(alert, animated: true, completion: nil)
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
extension SideMenuVC {
    func callLogOut() {
        self.showHUD(progressLabel: AlertField.loaderString)
        let addressListURL : String = UrlName.baseUrl + UrlName.logOutUrl
        NetworkManager.sharedInstance.commonApiCall(url: addressListURL, method: .get, parameters: nil, completionHandler: { (json, status) in
            //Sign out action
            DispatchQueue.main.async {
                self.resetData()
                Utility.checkIfAlreadyLogin()
            }
        })
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
            if Defaults.getSkipLogin() {
                showLoginPopup()
            } else {
                controllerToMove = UserProfileVC(nibName: UserProfileVC.className(), bundle: nil)
                moveToController(controllerToMove)
            }
        case 2:
            if Defaults.getSkipLogin() {
                showLoginPopup()
            } else {
                controllerToMove = WalletVC(nibName: WalletVC.className(), bundle: nil)
                moveToController(controllerToMove)
            }
        case 3:
            if Defaults.getSkipLogin() {
                showLoginPopup()
            } else {
                controllerToMove = SubscriptionVC(nibName: SubscriptionVC.className(), bundle: nil)
                moveToController(controllerToMove)
            }
        case 4:
            if Defaults.getSkipLogin() {
                showLoginPopup()
            } else {
                controllerToMove = DeliveryVC(nibName: DeliveryVC.className(), bundle: nil)
                moveToController(controllerToMove)
            }
        case 5:
            controllerToMove = ShareVC(nibName: ShareVC.className(), bundle: nil)
            moveToController(controllerToMove)
        case 6:
            controllerToMove = FAQVC(nibName: FAQVC.className(), bundle: nil)
            moveToController(controllerToMove)
        case 7:
            controllerToMove = ContactUsVC(nibName: ContactUsVC.className(), bundle: nil)
            moveToController(controllerToMove)
        case 8:
            self.frostedViewController.hideMenuViewController()
            showOptions()
        case 9:
            self.frostedViewController.hideMenuViewController()
            self.showLogoutAlert()
        default:
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

extension SideMenuVC {
    func showOptions(){
        let alert = UIAlertController(title: "Select Language", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "English", style: .default , handler:{ (UIAlertAction)in
            Defaults.setEnglishLangauge("en")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChange"), object: nil)
            Utility.makeRootViewController()

        }))
        alert.addAction(UIAlertAction(title: "Arabic", style: .default , handler:{ (UIAlertAction)in
            Defaults.setEnglishLangauge("ar")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChange"), object: nil)
            Utility.makeRootViewController()
           }))
        self.present(alert, animated: true, completion:nil)
    }
}



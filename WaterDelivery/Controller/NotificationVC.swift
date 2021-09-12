//
//  NotificationVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 04/08/21.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var notificationTBView: UITableView!
    @IBOutlet weak var noData: UIView!
    @IBOutlet weak var notificationLbl: UILabel!
    
    //MARK:- Local Variables
    var notifications = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationLbl.text = Bundle.main.localizedString(forKey: "Notification", value: "", table: "")
        setUpTBView()
        getNotificationList()
    }
    
    //MARK:- Internal Methods
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setUpTBView(){
        /// Register Cells
        notificationTBView.register(UINib(nibName: NotificationCell.className(), bundle: nil), forCellReuseIdentifier: NotificationCell.className())
        notificationTBView.tableFooterView = UIView()
        notificationTBView.estimatedRowHeight = 50
        notificationTBView.rowHeight = UITableView.automaticDimension
    }
}

extension NotificationVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.className(), for: indexPath) as! NotificationCell
        cell.setupCell(notificationModelObj: notifications[indexPath.row])
        return cell
    }
}

//MARK:- API Calls
extension NotificationVC {
    func getNotificationList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let notificationListUrl : String = UrlName.baseUrl + UrlName.notifications + "\(Defaults.getUserID())/\(1)" + "/\(Defaults.getEnglishLangauge() == "en" ? 1 : 2)"
            NetworkManager.viewControler = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NetworkManager.sharedInstance.commonApiCall(url: notificationListUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                    guard let jsonValue = json?.dictionaryValue else {
                        DispatchQueue.main.async {
                            self.dismissHUD(isAnimated: true)
                            self.view.makeToast(status, duration: 3.0, position: .bottom)
                        }
                        return
                    }
                    
                    if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                        if let notifications = jsonValue[APIField.dataKey]?.array {
                            var notificationList = Array<NotificationModel>()
                            for notification in notifications{
                                let notificationModel = NotificationModel.init(json: notification)
                                notificationList.append(notificationModel)
                            }
                            self.notifications = notificationList
                        }
                        DispatchQueue.main.async {
                            self.notificationTBView.isHidden = self.notifications.count <= 0
                            self.noData.isHidden = !self.notificationTBView.isHidden
                            self.notificationTBView.reloadData()
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                        self.view.makeToast(jsonValue[APIField.messageKey]?.stringValue, duration: 3.0, position: .bottom)
                        }
                    }
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                    }
                })
            }
        }else{
            self.showNoInternetAlert()
        }
    }
}


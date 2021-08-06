//
//  FAQVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 16/05/21.
//

import UIKit

class FAQVC: UIViewController {

    //MARK:- IBOutles
    @IBOutlet weak var faqTBView: UITableView!
    //MARK:- Local Variables
    var faqs = [FAQModel]()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getFaqsList()
        setUpTBView()
    }
    //MARK:- Internal Methods
    private func setUpTBView(){
        /// Register Cells
        faqTBView.register(UINib(nibName: FAQTVC.className(), bundle: nil), forCellReuseIdentifier: FAQTVC.className())
        faqTBView.tableFooterView = UIView()
        faqTBView.estimatedRowHeight = 150
        faqTBView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func viewAnswerFor(sender:UIButton){
        if sender.tag < faqs.count {
            faqs[sender.tag].faqAnswerVisible = !faqs[sender.tag].faqAnswerVisible
            faqTBView.beginUpdates()
            faqTBView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            faqTBView.endUpdates()
        }
    }
    //MARK:- IBActions
    @IBAction func backBtnnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- API Calls
extension FAQVC {
    func getFaqsList() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let faqURL : String = UrlName.baseUrl + UrlName.faqUrl
            NetworkManager.viewControler = self
            NetworkManager.sharedInstance.commonApiCall(url: faqURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    DispatchQueue.main.async {
                        self.dismissHUD(isAnimated: true)
                        self.view.makeToast(status, duration: 3.0, position: .bottom)
                    }
                    return
                }
                
                if let apiSuccess = jsonValue[APIField.statusKey], apiSuccess == true {
                    if let faqslist = jsonValue[APIField.dataKey]?.array {
                        var faqs = Array<FAQModel>()
                        for faq in faqslist {
                            let faqModel = FAQModel.init(json: faq)
                            faqs.append(faqModel)
                        }
                        self.faqs = faqs
                    }
                    DispatchQueue.main.async {
                        self.faqTBView.reloadData()
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
        }else{
            self.showNoInternetAlert()
        }
    }
}


//MARK:- UITableViewDataSource & UITableViewDelegate Methods
extension FAQVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FAQTVC.className(), for: indexPath) as! FAQTVC
        cell.viewAnswerBtn.tag = indexPath.row
        cell.viewAnswerBtn.addTarget(self, action: #selector(viewAnswerFor(sender:)), for: .touchUpInside)
        cell.setupCell(faqModel: faqs[indexPath.row])
        return cell
    }
}

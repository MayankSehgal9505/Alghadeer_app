//
//  CheckoutVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 06/05/21.
//

import UIKit

class CheckoutVC: UIViewController {
    
    //MARK:-IBOutlets

    @IBOutlet weak var checkOutTBView: UITableView!
    @IBOutlet weak var continueToPaymentBtn: UIButton!
    @IBOutlet weak var scheduleTimeView: UIView!
    
    //MARK:- Local Variables
    var paymentTypeCart = false
    private var effectView,vibrantView : UIVisualEffectView?

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        setupUI()
    }
    //MARK:- Internal Methods
    func setUpTBView(){
        /// Register Cells
        self.checkOutTBView.register(UINib(nibName: ShippingTitleTVC.className(), bundle: nil), forCellReuseIdentifier: ShippingTitleTVC.className())
        self.checkOutTBView.register(UINib(nibName: ShippingAddressTVC.className(), bundle: nil), forCellReuseIdentifier: ShippingAddressTVC.className())
        self.checkOutTBView.register(UINib(nibName: InfoTVC.className(), bundle: nil), forCellReuseIdentifier: InfoTVC.className())
        self.checkOutTBView.register(UINib(nibName: ScheduleTimeTVC.className(), bundle: nil), forCellReuseIdentifier: ScheduleTimeTVC.className())
        self.checkOutTBView.register(UINib(nibName: PaymentTVC.className(), bundle: nil), forCellReuseIdentifier: PaymentTVC.className())
        self.checkOutTBView.register(UINib(nibName: CardTVC.className(), bundle: nil), forCellReuseIdentifier: CardTVC.className())
        self.checkOutTBView.register(UINib(nibName: SummaryTVC.className(), bundle: nil), forCellReuseIdentifier: SummaryTVC.className())
        
        checkOutTBView.tableFooterView = UIView()
        checkOutTBView.estimatedRowHeight = 150
        checkOutTBView.rowHeight = UITableView.automaticDimension
    }
    func setupUI() {
        setUpTBView()
        continueToPaymentBtn.setCornerRadiusOfView(cornerRadiusValue:30)
    }
    
    /// Hiding Picker View
    private func hidePickerView(){
        scheduleTimeView.isHidden = true
        vibrantView?.removeFromSuperview()
        effectView?.removeFromSuperview()
    }
    
    //MARK:-IBActions
    @IBAction func scheduleTimeCancelBtnActn(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func scheduleTimeSetBtnActn(_ sender: UIBarButtonItem) {
        hidePickerView()
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueToPaymentAction(_ sender: UIButton) {
        self.view.makeToast("Under Development", duration: 3.0, position: .bottom)
    }
    
    @objc func addAddressBtnTapped() {
        let addAddressVC = AddAddressVC()
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    @objc func cardOptionChoosen(sender:UIButton) {
        if !sender.isSelected {
            paymentTypeCart = true
            sender.isSelected = !sender.isSelected
            if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? PaymentTVC {
                checkOutTBView.reloadSections(IndexSet.init(integer: 4), with: .top)
                cell.walletBtnChoosen.isSelected = !sender.isSelected
            }
        }
    }
    @objc func walletOptionChoosen(sender:UIButton) {
        if !sender.isSelected {
            paymentTypeCart = false
            sender.isSelected = !sender.isSelected
            if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? PaymentTVC {
                checkOutTBView.reloadSections(IndexSet.init(integer: 4), with: .top)
                cell.cardBtnChoosen.isSelected = !sender.isSelected
            }
        }
    }
    
    @objc func addMoneyToWallet(){
        let selectAmountVC = SelectAmountVC()
        selectAmountVC.delegate = self
        self.navigationController?.pushViewController(selectAmountVC, animated: true)
    }
    
    @objc func cardChoosen() {
        
    }
}
extension CheckoutVC: SelectedAmountDelegate{
    func amountSelected(amount: String) {
        if let cell = checkOutTBView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? PaymentTVC {
            cell.walletMoney.setTitle(amount, for: [])
        }
    }
}
//MARK:-UItableViewDataSource Methods
extension CheckoutVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     return 2
        case 1:     return 1
        case 2:     return 1
        case 3:     return 1
        case 4:     return paymentTypeCart ? 1 : 0
        case 5:     return 1
        default:    return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ShippingTitleTVC.className(), for: indexPath) as! ShippingTitleTVC
                cell.setupCellUI()
                cell.addAddressBtn.addTarget(self, action: #selector(addAddressBtnTapped), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: ShippingAddressTVC.className(), for: indexPath) as! ShippingAddressTVC
                cell.setupCell()
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTVC.className(), for: indexPath) as! InfoTVC
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTimeTVC.className(), for: indexPath) as! ScheduleTimeTVC
            cell.setupCell()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTVC.className(), for: indexPath) as! PaymentTVC
            cell.cardBtnChoosen.addTarget(self, action: #selector(cardOptionChoosen), for: .touchUpInside)
            cell.walletBtnChoosen.addTarget(self, action: #selector(walletOptionChoosen), for: .touchUpInside)
            cell.walletMoney.addTarget(self, action: #selector(addMoneyToWallet), for: .touchUpInside)
            cell.setupCell()
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTVC.className(), for: indexPath) as! CardTVC
            cell.cardChoosen.addTarget(self, action: #selector(cardChoosen), for: .touchUpInside)
            cell.setupCell()
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTVC.className(), for: indexPath) as! SummaryTVC
            cell.setupCell()
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK:-UITableViewDelegate Methods

extension CheckoutVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            let viewArray = CommonMethods.showPopUpWithVibrancyView(on : self)
            self.view.window?.addSubview(scheduleTimeView)
            vibrantView = viewArray.first as? UIVisualEffectView
            effectView = (viewArray.last as? UIVisualEffectView)
            self.scheduleTimeView.isHidden = false
            CommonMethods.setPickerConstraintAccordingToDevice(pickerView: scheduleTimeView, view: self.view)
        default: break
        }
    }
}

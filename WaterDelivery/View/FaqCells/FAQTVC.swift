//
//  FAQTVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 17/05/21.
//

import UIKit

class FAQTVC: UITableViewCell {

    @IBOutlet weak var ParentView: UIView!
    @IBOutlet weak var faqQuesLbl: UILabel!
    @IBOutlet weak var faqAnswerLbl: UILabel!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var viewAnswerBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(faqModel:FAQModel) {
        ParentView.setCornerRadiusOfView(cornerRadiusValue: 15)
        faqQuesLbl.text = "Q\(faqModel.faqID). \(faqModel.faqQues)"
        faqAnswerLbl.text = "A\(faqModel.faqID). \(faqModel.faqAnswer)"
        viewAnswerBtn.isSelected = faqModel.faqAnswerVisible
        answerView.isHidden = !faqModel.faqAnswerVisible
    }
}

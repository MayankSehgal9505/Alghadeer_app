//
//  SideMenuHeaderCell.swift
//  Mtrac 2.0
//
//  Created by Innobins on 12/22/18.
//  Copyright © 2018 innobins. All rights reserved.
//

import UIKit
//import SDWebImage

class SideMenuHeaderCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userMobileNumber: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var userProfileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    //MARK:- Internal methods
    func setUpCell(){
        profileImageView.setCornerRadiusOfView(cornerRadiusValue: 50.0, setBorder: true, borderColor: .white, width: 2.0)
        userMobileNumber.text = "971 - \(Defaults.getUserPhoneNumber())"
        self.nameLabel.text = UserData.sharedInstance.userModel.userName
        if let imageURL = URL.init(string: UserData.sharedInstance.userModel.profileImgUrl) {
            profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
        } else {
            profileImageView.image = UIImage(named: "profile")
        }
    }
}

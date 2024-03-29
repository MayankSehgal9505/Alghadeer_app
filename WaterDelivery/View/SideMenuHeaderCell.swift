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
        profileImageView.makeRounded()
        userMobileNumber.text = Defaults.getUserPhoneNumber()
        self.nameLabel.text = "Dummy name"
//        if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.loginData),
//            let loginDetails = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserModel {
//            self.nameLabel.text = loginDetails.first_name + " " + loginDetails.last_name
//            self.profileImageView.setImage(with: loginDetails.user_image)
//
//        }
    }
}

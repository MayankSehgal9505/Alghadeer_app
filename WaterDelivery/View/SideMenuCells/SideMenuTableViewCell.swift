//
//  ViewController.swift
//  Mtrac 2.0
//
//  Created by Innobins on 12/14/18.
//  Copyright © 2018 innobins. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var sideMenuOptionLabel: UILabel!
    @IBOutlet weak var sideImage: UIImageView!
    
    //MARK:- Life Cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Internal methods

    func setUpCell(index: Int){
        self.sideMenuOptionLabel.text = SideMenu.sideMenuOptionslabel[index]
        self.sideImage.image = UIImage(named:SideMenu.sideMenuOptionImage[index])
        //https://storage.googleapis.com/innoprolife-9582d.appspot.com/Profile/LKIN-101-20181216_114514
    }
}

//
//  UIImageview.swift
//  Apptive Learn
//
//  Created by Ratna Sagar on 14/6/19.
//  Copyright © 2019 Ratna Sagar. All rights reserve
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    /// Set Image from server url
    ///
    /// - Parameter urlString: server url
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {return}
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        var kf = self.kf
        kf.indicatorType = .activity
        let image = UIImage()
        self.kf.setImage(with:resource, placeholder : image)
    }
      
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor(red: 28/255.0, green: 54/255.0, blue: 102/255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
//Class ends here


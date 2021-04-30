//
//  UIView.swift
//  Ratna Sagar
//
//  Created by Ratna Sagar on 14/6/19.
//  Copyright © 2019 Ratna Sagar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    // set cornerRadius Of view
    func setCornerRadiusOfView(cornerRadiusValue : CGFloat) {
        self.layer.cornerRadius = cornerRadiusValue
        self.clipsToBounds = true
    }
    
    func makeViewCircle() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}

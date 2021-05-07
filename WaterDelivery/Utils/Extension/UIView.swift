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
    func setCornerRadiusOfView(cornerRadiusValue : CGFloat,setBorder: Bool = false, borderColor: UIColor = .clear, width: CGFloat = 0.0) {
        self.layer.cornerRadius = cornerRadiusValue
        self.clipsToBounds = true
        if setBorder {
            self.layer.borderWidth = width
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    func makeViewCircle() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

    
    func setConstraintOfView(withRespectTo parentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
    }
    
}

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}

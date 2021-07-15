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
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func setShadow() {
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        let shadowOffsetWidth: Int = 1
        let shadowOffsetHeight: Int = 1
        let shadowOpacity: Float = 0.6
        self.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = shadowPath.cgPath
    }
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
    
    /// Make View Circular with passed border color
    ///
    /// - Parameter borderColor: border color of circle
    /// - Parameter borderWidth: border width of circle
    func makeCircularView(withBorderColor color: UIColor, withBorderWidth borderWidth: CGFloat = 1.0, withCustomCornerRadiusRequired cornerRadiusRequired:Bool = false, withCustomCornerRadius cornerRadius: CGFloat = 6.0) {
        self.layer.cornerRadius = cornerRadiusRequired ? cornerRadius : (self.frame.size.width / 2)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
}

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}

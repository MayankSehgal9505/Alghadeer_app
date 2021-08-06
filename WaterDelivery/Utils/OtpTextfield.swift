//
//  OtpTextfield.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 30/04/21.
//

import UIKit

class OtpTextfield: UITextField {

    weak var previousTextField: OtpTextfield?
    weak var nextTextField: OtpTextfield?
    override public func deleteBackward(){
      text = ""
      previousTextField?.becomeFirstResponder()
     }

}

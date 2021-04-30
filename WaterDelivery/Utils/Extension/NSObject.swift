//
//  NSObject.swift
//  Ratna Sagar
//
//  Created by Ratna Sagar on 14/6/19.
//  Copyright © 2019 Ratna Sagar. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    /// - Parameter hex: Hex String
    /// - Returns: The Value of UIColor
     func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
    
    /// Get class name string
    ///
    /// - Returns: name of class
    class func className() -> String {
        return String(describing: self)
    }
    
    class func accurateRound(value: Double) -> Int {
        let d : Double = value - Double(Int(value))
        if d < 0.5 {
            return Int(value)
        } else {
            return Int(value) + 1
        }
    }
    
    /// Check for vaild email
    ///
    /// - Returns: true or false
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}

extension String {
    /// Check for valid contact
    var isValidContact: Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}

// MARK: - String Extension
extension NSAttributedString {
    internal convenience init?(html: String) {
        var newhml = html
        newhml = newhml.appending(String(format: "<style>body{font-family: 'ArialMT'; font-size:17.0px;}</style>"))
        guard let data = newhml.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
        NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}

extension UIDevice {
    /// Get model name of iOS devices
    var modelName: String {
        if let modelName = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] { return modelName }
        var info = utsname()
        uname(&info)
        return String(String.UnicodeScalarView(Mirror(reflecting: info.machine).children.compactMap {
                    guard let value = $0.value as? Int8 else { return nil }
                    let unicode = UnicodeScalar(UInt8(value))
                    return unicode.isASCII ? unicode : nil
        }))
    }
}
//Class ends here

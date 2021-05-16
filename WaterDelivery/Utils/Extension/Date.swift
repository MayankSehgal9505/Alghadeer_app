//
//  Date.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 16/05/21.
//

import Foundation

extension Date {
    func convertDate(using dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return  dateFormatter.string(from: self)
    }
    func dateStringWith(strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
}

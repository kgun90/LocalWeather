//
//  Date.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/02/01.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH시"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.string(from: self)
    }
}

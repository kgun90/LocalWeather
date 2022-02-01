//
//  String.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/02/01.
//

import Foundation

extension String {
    func toDate() -> Date? { 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

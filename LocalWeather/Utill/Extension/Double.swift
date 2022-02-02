//
//  Double.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/02/02.
//

import Foundation

extension Double {
    var toC: Double {
        return self - 273.15
    }
    
    var toF: Double {
        return self * (9/5) - 459.67
    }
}

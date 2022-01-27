//
//  Int.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import UIKit

extension Int {
    var w: CGFloat {
        return UIScreen.main.bounds.width * (CGFloat(self) / 375)
    }
    var h: CGFloat {
        return Device.isNotch ? UIScreen.main.bounds.height * (CGFloat(self) / 812) : UIScreen.main.bounds.height * (CGFloat(self) / 667)
    }
}

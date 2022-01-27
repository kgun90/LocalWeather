//
//  Device.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import UIKit

struct Device {
    static var isNotch: Bool {
        return Double(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? -1) > 0
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}

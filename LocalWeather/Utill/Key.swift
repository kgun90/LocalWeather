//
//  Key.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/28.
//

import Foundation

struct Key {
    static let secret = "e47a27876b64e5c8ffcae64e68e06dae"
    static let url = "https://api.openweathermap.org"
    static let path = "/data/2.5"
    static let units = "metric"
}

enum Mode: String {
    case weather
    case forecast
}

enum Local: CaseIterable {
    case gongju
    case gwangju
    case gumi
    case gunsan
    case daegu
    case daejeon
    case mokpo
    case busan
    case seosan
    case seoul
    case sokcho
    case suwon
    case suncheon
    case ulsan
    case iksan
    case jeonju
    case jeju
    case cheonan
    case cheongju
    case chuncheon
    
    var code: Int {
        switch self {
        case .gongju:    return 1842616
        case .gwangju:   return 1841808
        case .gumi:      return 1842225
        case .gunsan:    return 1842025
        case .daegu:     return 1835327
        case .daejeon:   return 1835224
        case .mokpo:     return 1841066
        case .busan:     return 1838524
        case .seosan:    return 1835895
        case .seoul:     return 1835848
        case .sokcho:    return 1836553
        case .suwon:     return 1835553
        case .suncheon:  return 1835648
        case .ulsan:     return 1833747
        case .iksan:     return 1843491
        case .jeonju:    return 1845457
        case .jeju:      return 1846266
        case .cheonan:   return 1845759
        case .cheongju:  return 1845604
        case .chuncheon: return 1845136
        }
    }
    
    var name: String {
        switch self {
        case .gongju:    return "공주"
        case .gwangju:   return "광주(전남)"
        case .gumi:      return "구미"
        case .gunsan:    return "군산"
        case .daegu:     return "대구"
        case .daejeon:   return "대전"
        case .mokpo:     return "목포"
        case .busan:     return "부산"
        case .seosan:    return "서산"
        case .seoul:     return "서울"
        case .sokcho:    return "속초"
        case .suwon:     return "수원"
        case .suncheon:  return "순천"
        case .ulsan:     return "울산"
        case .iksan:     return "익산"
        case .jeonju:    return "전주"
        case .jeju:      return "제주시"
        case .cheonan:   return "천안"
        case .cheongju:  return "청주"
        case .chuncheon: return "춘천"
        }
    }
    
}

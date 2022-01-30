//
//  WeatherService.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/28.
//

import Foundation

class WeatherService {
    static func getWeather(city: Local, completion: @escaping (Decodable?) -> Void) {
        let path = Key.path + "/\(Route.weather.rawValue)"
        
        let query = [
            "appid": Key.secret,
            "units": Key.units,
            "lang": "kr",
            "id": "\(city.code)"
        ]
        
        NetworkService(baseUrl: Key.url).request(path, method: .get, query: query, type: WeatherResponse.self) { res in
            completion(res)
        }
    }
}

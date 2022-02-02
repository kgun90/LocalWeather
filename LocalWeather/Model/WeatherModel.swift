//
//  WeatherModel.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/28.
//

import UIKit

struct LocalWeatherModel {
    let local: Local
    let res: WeatherResponse
    let mode: TempMode
}

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let cod: Int
    let message: String
}

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let weather: [WeatherCondition]
    let main: WeatherMain
    let wind: Wind
    let coord: Coord
}

// MARK: - Weather
struct WeatherCondition: Codable {
    let id: Int
    let main, weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
    }
}

// MARK: - Main
struct WeatherMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
//    let cod: Int
    let message, cnt: Int
    let list: [ForecastItem]
}

// MARK: - ForecastItem
struct ForecastItem: Codable {
    let main: ForecastMain
    let dt: Int
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main
        case dtTxt = "dt_txt"
    }
}

// MARK: - ForecastMain
struct ForecastMain: Codable {
    let tempMin, tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}


struct WeatherImage {
    let id: Int
    
    var name: String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800 :
            return "sun.max"
        case 801...802:
            return "cloud.sun"
         case 803...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    var color: UIColor {
        switch id {
        case 200...232:
            return .gray
        case 300...531:
            return .blue
        case 600...781:
            return .gray
        case 800:
            return .orange
        case 801...802:
            return .orange
        case 803...804:
            return .gray
        default:
            return .gray
            
        }
    }
}

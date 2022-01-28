//
//  WeatherViewModel.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class WeatherViewModel: ViewModel {
    var bag = DisposeBag()
    
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        getWeather()
        return Output()
    }
    
    private func getWeather() {
        for local in Local.allCases {
            WeatherService.getWeather(city: local) { res in
                switch res {
                case is WeatherResponse:
                    let model = res as! WeatherResponse
                    Log.e("\(local.name): \(model.weather[0].weatherDescription)")
                    
                case is ErrorResponse:
                    let e = res as! ErrorResponse
                    Log.e(e.message)
                    
                default:
                    Log.e("API Request Failed")
                }
            }
        }
    }
    
}

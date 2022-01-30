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
        let local: Local
    }
    
    struct Output {
        let weather: Observable<WeatherResponse>
    }
    
    private let weather = PublishRelay<WeatherResponse>()
    
    func transform(input: Input) -> Output {
        getWeather(local: input.local)
        
      
        return Output(weather: weather.asObservable())
    }    
    
  
    private func getWeather(local: Local) {
        WeatherService.getWeather(city: local) { res in
            switch res {
            case is WeatherResponse:
                let model = res as! WeatherResponse
                
                self.weather.accept(model)
            case is ErrorResponse:
                let e = res as! ErrorResponse
                Log.e(e.message)
                
            default:
                Log.e("API Request Failed")
            }
        }
    }
    
}

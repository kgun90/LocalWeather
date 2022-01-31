//
//  ForecastViewModel.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/01/30.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ForecastViewModel: ViewModel {
    var bag = DisposeBag()
    
    struct Input {
        let local: Local
    }
    
    struct Output {
        let forecast: Observable<ForecastResponse>
    }
    
    private let forecast = PublishRelay<ForecastResponse>()
    
    func transform(input: Input) -> Output {
        getWeather(local: input.local)
      
        return Output(forecast: forecast.asObservable())
    }
  
    private func getWeather(local: Local) {
        WeatherService.getForecast(city: local) { res in
            switch res {
            case is ForecastResponse:
                let model = res as! ForecastResponse
                
                self.forecast.accept(model)
                
            case is ErrorResponse:
                let e = res as! ErrorResponse
                Log.e(e.message)
                
            default:
                Log.e("API Request Failed")
            }
        }
    }
    
}


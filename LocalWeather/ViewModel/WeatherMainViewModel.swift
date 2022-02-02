//
//  WeatherMainViewModel.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/02/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class WeatherMainViewModel: ViewModel {
    var bag = DisposeBag()
    
    struct Input {
        let mode: Observable<TempMode>
    }
    
    struct Output {
        let localWeahter: Observable<[LocalWeatherModel]>
    }
    
    private let localWeahter = PublishRelay<[LocalWeatherModel]>()
    
    func transform(input: Input) -> Output {
        input.mode.subscribe(onNext: storeWeather).disposed(by: bag)
        
        return Output(localWeahter: localWeahter.asObservable())
    }
    
    private func storeWeather(mode: TempMode) {
        var model = [LocalWeatherModel]()
        
        let group = DispatchGroup()
        
        Local.allCases.forEach { local in
            group.enter()
            getWeather(local: local) { data in
                model.append(LocalWeatherModel(local: local, res: data, mode: mode))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.localWeahter.accept(model)
        }
    }
    
    
    private func getWeather(local: Local, completion: @escaping (WeatherResponse) -> Void) {
        WeatherService.getWeather(city: local) { res in
            switch res {
            case is WeatherResponse:
                let model = res as! WeatherResponse
                
                completion(model)
            case is ErrorResponse:
                let e = res as! ErrorResponse
                Log.e(e.message)
                
            default:
                Log.e("API Request Failed")
            }
        }
    }
}

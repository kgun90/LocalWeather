//
//  ViewModel.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/28.
//

import Foundation
import RxSwift
import RxRelay

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var bag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

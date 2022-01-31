//
//  ForecastChartViewController.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastChartViewController: UIViewController {
    let bag = DisposeBag()
    let viewModel = ForecastViewModel()
    var local: Local

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "미래날씨"
        lbl.font = .systemFont(ofSize: 40, weight: .semibold)
        return lbl
    }()
    
    init(local: Local) {
        self.local = local
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        interface()
    }
    
    func setup() {
        
    }
    
    func bind() {
        let input = ForecastViewModel.Input(local: local)
        let output = viewModel.transform(input: input)
        
        output.forecast.subscribe(onNext: {
            $0.list.forEach { item in
                Log.any("Forecast Data \(item.dtTxt)")
            }
        }).disposed(by: bag)
    }
    
    func interface() {
        view.addSubview(titleLabel)
        titleLabel.setSize(width: 145, height: 50)
        titleLabel.setAnchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 100, paddingRight: 15)
    }
}

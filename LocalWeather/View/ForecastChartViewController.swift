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

    var data = [[Double]]()
    var chart: Chart
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "미래날씨"
        lbl.font = .systemFont(ofSize: 40, weight: .semibold)
        return lbl
    }()
    
    private let maxLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "최고기온"
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .red
        return lbl
    }()
    
    private let minLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "최저기온"
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .blue
        return lbl
    }()
    
    private let humidLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "습도"
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .black
        return lbl
    }()
    
    init(local: Local) {
        self.local = local
        self.chart = Chart(data: data)
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
    
    
    func bind() {
        let input = ForecastViewModel.Input(local: local)
        let output = viewModel.transform(input: input)
        
        output.forecast.subscribe(onNext: setChart).disposed(by: bag)
    }
    
    func interface() {
        view.addSubview(titleLabel)
        titleLabel.setSize(width: 145, height: 50)
        titleLabel.setAnchor(top: view.topAnchor, trailing: view.trailingAnchor, paddingTop: 100, paddingTrailing: 15)
        
        view.addSubview(chart)
        chart.setAnchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 10, paddingBottom: 100)
        
        view.addSubview(humidLabel)
        humidLabel.setAnchor(top: chart.bottomAnchor, leading: view.leadingAnchor, paddingLeading: 10)
        
        view.addSubview(maxLabel)
        maxLabel.setAnchor(top: chart.bottomAnchor, leading: humidLabel.trailingAnchor, paddingLeading: 10)
        
        view.addSubview(minLabel)
        minLabel.setAnchor(top: chart.bottomAnchor, leading: maxLabel.trailingAnchor, paddingLeading: 10)

    }
    
    func setChart(data: ForecastResponse) {
        var max = [Double]()
        var min = [Double]()
        var humid = [Double]()
        var axis = [String]()
        
        data.list.forEach { item in
            max.append(item.main.tempMax)
            min.append(item.main.tempMin)
            humid.append(Double(item.main.humidity))
            axis.append(item.dtTxt)
        }
        let date = axis.map { $0.toDate() }
        var xAxis = [String]()
        
        for i in 0 ..< axis.count {
            if i % 5 == 0 {
               let data = date[i].map { $0.toString() }
                xAxis.append(data!)
            } else {
                let data = date[i].map { $0.toString() }
                xAxis.append(data?.components(separatedBy: " ")[1] ?? "")
            }
        }
        
        self.data = [min, max, humid]
        
        DispatchQueue.main.async {
            self.chart.setData(data: self.data, xAxis: xAxis)
            self.chart.setLineColors(colors: [.blue, .red, .black])
        }
    }
}

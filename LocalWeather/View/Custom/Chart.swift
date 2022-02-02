//
//  Chart.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/02/01.
//

import UIKit


class Chart: UIView {
    init(data: [[Double]], max: Double? = nil, min: Double? = nil, xAxis: [String] = [], yAxisDivideCount divider: Int = 10) {
        self.chartView = ChartView(data: data, max: max, min: min, xAxis: xAxis, yAxisDivideCount: divider)
        
        var yAxis: [Double] = []
        for i in 0 ..< divider {
            yAxis.append((chartView.max - chartView.min) / Double(divider - 1) * Double(i))
        }
        
        let yAxisLabels: [UILabel] = yAxis.reversed().map {
            let label = UILabel()
            label.text = String(Int($0))
            label.font = label.font.withSize(12)
            return label
        }
        
        self.yAxis = UIStackView(arrangedSubviews: yAxisLabels)
        
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let chartView: ChartView
    let yAxis: UIStackView
    
    func setData(data: [[Double]], xAxis: [String]) {
        let divider = chartView.yAxisDivideCount
        let maxOfData = data.map { $0.max() ?? 0 }.max() ?? 0
        let minOfData = data.map { $0.min() ?? 0 }.min() ?? 0
        
        let max = chartView.max > maxOfData ? chartView.max : maxOfData
        let min = chartView.min < minOfData ? chartView.min : minOfData
        
        var yAxis: [Double] = []
        for i in 0 ..< divider {
            yAxis.append((max - min) / Double(divider - 1) * Double(i))
        }
        
        let yAxisLabels: [UILabel] = yAxis.reversed().map {
            let label = UILabel()
            label.text = String(Int($0))
            label.font = label.font.withSize(12)
            return label
        }
        
        self.yAxis.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        yAxisLabels.forEach {
            self.yAxis.addArrangedSubview($0)
        }
        
        chartView.setData(data: data, max: max, min: min, inputXAxis: xAxis)
    }
    
    func setLineColor(to index: Int, color: UIColor) {
        chartView.setLineColor(to: index, color: color)
    }
    
    func setLineColors(colors: [UIColor]) {
        chartView.setLineColors(colors: colors)
    }
    
    private func setView() {
        self.addSubview(chartView)
        self.addSubview(yAxis)
        
        setYAxis()
        setChartView()
    }
    
    func rotate() {
        chartView.draw(.zero)
    }
    
    private func setChartView() {
        chartView.setAnchor(top: self.topAnchor, leading: yAxis.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    
    private func setYAxis() {
        yAxis.axis = .vertical
        yAxis.distribution = .equalSpacing
        
        yAxis.setAnchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor)
    }
}

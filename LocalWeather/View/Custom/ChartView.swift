//
//  ChartView.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/02/01.
//

import UIKit


class ChartView: UIScrollView {
    init(data: [[Double]], max: Double?, min: Double?, xAxis inputXAxis: [String], yAxisDivideCount: Int) {
        self.data = data
        self.max = max ?? data.map { $0.max() ?? 0 }.max() ?? 0
        self.min = min ?? data.map { $0.min() ?? 0 }.min() ?? 0
        self.maxCount = data.map { $0.count }.max() ?? 0
        self.colors = Array(repeating: .black, count: data.count)
        self.yAxisDivideCount = yAxisDivideCount
        self.inputXAxis = inputXAxis
        
        var xAxis: [String] = []
        for i in 0 ..< maxCount {
            xAxis.append(inputXAxis.count < i + 1 ? String(i) : inputXAxis[i])
        }
        
        let xAxisLabels: [UILabel] = xAxis.map {
            let label = UILabel()
            label.text = $0
            label.font = label.font.withSize(12)
            return label
        }
        
        self.xAxis = UIStackView(arrangedSubviews: xAxisLabels)
        
        super.init(frame: .zero)
        
//        self.setData(data: data, max: max, min: min)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoomChart(_:)))
        addGestureRecognizer(pinchGestureRecognizer)
        
        self.addSubview(contentView)
        self.setXAxis()
        
        for _ in 0 ..< data.count {
            let layer = CALayer()
            chartLayer.append(layer)
            
            contentView.layer.addSublayer(layer)
        }
        
        contentView.layer.addSublayer(yAxisLayer)
        contentView.layer.addSublayer(xAxisLayer)
    }
    
    override func draw(_ rect: CGRect) {
        contentView.frame.size.height = self.frame.height
        
        // 초기 width 세팅: 전체 차트가 다 보이도록 한다.
        self.hRatio = 1 / ((max - min) / (self.frame.size.height - xAxis.frame.size.height))
        
        self.minScale = self.frame.width / Double(maxCount - 1)
        self.scale = minScale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: [[Double]]
    var max: Double
    var min: Double
    
    private var maxCount: Int
    let yAxisDivideCount: Int
    private var yAxisLayer = CALayer() {
        willSet(newValue) {
            if contentView.layer.sublayers?.contains(yAxisLayer) == true {
                contentView.layer.replaceSublayer(yAxisLayer, with: newValue)
            }
        }
    }
    private var xAxisLayer = CALayer() {
        willSet(newValue) {
            if contentView.layer.sublayers?.contains(xAxisLayer) == true {
                contentView.layer.replaceSublayer(xAxisLayer, with: newValue)
            }
        }
    }
    
    private var hRatio: Double = 0
    private var colors: [UIColor]
    
    private var scale: Double = 150 {
        didSet {
            refreshLine()
        }
    }
    private var minScale: Double = 150
    
    private let contentView = UIView()
    private var chartLayer: [CALayer] = []
    
    private var inputXAxis: [String]
    private var xAxis: UIStackView
    
    func setData(data: [[Double]], max: Double, min: Double, inputXAxis: [String]) {
        self.data = data
        self.max = max
        self.min = min
        
        self.maxCount = data.map { $0.count }.max() ?? 0
        self.colors = Array(repeating: .black, count: data.count)
        Log.any("axis\(self.inputXAxis)")
        
        var xAxis: [String] = []

        for i in 0 ..< maxCount {
            xAxis.append(self.inputXAxis.count < i + 1 ? String(i) : self.inputXAxis[i])
        }

        let xAxisLabels: [UILabel] = inputXAxis.map {
            let label = UILabel()
            label.text = $0
            label.font = label.font.withSize(12)
            
            return label
        }
        
        self.xAxis.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        xAxisLabels.forEach {
            self.xAxis.addArrangedSubview($0)
        }
        
        for _ in 0 ..< data.count {
            let layer = CALayer()
            chartLayer.append(layer)
            contentView.layer.addSublayer(layer)
        }
    }
    
    func setLineColor(to index: Int, color: UIColor) {
        colors[index] = color
    }
    
    func setLineColors(colors: [UIColor]) {
        self.colors = colors
    }
    
    private func setXAxis() {
        self.addSubview(xAxis)
        
        xAxis.axis = .horizontal
        xAxis.distribution = .fillEqually
        
        xAxis.setAnchor(bottom: contentView.bottomAnchor)
        xAxis.setWidth(width: contentView.widthAnchor)
    }
    
    private func refreshLine() {
        for i in 0 ..< data.count {
            drawLines(i)
        }
        
        drawYAxisGuideLine(lineCount: yAxisDivideCount)
        drawXAxisGuideLine()
    }
    
    private func drawYAxisGuideLine(lineCount: Int) {
        let path = UIBezierPath()
        
        for i in 0 ..< lineCount {
            let y = (max - min) / Double(lineCount - 1) * Double(i) * hRatio
            
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: Double(maxCount - 1) * scale, y: y))
        }
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.lightGray.cgColor
        
        self.yAxisLayer = shape
    }
    
    private func drawXAxisGuideLine() {
        let path = UIBezierPath()
        
        for i in 0 ..< maxCount {
            let x = Double(i) * scale
            
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: (max + (min < 0 ? -min : 0)) * hRatio))
        }
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.lightGray.cgColor
        
        self.xAxisLayer = shape
    }
    
    private func drawLines(_ index: Int) {
        let count = data[index].count
        let chartData = data[index]
        
        self.contentSize.width = CGFloat((count - 1)) * scale

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: (max - (chartData.first ?? max)) * hRatio))
        
        for i in 0 ..< count {
            path.addLine(to: CGPoint(x: Double(i) * scale, y: (max - chartData[i]) * hRatio))
        }
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = colors[index].cgColor
        
        contentView.layer.replaceSublayer(chartLayer[index], with: shape)
        self.chartLayer[index] = shape
        
        contentView.frame.size.width = self.contentSize.width
    }
    
    @objc
    private func zoomChart(_ pinch: UIPinchGestureRecognizer) {
        guard scale >= minScale else {
            scale = minScale
            return
        }
        
        scale *= pinch.scale
        pinch.scale = 1
    }
}


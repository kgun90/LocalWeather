//
//  DetailWeatherViewController.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class DetailWeatherViewController: UIViewController {
    let bag = DisposeBag()
    let local: Local
    let viewModel = WeatherViewModel()
    
    
    private lazy var localLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = local.name
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 60, weight: .semibold)
        return lbl
    }()
    
    lazy var currentTempLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    lazy var feelTempLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 30, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var weatherImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var forecastButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("미래날씨 >", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    lazy var maxTempLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    lazy var minTempLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    lazy var humidLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    lazy var pressureLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    lazy var speedLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
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
    
    func bind() {
        let input = WeatherViewModel.Input(local: local)
        let output = viewModel.transform(input: input)
        
        output.weather.subscribe(onNext: { data in
            DispatchQueue.main.async {
                self.currentTempLable.text = String(format: "현재기온: %.1f℃", data.main.temp.toC)
                self.feelTempLable.text = String(format: "체감기온: %.1f℃", data.main.feelsLike.toC)
                self.descriptionLabel.text = data.weather[0].weatherDescription
                
                self.weatherImage.image = UIImage(systemName: WeatherImage(id: data.weather[0].id).name)
                self.weatherImage.tintColor = WeatherImage(id: data.weather[0].id).color
                
                self.maxTempLable.text = String(format: "최고: %.1f℃", data.main.tempMax.toC)
                self.minTempLable.text = String(format: "최저: %.1f℃", data.main.tempMin.toC)
                self.humidLable.text = "습도: \(data.main.humidity)%"
                
                self.pressureLable.text = "기압: \(data.main.pressure)hPa"
                self.speedLable.text = "풍속: \(data.wind.speed)m/s"
                
            }
        }).disposed(by: bag)
        forecastButton.rx.tap.subscribe(onNext: moveToForecast).disposed(by: bag)
    }
    
    func moveToForecast() {
        let vc = ForecastChartViewController(local: local)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func interface() {        
        view.addSubview(localLabel)
        localLabel.setSize(width: 375, height: 70)
        localLabel.setCenterX(from: view)
        localLabel.setAnchor(top: view.topAnchor, paddingTop: 173)
        
        view.addSubview(currentTempLable)
        currentTempLable.setSize(height: 25)
        currentTempLable.setAnchor(top: localLabel.bottomAnchor, trailing: view.centerXAnchor, paddingTrailing: 5)
        
        view.addSubview(feelTempLable)
        feelTempLable.setSize(height: 25)
        feelTempLable.setAnchor(top: localLabel.bottomAnchor, leading: view.centerXAnchor, paddingLeading: 5)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.setSize(width: 375, height: 60)
        descriptionLabel.setCenterX(from: view)
        descriptionLabel.setAnchor(top: currentTempLable.bottomAnchor)
        
        view.addSubview(weatherImage)
        weatherImage.setSize(width: 155, height: 155)
        weatherImage.setCenter(from: view)
        
        view.addSubview(minTempLable)
        minTempLable.setSize(height: 30)
        minTempLable.setCenterX(from: view)
        minTempLable.setAnchor(top: weatherImage.bottomAnchor, paddingTop: 40)
        
        view.addSubview(maxTempLable)
        maxTempLable.setSize(height: 30)
        maxTempLable.setCenterY(from: minTempLable)
        maxTempLable.setAnchor(trailing: minTempLable.leadingAnchor, paddingTrailing: 5)
        
        view.addSubview(humidLable)
        humidLable.setSize(height: 30)
        humidLable.setCenterY(from: minTempLable)
        humidLable.setAnchor(leading: minTempLable.trailingAnchor, paddingLeading: 5)
        
        view.addSubview(forecastButton)
        forecastButton.setSize(height: 25)
        forecastButton.setAnchor(bottom: humidLable.topAnchor, trailing: humidLable.trailingAnchor, paddingBottom: 3)
        
        view.addSubview(pressureLable)
        pressureLable.setSize(height: 30)
        pressureLable.setAnchor(top: minTempLable.bottomAnchor, trailing: view.centerXAnchor, paddingTrailing: 5)
        
        view.addSubview(speedLable)
        speedLable.setSize(height: 30)
        speedLable.setAnchor(top: minTempLable.bottomAnchor, leading: view.centerXAnchor, paddingLeading: 5)
    }
}

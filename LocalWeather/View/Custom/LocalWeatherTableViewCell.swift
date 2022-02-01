//
//  LocalWeatherTableViewCell.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/01/29.
//

import UIKit
import RxSwift

class LocalWeatherTableViewCell: UITableViewCell {
    let bag = DisposeBag()
    let viewModel = WeatherViewModel()
    
    var local: Local? {
        didSet { setData() }
    }
    
    lazy var cellBackground: UIView = {
        let view = UIView()
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15.h
        return view
    }()
    
    lazy var localLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 25, weight: .semibold)
        lbl.textColor = .black
        
       return lbl
    }()
       
    lazy var weatherImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var tempImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "thermometer")
        iv.tintColor = .lightGray
        return iv
    }()
    
    lazy var tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 25, weight: .regular)
        lbl.textColor = .black
        lbl.textAlignment = .right
       return lbl
    }()
    
    lazy var humidImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "humidity")
        iv.tintColor = .lightGray
        return iv
    }()
    
    lazy var humidLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 25, weight: .regular)
        lbl.textColor = .black
        
       return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        interface()
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
        
    private func setData() {
        guard let local = local else { return }
        
        let input = WeatherViewModel.Input(local: local)
        let output = viewModel.transform(input: input)
        
        output.weather.subscribe(onNext: { data in
            DispatchQueue.main.async {
                self.tempLabel.text = String(format: "%.1f℃", data.main.temp)
                self.humidLabel.text = "\(data.main.humidity)%"
                
                self.weatherImage.image = UIImage(systemName: WeatherImage(id: data.weather[0].id).name)
                self.weatherImage.tintColor = WeatherImage(id: data.weather[0].id).color
            }
        }).disposed(by: bag)
        
        localLabel.text = local.name
    }   
    
    
    private func interface() {
        contentView.addSubview(cellBackground)
        cellBackground.setSize(width: 337, height: 80)
        cellBackground.setAnchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, paddingBottom: 5)
        cellBackground.setCenterX(from: contentView)
        
        
        cellBackground.addSubview(localLabel)
        localLabel.setSize(height: 25)
        localLabel.setCenterY(from: cellBackground)
        localLabel.setAnchor(leading: cellBackground.leadingAnchor, paddingLeading: 20)
        
        cellBackground.addSubview(weatherImage)
        weatherImage.setSize(width: 50, height: 50)
        weatherImage.setCenterY(from: cellBackground)
        weatherImage.setAnchor(trailing: cellBackground.trailingAnchor, paddingTrailing: 20)
        
        
        cellBackground.addSubview(tempLabel)
        tempLabel.setAnchor(bottom: cellBackground.centerYAnchor, trailing: weatherImage.leadingAnchor)
        tempLabel.setSize(height: 25)
        
        cellBackground.addSubview(humidLabel)
        humidLabel.setSize(height: 20)
        humidLabel.setAnchor(top: cellBackground.centerYAnchor, trailing: weatherImage.leadingAnchor)
        
        cellBackground.addSubview(humidImage)
        humidImage.setSize(width: 16, height: 16)
        humidImage.setCenterY(from: humidLabel)
        humidImage.setAnchor(trailing: humidLabel.leadingAnchor, paddingTrailing: 3)
        
       
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

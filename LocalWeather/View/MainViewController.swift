//
//  ViewController.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    let viewModel = WeatherViewModel()
    let bag = DisposeBag()
    let weatherCell = "LocalWeatherTableViewCell"
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "지역날씨"
        lbl.font = .systemFont(ofSize: 40, weight: .semibold)
        return lbl
    }()
    
    lazy var weatherTableView: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.tableFooterView = UIView()
        tbl.showsVerticalScrollIndicator = false
        tbl.separatorStyle = .none
        tbl.register(LocalWeatherTableViewCell.self, forCellReuseIdentifier: weatherCell)
        return tbl
    }()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        interface()
    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func bind() {    
        localArray().bind(to: weatherTableView.rx.items(cellIdentifier: weatherCell, cellType: LocalWeatherTableViewCell.self)) {
            (index, element, cell) in
            cell.local = element
        }.disposed(by: bag)
    }

    func localArray() -> Observable<[Local]> {
        var arr = [Local]()
        Local.allCases.forEach {
            arr.append($0)
        }
        return Observable.just(arr)
    }
    
    func interface() {
        view.addSubview(titleLabel)
        titleLabel.setSize(width: 145, height: 50)
        
        titleLabel.setAnchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 100, paddingRight: 15)
        view.addSubview(weatherTableView)
        weatherTableView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 177.h)
        weatherTableView.setCenterX(from: view)
    }
}


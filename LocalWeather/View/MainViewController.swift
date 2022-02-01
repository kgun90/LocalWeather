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
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "지역날씨"
        lbl.font = .systemFont(ofSize: 40, weight: .semibold)
        return lbl
    }()
    
    private lazy var weatherTableView: UITableView = {
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
        
        weatherTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.weatherTableView.cellForRow(at: indexPath) as? LocalWeatherTableViewCell
                self?.moveToDetailWeather(cell?.local)
            }).disposed(by: bag)
    }

    func localArray() -> Observable<[Local]> {
        var arr = [Local]()
        Local.allCases.forEach {
            arr.append($0)
        }
        return Observable.just(arr)
    }
    
    func moveToDetailWeather(_ local: Local?) {
        guard let local = local else { return }
        let vc = DetailWeatherViewController(local: local)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func interface() {
        view.addSubview(titleLabel)
        titleLabel.setSize(width: 145, height: 50)
        titleLabel.setAnchor(top: view.topAnchor, trailing: view.trailingAnchor, paddingTop: 100, paddingTrailing: 15)
        
        view.addSubview(weatherTableView)
        weatherTableView.setAnchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 177.h)
        weatherTableView.setCenterX(from: view)
    }
}


//
//  ViewController.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class MainViewController: UIViewController {
    
    let bag = DisposeBag()
    let weatherCell = "LocalWeatherTableViewCell"
    
    let viewModel = WeatherMainViewModel()
    
    let mode = BehaviorRelay<TempMode>(value: .cel)
    
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
      
    lazy var tempConvertButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("℃/℉", for: .normal)
        btn.backgroundColor = .blue
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        return btn
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
        let input = WeatherMainViewModel.Input(mode: mode.asObservable())
        let output = viewModel.transform(input: input)
        
        output.localWeahter.bind(to: weatherTableView.rx.items(cellIdentifier: weatherCell, cellType: LocalWeatherTableViewCell.self)) {
            (index, element, cell) in
            cell.data = element
        }.disposed(by: bag)
        
        weatherTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.weatherTableView.cellForRow(at: indexPath) as? LocalWeatherTableViewCell
                self?.moveToDetailWeather(cell?.data?.local)
            }).disposed(by: bag)
        
        tempConvertButton.rx.tap.subscribe(onNext: modeChange).disposed(by: bag)
    }
    
    func modeChange() {
        var mode: TempMode = .cel
        
        self.mode.subscribe(onNext: {
            mode = $0 == .cel ? .fah : .cel
        }).disposed(by: bag)
        self.mode.accept(mode)
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
        
        view.addSubview(tempConvertButton)
        tempConvertButton.setSize(width: 50, height: 30)
        tempConvertButton.setAnchor(leading: view.leadingAnchor, bottom: weatherTableView.topAnchor, paddingLeading: 20, paddingBottom: 10)
    }
}


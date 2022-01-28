//
//  ViewController.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import UIKit

class MainViewController: UIViewController {
    let viewModel = WeatherViewModel()
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "weather"
        lbl.backgroundColor = .green
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.left")
        iv.tintColor = .red
        iv.backgroundColor = .yellow
        return iv
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
        let input = WeatherViewModel.Input()
        let output = viewModel.transform(input: input)
        
    }

    func interface() {
        view.addSubview(label)
        label.setSize(height: 50, width: 90)
        label.setCenter(from: view)
        
        view.addSubview(image)
        image.setAnchor(top: label.bottomAnchor, paddingTop: 50.h)
        image.centerX(from: label)
        image.setSize(height: 50, width: 50)
    }
}


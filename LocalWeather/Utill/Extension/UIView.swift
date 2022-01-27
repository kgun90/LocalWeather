//
//  UIView.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import UIKit

//enum

extension UIView {
//        MARK: - 각 Anchor로 부터 Constraints 지정
    func setAnchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
    }
//        MARK: - 인자를 받은 View대한 Center Constraints
    func setCenter(from view: UIView, paddingX: Int = 0, paddingY: Int = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: paddingX.w).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: paddingY.w).isActive = true
    }
    
    func centerX(from view: UIView, padding: Int = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: padding.w).isActive = true
    }
    
    func centerY(from view: UIView, padding: Int = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: padding.h).isActive = true
    }
    
//        MARK: - View의 Size 지정
    func setSize(height: Int? = nil, width: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width.w).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height.h).isActive = true
        }
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}

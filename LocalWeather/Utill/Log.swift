//
//  Log.swift
//  LocalWeather
//
//  Created by Geon Kang on 2022/01/29.
//

import Foundation

public class Log{
    static func e(_ message: String, file: String = #file, line: Int = #line) {
        let file = (file as NSString).lastPathComponent
        
        print("\(Date()) : \(message) (at \(file):\(line))")
    }
    
    static func any(_ message: Any, file: String = #file, line: Int = #line) {
        let file = (file as NSString).lastPathComponent
        
        print("\(Date()) : \(message) (at \(file):\(line))")
    }
}

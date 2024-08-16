//
//  api_config.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-15.
//

import Foundation

struct apiConfig{
    static private let ip = "http://13.125.169.165"
    static private let port = "8000"
    static private let api_name = "api_main"
    
    static func getConfig() -> String{
        return "\(ip):\(port)/\(api_name)"
    }
}

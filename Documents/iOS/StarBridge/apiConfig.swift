//
//  api_config.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-15.
//

import Foundation

struct apiConfig{
    private let ip = "http://13.125.169.165"
    private let port = "8000"
    private let api_name = "api_main"
    
    func getConfig() -> String{
        return "\(ip):\(port)/\(api_name)"
    }
}

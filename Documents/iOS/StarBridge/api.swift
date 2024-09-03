//
//  api.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-19.
//

import SwiftUI
import UIKit


class Api{
    @MainActor
    @discardableResult
    func fetchData(for date: String, url urlString: String) async -> [String: [SnsData]]? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: urlString) as? String else {
            fatalError("Invalid API key.")
        }
        
        guard let url = URL(string: apiKey) else {
            fatalError("Invalid URL.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["date": date]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([String: [SnsData]].self, from: data)
//                print("Successed to receive valid response: \(date)")
                return decodedData
            } else {
//                print("Failed to receive valid response: \(date)")
                return await fetchData(for: date, url: urlString)
            }
            
        } catch {
//            print("Failed to load data: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: ["id": "\(쿼리에 넣을 id)"], ["startDate": "\(시작 날짜)", "endDate": "\(끝 날짜)"] 날짜형식: yyyy-MM-dd
    @MainActor
    @discardableResult
    func fetchData(for param: [String: String]) async -> [String: BBoardData]? {     //  게시판 데이터 받아옴
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_BBOARDF_URL") as? String else {
            fatalError("Invalid API key.")
        }
        
        guard let url = URL(string: apiKey) else {
            fatalError("Invalid URL.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["param": param]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
  
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([String: BBoardData].self, from: data)
//                print("Successed to receive valid response: \(param)")
                return decodedData
            } else {
//                print("Failed to receive valid response: \(param)")
                return await fetchData(for: param)
//                return nil
            }
            
        } catch {
//            print("Failed to load data: \(error.localizedDescription)")
            return nil
        }
    }
    
    @MainActor
    @discardableResult
    func fetchImage(for file: String) async -> UIImage? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_IMAGE_URL") as? String else {
            fatalError("Invalid API key.")
        }
    
        guard let url = URL(string: apiKey) else {
            fatalError("Invalid URL.")
        }

        let parameters: [String: String] = ["filename": file]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            fatalError("Invalid JSON parameters.")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
//            print("Successed to receive image: \(file)")
            return UIImage(data: data)
        } catch {
//            print("Failed to receive image \(file): \(error)")
            return nil
        }
    }
    
    func loadImage(from base64String: String) -> UIImage?{
        guard let imageData = Data(base64Encoded: base64String) else {
//            print("Failed to decode base64 string.")
            return nil
        }
        return UIImage(data: imageData)
    }
    
    struct SnsData: Codable, Hashable {    // 절대 바꾸지 말것
        let sns: String?
        let kind: String?
        let title: String?
        let detail: String?
        let artist: String?
        let id: String?
        let event_date: String?
        let post_date: String?
        let url: String?
        let photos: [String]?
    }
    
    struct BBoardData: Codable, Hashable {
        let id: String?
        let title: String?
        let content: String?
        let post_date: String?
        let artist: String?
        let nickname: String?
        let likes: String?
    }
    
    struct ArtistData: Codable, Hashable {    // 계획중
        let name: String?       //  그룹명
        let member: [String]?   //  멤버
        let debutData: Date?    //  데뷔날짜
        let fandomName: String? //  팬덤명
        let profileImage: String?   //  대표 사진
    }
}

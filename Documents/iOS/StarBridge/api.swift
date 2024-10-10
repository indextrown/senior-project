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
    func fetchData(for param: [String: String]) async -> [String: [apiData]]? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_ULTI_URL") as? String else {
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
                if param["Content"] == "x" || param["Content"] == "insta" {
                    let decodedData = try decoder.decode([String: [SnsData]].self, from: data)
                    let newData = decodedData.mapValues { values in
                        values.map { value in
                            apiData(artistData: nil, bboardData: nil, cafeData: nil, snsData: value, sqlData: nil, imageData: nil)
                        }
                    }
                    return newData
                }
                else if param["Content"] == "bboard" {
                    if param["write"] != nil || param["delete"] != nil {
                        let decodedData = try decoder.decode([String: SqlData].self, from: data)
                        let newData = decodedData.mapValues { value in
                            [apiData(artistData: nil, bboardData: nil, cafeData: nil, snsData: nil, sqlData: value, imageData: nil)]
                        }
                        return newData
                    }
                    else {
                        let decodedData = try decoder.decode([String: BBoardData].self, from: data)
                        let newData = decodedData.mapValues { value in
                            [apiData(artistData: nil, bboardData: value, cafeData: nil, snsData: nil, sqlData: nil, imageData: nil)]
                        }
                        return newData
                    }
                }
                else if param["Content"] == "cafe" {
                    let decodedData = try decoder.decode([String: [CafeData]].self, from: data)
                    let newData = decodedData.mapValues { values in
                        values.map { value in
                            apiData(artistData: nil, bboardData: nil, cafeData: value, snsData: nil, sqlData: nil, imageData: nil)
                        }
                    }
                    return newData
                }
                else if param["Content"] == "image" {
                    let decodedData = try decoder.decode([String: ImageData].self, from: data)
                    let newData = decodedData.mapValues { value in
                        [apiData(artistData: nil, bboardData: nil, cafeData: nil, snsData: nil, sqlData: nil, imageData: value)]
                    }
                    return newData
                }
                
                return nil
//                print("Successed to receive valid response: \(param)")
            } else {
//                print("Failed to receive valid response: \(param)")
                return nil
            }
            
        } catch {
//            print("Failed to load data: \(error.localizedDescription)")
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
    
    struct ArtistData: Codable, Hashable {    // 계획중
        let name: String?       //  그룹명
        let member: [String]?   //  멤버
        let debutData: Date?    //  데뷔날짜
        let fandomName: String? //  팬덤명
        let profileImage: String?   //  대표 사진
    }
    
    struct BBoardData: Codable, Hashable {
        let nickname: String?
        let title: String?
        let content: String?
        let post_date: String?
        let artist: String?
        let likes: String?
        let view: String?
    }
    
    struct CafeData: Codable, Hashable {
        let num: Int?
        let celebrity: String?
        let uploader: String?
        let start_date: String?
        let end_date: String?
        let place: String?
        let post_url: String?
        let address: String?
    }
    
    struct SnsData: Codable, Hashable {
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
    
    struct SqlData: Codable, Hashable {
        let result: Bool?
    }
    
    struct ImageData: Codable, Hashable {
        let imageData: String?
    }
    
    struct apiData: Codable, Hashable {
        let artistData: ArtistData?
        let bboardData: BBoardData?
        let cafeData: CafeData?
        let snsData: SnsData?
        let sqlData: SqlData?
        let imageData: ImageData?
    }

}

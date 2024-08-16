//
//  api_main.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-15.
//

import Foundation
import UIKit

struct ResponseData: Codable, Hashable {    // 절대 바꾸지 말것
    let kind: String?
    let title: String?
    let detail: String?
    let singer: String?
    let x_id: String?
    let event_date: String?
    let post_date: String?
    let url: String?
    let photos: [String]?
}

struct apiMain{
    func getData(for date: String) -> [ResponseData]?{
       guard let url = URL(string: "http://13.125.169.165:8000/api_main") else {
           print("Wrong URL")
           return nil
       }
        var parsedData: [String: ResponseData] = [:]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["date": date]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let data = data {
                do {
                    // JSON 데이터를 모델로 디코딩
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([String: ResponseData].self, from: data)
                    
                    DispatchQueue.main.async {
                        parsedData = decodedData
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
            }
            else{
                print("Unable to get data")
            }
        }
        .resume()
        
        var pdValues = Array(parsedData.values)
        let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd"
        
        pdValues.sort { first, second in    //받은 데이터는 데이터는 정렬이 안되어있어서 우선 event_date 오름차순으로 정렬
            guard
                let firstDateString = first.event_date,
                let secondDateString = second.event_date,
                let firstDate = df.date(from: firstDateString),
                let secondDate = df.date(from: secondDateString)
            else {
                return false
            }
            return firstDate < secondDate
        }

        
        return pdValues
    }
    
    func loadImage(from base64String: String) -> UIImage?{
        guard let imageData = Data(base64Encoded: base64String) else {
            print("Failed to decode base64 string.")
            return nil
        }
        return UIImage(data: imageData)
    }
}

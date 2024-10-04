//
//  GlobalVariants.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-20.
//

import Foundation
import FirebaseFirestore

// --- 기준이 되는 디바이스에 대한 비율
let ratio = iPhonePointRes.stdRatio()
// --- api 객체 ---
let api = Api()

// --- FireBase에서 특정 키워드로 정보를 가져오는 함수 ---
func fetchArrayFromFirestore(forKey key: String) async throws -> [String] {
    let kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId")
    
    if kakaoUserId == nil {
        return [String]()
    }

    let db = Firestore.firestore()
    let docRef = db.collection("user").document(kakaoUserId!)

    return try await withCheckedThrowingContinuation { continuation in
        docRef.getDocument { document, error in
            if let error = error {
                continuation.resume(throwing: error)
                return
            }

            guard let document = document, document.exists else {
                continuation.resume(returning: [])
                return
            }

            let data = document.data()
            
            // key에 해당하는 값을 먼저 배열로 시도하고, 배열이 아니면 문자열로 시도
            if let array = data?[key] as? [String] {
                continuation.resume(returning: array)
            } else if let stringValue = data?[key] as? String {
                // 문자열일 경우, 문자열을 배열에 담아 반환
                continuation.resume(returning: [stringValue])
            } else {
                // 값이 없거나 다른 타입일 경우 빈 배열 반환
                continuation.resume(returning: [])
            }
        }
    }
}

// --- FireBase에 특정 키워드의 값을 설정하는 함수 ---
func saveArrayToFirestore(key: String, array: [String]) async -> Bool {
    let db = Firestore.firestore()
    
    let kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId")
    
    if kakaoUserId == nil {
        return false
    }
    // document에는 실제로 uid가 들어감
     let docRef = db.collection("user").document(kakaoUserId!)
//    let docRef = db.collection("user").document("3700121588")
    do {
        try await docRef.setData([key: array], merge: true)
        return true // 저장 성공 시 true 반환
    } catch {
        print("데이터 저장 실패: \(error)")
        return false // 저장 실패 시 false 반환
    }
}

// --- FireBase에 특정 키워드의 값을 설정하는 함수 ---
func saveStringToFirestore(key: String, value: String) async -> Bool {
    let db = Firestore.firestore()
    
    let kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId")
    
    if kakaoUserId == nil {
        return false
    }
    
    let docRef = db.collection("user").document(kakaoUserId!)
    do {
        try await docRef.setData([key: value], merge: true)
        return true // 저장 성공 시 true 반환
    } catch {
        print("데이터 저장 실패: \(error)")
        return false // 저장 실패 시 false 반환
    }
}

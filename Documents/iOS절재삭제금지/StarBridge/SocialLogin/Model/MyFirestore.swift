//
//  MyFirestore.swift
//  StarBridge
//
//  Created by 김동현 on 9/4/24.
//

import FirebaseFirestore


// MARK: - Firestore와의 상호작용 예시
final class MyFirestore {
    // MARK: - Singleton
    static let shared = MyFirestore()
    
    private let db = Firestore.firestore()
    
    // MARK: - Singleton
    private init() {}
    
    // 사용자 정보 가져오기
    func getUser(uid: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        db.collection("user").document(uid).getDocument { document, error in
            completion(document, error)
        }
    }
    
    // 사용자 정보 업로드
    func saveProfile(uid: String, nickname: String, birthDate: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "uid": uid,
            "nickname": nickname,
            "birthDate": birthDate,
            "registerDate": Timestamp(date: Date()) // Firestore에서 사용하는 Timestamp 형식
        ]
        
        db.collection("user").document(uid).setData(data, merge: true, completion: completion)
    }

    
    func saveUser(uid: String, email: String?, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "uid": uid,
            "email": email ?? "No email provided"
        ]
        
        db.collection("user").document(uid).setData(data, merge: true, completion: completion)
    }
}




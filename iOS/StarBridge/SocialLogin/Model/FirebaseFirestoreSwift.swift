//
//  FirebaseFirestoreSwift.swift
//  StarBridge
//
//  Created by 김동현 on 9/4/24.
//

import FirebaseFirestore


// MARK: - Encodable 프로토콜을 준수하는 객체를 [String: Any] 딕셔너리로 변환
// MARK: -  Firebase Firestore와 같은 서비스에 데이터를 저장할 때 유용
extension Encodable {
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictionary
    }
}

// MARK: - Json과 상호작용 / Firestore와 상호작용하는 Message 구조체
struct Message: Codable {
    let uid: String
    let nickname: String
    let birthDate: Date
    let registerDate: Date
    
    init(uid: String, nickname: String, birthDate: Date, registerDate: Date) {
        self.uid = uid
        self.nickname = nickname
        self.birthDate = birthDate
        self.registerDate = Date()
    }
    
    // MARK: - JSON의 키와 Swift 속성 간의 매핑을 정의
    private enum CodingKeys: String, CodingKey {
        case uid          // 소셜로그인 고유값
        case nickname     // 닉네임
        case birthDate    // 생일
        case registerDate // 가입날짜
    }
    
    // MARK: - Decoding: JSON 데이터를 Message 객체로 변환하는 로직
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid =  try values.decode(String.self, forKey: .uid)
        nickname =  try values.decode(String.self, forKey: .nickname)
        birthDate =  try values.decode(Date.self, forKey: .birthDate)
        let dateDouble = try values.decode(Double.self, forKey: .registerDate)
        registerDate = Date(timeIntervalSince1970: dateDouble) // Double을 Date로 변환
    }
        
    // MARK: - Encoding: JSON 인코딩 (Firestore에 저장할 때 Unix Timestamp로 변환)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(registerDate.timeIntervalSince1970, forKey: .registerDate)
    }
}



// MARK: - Comparable 프로토콜 구현 (비교 및 정렬 기능)
extension Message: Comparable {
    // nickname을 비교
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.nickname == rhs.nickname
    }
    
    // 생일 비교 -> sort 함수에서 사용
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.birthDate < rhs.birthDate
    }
}


//
//  ProfileView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    // MARK: -
    @State private var kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId")
    @State private var resultArray: [String] = []
    
    @StateObject private var kakaoAuthVM = KakaoAuthVM.shared
    var body: some View {
        GeometryReader{ geometry in
            ScrollView{
                VStack{
                    Text("This is ProfileView")
                        .foregroundColor(.black)
                    // 홈 화면에 추가할 내용은 여기서 구현
                    Button {
                        Task {
                            await kakaoAuthVM.handleKakaoLogout()
                        }
                    } label: {
                        Text("back")
                            .foregroundStyle(.black)
                            .padding()
                            .background(.blue)
                            .cornerRadius(13)
                    }
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("설정")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            Task {
                do {
                    let array = try await fetchArrayFromFirestore(forKey: "keyword")
                    resultArray = array
                    
                    array.forEach { item in
                        print(item)
                    }
                    
                } catch {
                    print("데이터 가져오기 실패: \(error)")
                }
            }
        }
    }

    
    
    // MARK: - firebase에서 정보 받아오기
    // input:
    // output: [String]
    private func fetchArrayFromFirestore(forKey key: String) async throws -> [String] {
        let db = Firestore.firestore()
        let docRef = db.collection("user").document("3700121588")
        
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
                let array = data?[key] as? [String] ?? []
                continuation.resume(returning: array)
            }
        }
    }
    
}

#Preview {
    ProfileView()
}

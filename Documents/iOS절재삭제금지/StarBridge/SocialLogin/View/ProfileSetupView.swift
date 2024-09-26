//
//  ProfileSetupView.swift
//  StarBridge
//
//  Created by 김동현 on 9/4/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileSetupView: View {
    @ObservedObject private var kakaoAuthVM = KakaoAuthVM.shared
    // @Environment private var kakaoAuthVM: KakaoAuthVM

    @State private var nickname: String = ""
    @State private var birthDate: Date = Date()
    @State private var isAgreed: Bool = false
    @State private var showDatePicker: Bool = false
    @FocusState private var focusNicknameField: Bool
    
    private var isCompleteButtonEnabled: Bool {
        var reg = false
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9]+$", options: [])
            
        if let match = regex?.firstMatch(in: nickname, options: [], range: NSRange(location: 0, length: nickname.count)) {
            // 매칭된 범위가 전체 문자열 길이와 같은지 확인
            reg = match.range.length == nickname.count
        }
            
        return reg && isAgreed
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    private let firestore = Firestore.firestore()

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("StarBridge")
                    .font(.system(size: 30, weight: .black))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.black)

                Text("회원가입에 필요한\n정보를 입력해주세요")
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)

                Text("닉네임 *")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)

                ZStack(alignment: .leading) {
                    if nickname.isEmpty {
                        Text("언제든 바꿀 수 있어요 (영문과 숫자만 가능해요)")
                            .foregroundColor(.gray)
                            .padding(.leading)
                    }

                    TextField("", text: $nickname)
                        .textFieldStyle(PlainTextFieldStyle()) // 기본 스타일 사용
                        .padding()
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        .focused($focusNicknameField) // focus 상태 추적
                }


                Text("생년월일")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)

                Button(action: {
                    showDatePicker.toggle()
                    focusNicknameField = false
                }) {
                    Text(dateFormatter.string(from: birthDate))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                }

                
                Text("서비스 약관 동의 *")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)

                Text("동의 체크 후 앱을 이용할 수 있어요")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: isAgreed ? "checkmark.square" : "square")
                        .foregroundColor(.black)
                        .onTapGesture {
                            isAgreed.toggle()
                        }

                    Text("이용약관 및 개인정보처리방침")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }

                Spacer()

                Button(action: completeButtonTapped) {
                    Text("완료")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(isCompleteButtonEnabled ? Color.pink : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(22)
                }
                .disabled(!isCompleteButtonEnabled)
            }
            .padding()
            .navigationBarHidden(true)

            // DatePicker가 보여질 때 나타나는 HalfSheet
            if showDatePicker {
                Color.black.opacity(0.3) // 배경을 덮는 반투명 레이어
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // 배경을 누르면 DatePicker가 사라지도록 함
                        showDatePicker = false
                    }
                
                HalfSheet(isPresented: $showDatePicker) {
                    VStack {
                        DatePicker(
                            "생년월일",
                            selection: $birthDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .colorInvert()
                        .colorMultiply(.black)
                        .environment(\.locale, Locale(identifier: "ko_KR"))

                        HStack {
                            Spacer()

                            Button("완료") {
                                showDatePicker = false
                            }
                            .font(.system(size: 16, weight: .bold))
                            .padding()
                        }
                    }
                    .padding()
                }
                .transition(.move(edge: .bottom))
                .zIndex(1) // 상단에 위치하도록 설정
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(.p3LightGray)
    }

    private func completeButtonTapped() {
        print("pressed")
        guard isAgreed else {
            print("약관 동의가 필요합니다")
            return
        }

        if let userID = kakaoAuthVM.kakaoUserId {
            MyFirestore.shared.saveProfile(
                uid: userID,
                nickname: nickname,
                birthDate: dateFormatter.string(from: birthDate)) { error in
                if let error = error {
                    print("Firestore 저장 오류: \(error.localizedDescription)")
                } else {
                    print("정보가 Firestore에 성공적으로 저장되었습니다.")
                    kakaoAuthVM.hasProfile = true
                    print("완료: \(kakaoAuthVM.hasProfile)")
                }
            }
        }
    }
}

struct HalfSheet<Content: View>: View {
    var content: Content
    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                content
                    .background(Color.white)
                    .cornerRadius(16)
                    .frame(height: geometry.size.height / 2)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        withAnimation(.easeInOut) {
                            // 애니메이션이 나타날 때 실행되는 코드
                        }
                    }
                    .onDisappear {
                        withAnimation(.easeInOut) {
                            // 애니메이션이 사라질 때 실행되는 코드
                        }
                    }
                    
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
#Preview {
    ProfileSetupView()
}


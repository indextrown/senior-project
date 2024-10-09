import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var kakaoAuthVM: KakaoAuthVM
    @State private var buttonSize: CGSize = .zero
    @State private var artistArr: [Api.ImageData] = []
    @State private var isLoading = true
    
    private var artistlist = [
        "ive", "nct", "newjeans", "bts"
    ]
    
    @State private var scrollOffset:CGFloat = 0
    @State private var timer: Timer?
    private let itemWidth: CGFloat = 100 // 각 아이템의 너비와 간격 포함
    private let spacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                Spacer()
                Spacer()
                Image("Logo2")
                    .resizable()
                    .scaledToFit()
                Spacer()
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5)  // ProgressView 크기 조정
                            .padding(.top, 100)
                        Text("아티스트 데이터를 불러오는 중...")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    }
                }
                else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(0..<(artistArr.count * 2), id: \.self) { index in
                                let artist = artistArr[index % artistArr.count]
                                VStack {
                                    if let imageData = artist.imageData {
                                        if let image = api.loadImage(from: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: itemWidth, height: itemWidth)
                                                .cornerRadius(itemWidth / 2)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .offset(x: scrollOffset)
                        .onAppear {
                            startAutoScroll()
                        }
                        .onDisappear {
                            timer?.invalidate()
                        }
                    }
                    .frame(height: itemWidth)
                    .disabled(true)
                }
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Button {
                    // TODO:
                    kakaoAuthVM.handleKakaoLogin()
                } label: {
                    HStack {
                        Image("kakao_logo")
                        Text("Kakao로 로그인")
                    }
                    
                }.buttonStyle(SocialLoginButton(buttontype: "Kakao"))
                
                
                SignInWithAppleButton { request in
                    // TODO:
                    //authViewModel.send(action: .appleLogin(request))
                    
                    // 인증이 완료됬을때 불려지는 클로저 - 성공시 파이어베이스 인증 진행
                } onCompletion: { request in
                    // TODO:
                   // authViewModel.send(action: .appleLoginCompletion(request))
                }
                .frame(height: 55)
                .padding(.horizontal, 15)
                .cornerRadius(5)
                
                // MARK: - 구글버튼
                Button {
                    // TODO:
                    //authViewModel.send(action: .googleLogin)
                } label: {
                    HStack {
                        Image("google_logo")
                        Text("Google로 로그인")
                    }
                    
                }.buttonStyle(SocialLoginButton(buttontype: "Google"))
                Button("회원가입 없이 둘러보기", action: {
                    kakaoAuthVM.kakaoLogout()
                }
                ).foregroundColor(.black)
                Spacer()
            }
            .frame(width: geometry.size.width)
            .background(.white)
        }
        .onAppear {
            Task {
                for artist in artistlist {
                    if let imageData = await api.fetchData(for: ["Content": "image", "filename": "\(artist)"]){
                        if let tmp: Api.ImageData = imageData.values.first?.first?.imageData {
                            artistArr.append(tmp)
                        }
                    }
                }
                isLoading = false
            }
        }
    }
    
    private func startAutoScroll() {
        let totalContentWidth = (itemWidth + spacing) * CGFloat(artistArr.count)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            withAnimation(.linear(duration: 0.001)) {
                scrollOffset -= 0.5
                if scrollOffset <= -totalContentWidth {
                    scrollOffset = 0 // 처음 위치로 되돌림
                }
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
}



#Preview {
//    LoginView(kakaoAuthVM: KakaoAuthVM())
    LoginView()
}


#Preview {
//    LoginView(kakaoAuthVM: KakaoAuthVM())
    LoginView()
}

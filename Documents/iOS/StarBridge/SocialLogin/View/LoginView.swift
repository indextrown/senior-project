import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    //@ObservedObject var kakaoAuthVM: KakaoAuthVM
    @EnvironmentObject var kakaoAuthVM: KakaoAuthVM
    
    @State private var buttonSize: CGSize = .zero
    

    
    var body: some View {
        VStack(spacing: 20) {
            Image("StarBridgeLogo").padding(130)
            Button(action: {
                kakaoAuthVM.handleKakaoLogin()
            }) {
                HStack {
                    
                    Image("kakao_login_large_wide")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                // 카카오 로그인 버튼의 크기를 가져와서 저장
                                buttonSize = geometry.size
                            }
                        }
                    )
                }
            }
        }
        .padding()
        
        Text("회원가입 없이 둘러보기")
//        Button("회원가입 없이 둘러보기", action: {
//            kakaoAuthVM.kakaoLogout()
//        })
        
    }
}



//#Preview {
//    LoginView(kakaoAuthVM: KakaoAuthVM())
//}

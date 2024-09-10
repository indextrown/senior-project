import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    //@ObservedObject var kakaoAuthVM: KakaoAuthVM
//    @EnvironmentObject var kakaoAuthVM: KakaoAuthVM
    
    @State private var buttonSize: CGSize = .zero

    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()
                Image("StarBridgeLogo")
                    .resizable()
                    .scaledToFit()
                Spacer()
                
                Button(action: {
                    //                kakaoAuthVM.handleKakaoLogin()
                }) {
                    ZStack {
                        HStack {
                            Image("kakao_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: buttonSize.height * 0.4)
                                .padding(.leading)
                            Spacer()
                        }
                        Text("카카오 로그인")
                            .foregroundColor(.black.opacity(0.85))
                    }
                    .frame(height: geometry.size.width * 0.15)
                    .background{
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.kakaoBg)
                                .onAppear {
                                    buttonSize = geo.size
                                }
                        }
                    }
                }
                Button(action: {
                    
                }) {
                    ZStack {
                        HStack {
                            Image("google_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: buttonSize.height * 0.4)
                                .padding(.leading)
                            Spacer()
                        }
                        Text("구글 로그인")
                            .foregroundColor(.black)
                    }
                    .frame(height: geometry.size.width * 0.15)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.googleBg)
                    }
                }
                Text("회원가입 없이 둘러보기")
                    .foregroundColor(.black)
                    .padding(.bottom)
        //        Button("회원가입 없이 둘러보기", action: {
        //            kakaoAuthVM.kakaoLogout()
        //        })
            }
            .padding()
            .frame(width: geometry.size.width)
            .background(.white)
        }
    }
}



#Preview {
//    LoginView(kakaoAuthVM: KakaoAuthVM())
    LoginView()
}

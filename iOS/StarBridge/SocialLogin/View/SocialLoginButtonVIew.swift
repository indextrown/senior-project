//
//  SocialLoginButton.swift
//  Banchango
//
//  Created by 김동현 on 9/9/24.
//

import SwiftUI

struct SocialLoginButton: ButtonStyle {
    
    let buttontype: String
    
    init(buttontype: String) {
        self.buttontype = buttontype
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18))
            .foregroundColor(buttontype == "Apple" ? Color.white :
                             buttontype == "Google" ? Color.black :
                             buttontype == "Kakao" ? Color.black.opacity(0.85) : Color.black) // 카카오 버튼 레이블 색상
            .frame(maxWidth: .infinity, maxHeight: 55)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(buttontype == "Apple" ? Color.black :
                          buttontype == "Google" ? Color.white :
                          buttontype == "Kakao" ? Color(hex: "#FEE500") : Color.clear) // 카카오 버튼 배경색
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(buttontype == "Apple" ? Color.black :
                            buttontype == "Google" ? Color.black :
                            buttontype == "Kakao" ? Color(hex: "#FEE500") : Color.clear, lineWidth: 0.8) // 카카오 버튼 테두리 색상
            )
            .padding(.horizontal, 15)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .contentShape(RoundedRectangle(cornerRadius: 5))
    }
}

// UIColor의 hex 값을 SwiftUI Color로 변환하기 위한 확장
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}



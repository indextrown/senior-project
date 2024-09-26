//
//  TextView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-07.
//

import SwiftUI

struct TextView: View {
    let text: String
    let size: CGFloat
    let weight: Font.Weight
    let color: Color
    let design: Font.Design
    
    init(_ text: String,  size: CGFloat = 17, weight: Font.Weight = .regular, color: Color = Color.black,design: Font.Design = .default){
        self.text = text
        self.size = size
        self.weight = weight
        self.color = color
        self.design = design
    }
    
    var body: some View {
        if #available(iOS 17, *) {
            Text(text)
                .font(.system(size: size, weight: weight, design: design))
                .foregroundStyle(color)

        } else {
            Text(text)
                .font(.system(size: size, weight: weight, design: design))
                .foregroundColor(color)
        }
    }
}

//
//  ScheduleDetailView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-19.
//

import SwiftUI

struct ScheduleDetailView: View {
    @State private var detail: String
    
    init(detail: String = ""){
        self.detail = detail
    }
    var body: some View {
        Text("받아온 내용")
        Text(detail)
    }
}

#Preview {
    ScheduleDetailView()
}

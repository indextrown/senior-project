//
//  ContentView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-06-30.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var currentView = "ArtistView"
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                ScrollViewReader{ ScrollViewProxy in
                    HStack{
                        Button{
                            
                        }label: {
                            TextView("blip", size: 30, weight: .bold)
                        }
                        Button{
                            ScrollViewProxy.scrollTo("ArtistView")
                            currentView = "ArtistView"
                        }label: {
                            TextView("Artists", size: 18)
                        }
                        Button{
                            ScrollViewProxy.scrollTo("ScheduleView")
                            currentView = "ScheduleView"
                        }label: {
                            TextView("Schedule", size: 18)
                        }
                        Button{
                           
                            currentView = "CafeView"
                        }label: {
                            TextView("Cafe", size: 18)
                        }
                        Spacer()
                        Button{
                            
                        }label: {
                            TextView("kpop radar", weight: .bold, color: Color.white)
                        }
                            .frame(width: 100, height: 40) //가로 세로 비율: 5: 2
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                        .padding()
                        .frame(height: geometry.size.height / 20)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ArtistView().frame(width: geometry.size.width)
                                .id("ArtistView")
                                .frame(width: geometry.size.width)
                            ScheduleView().frame(width: geometry.size.width)
                                .id("ScheduleView")
                                .frame(width: geometry.size.width)
                        }
                    }
                    
                }
            }
            .frame(width: geometry.size.width)
            .ignoresSafeArea()
            .padding(.top,  iPhonePointRes.currentDevicePortraitSafeArea()?.top)
            .background(.p3LightGray)
        }
    }
}

#Preview {
    ContentView()
}

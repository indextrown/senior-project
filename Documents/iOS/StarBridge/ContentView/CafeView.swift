//
//  CafeView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI

//# mysql> desc cafe_db;
//# +-----------+--------------+------+-----+---------+----------------+
//# | Field     | Type         | Null | Key | Default | Extra          |
//# +-----------+--------------+------+-----+---------+----------------+
//# | NUMBER    | int          | NO   | PRI | NULL    | auto_increment |
//# | celebrity | varchar(20)  | YES  |     | NULL    |                |
//# | uploader  | varchar(30)  | YES  |     | NULL    |                |
//# | start_date| date         | YES  |     | NULL    |                |
//# | end_date  | date         | YES  |     | NULL    |                |
//# | place     | varchar(100  | YES  |     | NULL    |                |
//# | post_url  | varchar(100) | YES  |     | NULL    |                |
//# +-----------+--------------+------+-----+---------+----------------+

struct CafeView: View {
//    @State private var cafeArr:
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(){
                
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .onAppear {
                
            }
        }
    }
}

#Preview {
    CafeView()
}

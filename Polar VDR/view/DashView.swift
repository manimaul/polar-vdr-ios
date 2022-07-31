//
//  DashView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import SwiftUI

struct DashView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Polar Speed")
                    Text("0.0%")
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("STW")
                    Text("6.2kts")
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("AWA")
                    Text("45")
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(6.0).font(.system(size: geometry.size.width / 20))
        }
    }
}

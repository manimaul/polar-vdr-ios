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
            let fSize = geometry.size.width / 20
            ZStack {
                RadarRingsView(numRings: 9, topSpace: fSize * 4)
                VStack {
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
                    }.font(.system(size: fSize))
                            .frame(maxHeight: .infinity, alignment: .top)
                }
            }
        }.padding(padSzLg)
    }
}

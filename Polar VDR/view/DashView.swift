//
//  DashView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import SwiftUI

struct DashView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Efficiency")
                Text("0.0%")
            }.frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("STW")
                Text("0.0kts")
            }.frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("AWA")
                Text("0°")
            }.frame(maxWidth: .infinity, alignment: .leading)
            PolarView(numRings: 10)
        }.font(.system(size: 25.0))
                .padding(padSzLg)
    }
}

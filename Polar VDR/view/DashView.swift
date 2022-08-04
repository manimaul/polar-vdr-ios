//
//  DashView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import SwiftUI

struct DashView: View {
    let twa = Angle(degrees: 45.0)
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
            ZStack {
                PolarRadarView(numRings: 6)
                PredictionLinesView(lines: PredictionLines(cog: Angle(degrees: 5.0), hdt:Angle(degrees: 0.0), twa: Angle(degrees: 45.0)))
            }
        }.font(.system(size: 25.0))
                .padding(padSzLg)
    }
}

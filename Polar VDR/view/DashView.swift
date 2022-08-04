//
//  DashView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import SwiftUI

struct DashView: View {
    @Environment(\.colorScheme) var colorScheme
    let twa = Angle(degrees: 45.0)
    var body: some View {
        VStack {
            HStack {
                Text("Polar Efficiency")
                Text("0.0%")
            }.padding(.bottom, padSzMd)
            HStack {
                //left column
                VStack {
                    HStack {
                        Text("STW")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("SOG")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, padSzMd)

                    HStack {
                        Text("TWS")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.twsColor())
                    HStack {
                        Text("AWS")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                //right column
                VStack {
                    HStack {
                        Text("TWA")
                        Text("45°")
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    HStack {
                        Text("AWA")
                        Text("0°")
                    }.frame(maxWidth: .infinity, alignment: .trailing).padding(.bottom, padSzMd)

                    HStack {
                        Text("HDT")
                        Text("0°")
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.hdtColor())
                    HStack {
                        Text("COG")
                        Text("5°")
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.cogColor())
                }
            }

            ZStack {
                PolarRadarView(numRings: 6)
                PredictionLinesView(lines: PredictionLines(cog: Angle(degrees: 5.0), hdt:Angle(degrees: 0.0), twa: Angle(degrees: 45.0)))
            }
        }.font(.system(size: 25.0))
                .padding(padSzLg)
    }
}

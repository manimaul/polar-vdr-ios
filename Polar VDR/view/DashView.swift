//
//  DashView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import SwiftUI

struct DashView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var global: Global
    let twa = Angle(degrees: 45.0)
    var body: some View {
        VStack {
            HStack {
                Text("Polar Efficiency")
                Text("0%")
            }.padding(.bottom, padSzMd).foregroundColor(colorScheme.stwColor())
            HStack {
                //left column
                VStack {
                    HStack {
                        Text("STW")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.stwColor())
                    HStack {
                        Text("SOG")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, padSzMd).foregroundColor(colorScheme.sogColor())

                    HStack {
                        Text("TWS")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.twsColor())
                    HStack {
                        Text("AWS")
                        Text("0.0kts")
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.awsColor())
                }
                //right column
                VStack {
                    HStack {
                        Text("TWA")
                        Text("45°")
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.twaColor())
                    HStack {
                        Text("AWA")
                        Text("38°")
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.awaColor())
                    HStack {
                        Text("RWA")
                        Text("38°")
                    }.frame(maxWidth: .infinity, alignment: .trailing).padding(.bottom, padSzMd).foregroundColor(colorScheme.awaColor())

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
                PolarRadarView(polarData: global.boat.polar)
                PredictionLinesView(lines: PredictionLines(
                        cog: Angle(degrees: 5.0),
                        hdt:Angle(degrees: 0.0),
                        twa: Angle(degrees: 45.0),
                        awa: Angle(degrees: 38.0)))
            }
        }.font(.system(size: 25.0))
                .padding(padSzLg)
    }
}

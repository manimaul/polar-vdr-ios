//
//  DashView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import SwiftUI


class Formatter {
    let numberFormatter: NumberFormatter

    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.maximumIntegerDigits = 3
        numberFormatter.maximumFractionDigits = 1
    }

    func formatKnots(kts: Double?) -> String {
        let ktStr = numberFormatter.string(for: kts) ?? ""
        if ktStr.count == 0 {
            return "-- kts"
        } else {
            return "\(ktStr) kts"
        }
    }

    func formatDegrees(angle: Angle?) -> String {
        var deg = angle?.degreesNormal()
        deg?.round()
        let degStr = numberFormatter.string(for: deg) ?? ""
        if degStr.count == 0 {
            return "--°"
        } else {
            return "\(degStr)°"
        }
    }
}

fileprivate let formatter = Formatter()


fileprivate func headingLabel() -> String {
    if globalState.navData.magnetic {
        return "HDG"
    } else {
        return "HDT"
    }
}

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
                        Text(formatter.formatKnots(kts: global.navData.stw?.data))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.stwColor())
                    HStack {
                        Text("SOG")
                        Text(formatter.formatKnots(kts: global.navData.sog?.data))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.sogColor()).padding(.bottom, padSzMd)

                    HStack {
                        Text("TWS")
                        Text(formatter.formatKnots(kts: global.navData.tws?.data))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.twsColor())
                    HStack {
                        Text("AWS")
                        Text(formatter.formatKnots(kts: global.navData.stw?.data))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.awsColor())
                }
                //right column
                VStack {
                    HStack {
                        Text("TWA")
                        Text(formatter.formatDegrees(angle: global.navData.twa?.data))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.twaColor())
                    HStack {
                        Text("AWA")
                        Text(formatter.formatDegrees(angle: global.navData.awa?.data))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.awaColor()).padding(.bottom, padSzMd)

                    HStack {
                        Text(headingLabel())
                        Text(formatter.formatDegrees(angle: global.navData.hdg?.data))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.hdtColor())
                    HStack {
                        Text("COG")
                        Text(formatter.formatDegrees(angle: global.navData.cog?.data))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.cogColor())
                }
            }

            ZStack {
                PolarRadarView(polarData: global.boat.polar)
                PredictionLinesView()
            }
        }.font(.system(size: 25.0))
                .padding(padSzLg)
    }
}

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

    func formatEfficiency(pct: Double?) -> String {
        if let pct = pct {
            let pctStr = numberFormatter.string(for: pct * 100.0) ?? ""
            if pctStr.count == 0 {
                return "--%"
            } else {
                return "\(pctStr)%"
            }
        } else {
            return "--%"
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
    if globalState.navHeading?.magnetic == true {
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
                Text(formatter.formatEfficiency(pct: global.polarEFF?.value))
            }.padding(.bottom, padSzMd).foregroundColor(colorScheme.stwColor())
            HStack {
                //left column
                VStack {
                    HStack {
                        Text("STW")
                        Text(formatter.formatKnots(kts: global.navSTW?.value))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.stwColor())
                    HStack {
                        Text("SOG")
                        Text(formatter.formatKnots(kts: global.navSOG?.value))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.sogColor()).padding(.bottom, padSzMd)

                    HStack {
                        Text("TWS")
                        Text(formatter.formatKnots(kts: global.navTWS?.value))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.twsColor())
                    HStack {
                        Text("AWS")
                        Text(formatter.formatKnots(kts: global.navAWS?.value))
                    }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(colorScheme.awsColor())
                }
                //right column
                VStack {
                    HStack {
                        Text("TWA")
                        Text(formatter.formatDegrees(angle: global.navTWA?.value))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.twaColor())
                    HStack {
                        Text("AWA")
                        Text(formatter.formatDegrees(angle: global.navAWA?.value))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.awaColor()).padding(.bottom, padSzMd)

                    HStack {
                        Text(headingLabel())
                        Text(formatter.formatDegrees(angle: global.navHeading?.angle))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.hdtColor())
                    HStack {
                        Text("COG")
                        Text(formatter.formatDegrees(angle: global.navCOG?.angle))
                    }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(colorScheme.cogColor())
                }
            }

            ZStack {
                PolarRingsView()
                PredictionLinesView()
            }
        }.font(.system(size: 25.0))
                .padding(padSzLg)
    }
}

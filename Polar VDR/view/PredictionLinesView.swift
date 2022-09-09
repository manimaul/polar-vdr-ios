//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

struct PredictionLinesView : View {
    @EnvironmentObject var global: Global
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            let x = geometry.drawCenterX()
            let y = geometry.drawCenterY()
            let len = min(x,y) - halfOffset
            let p = CGPoint(x: x, y: y)
            let pp = p.project(distance: len, degrees: 0)
            let ppp = CGPoint(x: pp.x, y: pp.y - 11)

            if let hdg: Angle = global.navHeading?.angle {
                if let cog: Angle = global.navCOG?.angle {
                    let lineAngle = cog - hdg
                    //COG Line
                    Path { path in
                        path.move(to: p)
                        path.addLine(to: p.project(distance: len, degrees: lineAngle.degrees))
                    }.stroke(lineWidth: 2).fill(colorScheme.cogColor())

                    //COG Triangle
                    Path { path in
                        path.move(to: CGPoint(x: x, y: pp.y))
                        path.addLine(to: CGPoint(x: x + 10, y: pp.y + 10))
                        path.addLine(to: CGPoint(x: x - 10, y: pp.y + 10))
                        path.addLine(to: CGPoint(x: x, y: pp.y))
                    }.fill(colorScheme.cogColor()).rotationEffect(lineAngle)
                }
            }

            //HDT Line
            Path { path in
                path.move(to: p)
                path.addLine(to: pp)
            }.stroke(lineWidth: 2).fill(colorScheme.hdtColor())

            //HDT Triangle
            Path { path in
                path.move(to: CGPoint(x: x, y: pp.y))
                path.addLine(to: CGPoint(x: x + 10, y: pp.y + 10))
                path.addLine(to: CGPoint(x: x - 10, y: pp.y + 10))
                path.addLine(to: CGPoint(x: x, y: pp.y))
            }.fill(colorScheme.hdtColor())

            if let twa: Angle = global.navTWA?.value {
                //TWA Line
                Path { path in
                    path.move(to: p)
                    path.addLine(to: p.project(distance: len, degrees: twa.degrees))
                }.stroke(lineWidth: 3).fill(colorScheme.twaColor())

                //TWA Triangle
                Path { path in
                    path.move(to: CGPoint(x: x - 10, y: ppp.y + 10))
                    path.addLine(to: CGPoint(x: x + 10, y: ppp.y + 10))
                    path.addLine(to: CGPoint(x: x, y: ppp.y + 20))
                    path.addLine(to: CGPoint(x: x - 10, y: ppp.y + 10))
                }.fill(colorScheme.twaColor()).rotationEffect(twa)

                let stw = p.project(distance: effLen(len: len), degrees: 0)
                Circle()
                        .fill(colorScheme.stwColor())
                        .frame(width: 10, height: 10, alignment: .center)
                        .position(x: stw.x, y: stw.y)
                        .rotationEffect(twa)
            }

            if let awa: Angle = global.navAWA?.value {
                //AWA Line
//                Path { path in
//                    path.move(to: p)
//                    path.addLine(to: p.project(distance: len, degrees: awa.degrees))
//                }.stroke(colorScheme.awaColor())

                //AWA Triangle
                Path { path in
                    path.move(to: CGPoint(x: x - 10, y: ppp.y + 10))
                    path.addLine(to: CGPoint(x: x + 10, y: ppp.y + 10))
                    path.addLine(to: CGPoint(x: x, y: ppp.y + 20))
                    path.addLine(to: CGPoint(x: x - 10, y: ppp.y + 10))
                }.fill(colorScheme.awaColor()).rotationEffect(awa)
            }

            ForEach([35.0,40.0,45.0,50.0,60.0,70.0,80.0,90.0,100.0,110.0,120.0,130.0,140.0,150.0,160.0,170.0], id: \.self) { deg in

                Path { path in
                    path.move(to: degreeLineStart(center: p, deg: deg, len: len))
                    path.addLine(to: p.project(distance: len, degrees: deg))
                }.stroke(colorScheme.twsColor().opacity(0.5))

                Text(formatter.formatDegrees(angle: Angle(degrees: deg)))
                        .position(p.project(distance: len + 15, degrees: deg))
                        .font(.system(size: 12.0))
                        .foregroundColor(colorScheme.twsColor())

                let leftDeg = 360 - deg;

                Path { path in
                    path.move(to: degreeLineStart(center: p, deg: leftDeg, len: len))
                    path.addLine(to: p.project(distance: len, degrees: leftDeg))
                }.stroke(colorScheme.twsColor().opacity(0.5))

                Text(formatter.formatDegreesApparent(angle: Angle(degrees: leftDeg)))
                        .position(p.project(distance: len + 15, degrees: leftDeg))
                        .font(.system(size: 12.0))
                        .foregroundColor(colorScheme.twsColor())

            }
        }
    }

    func degreeLineStart(center: CGPoint, deg: Double, len: CGFloat) -> CGPoint {
        switch abs(deg) {
        case 35.0, 50.0, 90.0, 130.0, 150.0, 325.0, 310.0, 270.0, 230.0, 210.0:
            return center
        default:
            return center.project(distance: len - 10, degrees: deg)
        }
    }

    func effLen(len: CGFloat) -> CGFloat {
        if let stw: Double = global.navSTW?.value {
            if let maxStw = global.boat.polar.maxStw {
                if maxStw > 0.0 {
                    let pct = stw / maxStw
                    return len * pct
                }
            }
        }
        return 0.0
    }
}

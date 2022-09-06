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
            let len = min(x,y)
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
                    }.stroke(colorScheme.cogColor())

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
            }.stroke(colorScheme.hdtColor())

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
                }.stroke(colorScheme.twaColor())

                //TWA Triangle
                Path { path in
                    path.move(to: CGPoint(x: x - 10, y: ppp.y))
                    path.addLine(to: CGPoint(x: x + 10, y: ppp.y ))
                    path.addLine(to: CGPoint(x: x, y: ppp.y + 10))
                    path.addLine(to: CGPoint(x: x - 10, y: ppp.y))
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
                    path.move(to: CGPoint(x: x - 10, y: ppp.y))
                    path.addLine(to: CGPoint(x: x + 10, y: ppp.y ))
                    path.addLine(to: CGPoint(x: x, y: ppp.y + 10))
                    path.addLine(to: CGPoint(x: x - 10, y: ppp.y))
                }.fill(colorScheme.awaColor()).rotationEffect(awa)
            }
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

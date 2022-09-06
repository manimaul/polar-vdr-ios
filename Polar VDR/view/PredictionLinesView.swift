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

            if let cog: Angle = global.navData.cog?.data {
                //COG Line
                Path { path in
                    path.move(to: p)
                    path.addLine(to: p.project(distance: len, degrees: cog.degrees))
                }.stroke(colorScheme.cogColor())

                //COG Triangle
                Path { path in
                    path.move(to: CGPoint(x: x, y: pp.y))
                    path.addLine(to: CGPoint(x: x + 10, y: pp.y + 10))
                    path.addLine(to: CGPoint(x: x - 10, y: pp.y + 10))
                    path.addLine(to: CGPoint(x: x, y: pp.y))
                }.fill(colorScheme.cogColor()).rotationEffect(cog)
            }

            if let hdg: Angle = global.navData.hdg?.data {

                //HDT Line
                Path { path in
                    path.move(to: p)
                    path.addLine(to: p.project(distance: len, degrees: hdg.degrees))
                }.stroke(colorScheme.hdtColor())

                //HDT Triangle
                Path { path in
                    path.move(to: CGPoint(x: x, y: pp.y))
                    path.addLine(to: CGPoint(x: x + 10, y: pp.y + 10))
                    path.addLine(to: CGPoint(x: x - 10, y: pp.y + 10))
                    path.addLine(to: CGPoint(x: x, y: pp.y))
                }.fill(colorScheme.hdtColor()).rotationEffect(hdg)
            }

            //TWA Triangle
            if let twa = global.navData.twa?.data {

                Path { path in
                    path.move(to: CGPoint(x: x - 10, y: ppp.y))
                    path.addLine(to: CGPoint(x: x + 10, y: ppp.y ))
                    path.addLine(to: CGPoint(x: x, y: ppp.y + 10))
                    path.addLine(to: CGPoint(x: x - 10, y: ppp.y))
                }.fill(colorScheme.twaColor()).rotationEffect(twa)
            }

            if let awa: Angle = global.navData.awa?.data {
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
}

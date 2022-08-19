//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

struct PredictionLines{
    let cog: Angle
    let hdt: Angle
    let twa: Angle
    let awa: Angle
}

struct PredictionLinesView : View {
    let lines: PredictionLines
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            let x = geometry.drawCenterX()
            let y = geometry.drawCenterY()
            let len = min(x,y)
            let p = CGPoint(x: x, y: y)
            let pp = p.project(distance: len, degrees: lines.hdt.degrees)

            //COG Line
            Path { path in
                path.move(to: p)
                path.addLine(to: p.project(distance: len, degrees: lines.cog.degrees))

            }.stroke(colorScheme.cogColor())

            //COG Triangle
            Path { path in
                path.move(to: CGPoint(x: x, y: pp.y))
                path.addLine(to: CGPoint(x: x + 10, y: pp.y + 10))
                path.addLine(to: CGPoint(x: x - 10, y: pp.y + 10))
                path.addLine(to: CGPoint(x: x, y: pp.y))
            }.fill(colorScheme.cogColor()).rotationEffect(lines.cog)

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

            //TWA Triangle
            Path { path in
                path.move(to: CGPoint(x: x - 10, y: pp.y))
                path.addLine(to: CGPoint(x: x + 10, y: pp.y ))
                path.addLine(to: CGPoint(x: x, y: pp.y + 10))
                path.addLine(to: CGPoint(x: x - 10, y: pp.y))
            }.fill(colorScheme.twaColor()).rotationEffect(lines.twa)

            //AWA Triangle
            Path { path in
                path.move(to: CGPoint(x: x - 10, y: pp.y))
                path.addLine(to: CGPoint(x: x + 10, y: pp.y ))
                path.addLine(to: CGPoint(x: x, y: pp.y + 10))
                path.addLine(to: CGPoint(x: x - 10, y: pp.y))
            }.fill(colorScheme.awaColor()).rotationEffect(lines.awa)
        }
    }
}

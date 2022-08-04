//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

struct PredictionLines{
    let cog: Angle
    let hdt: Angle
    let twa: Angle
    let tack: Tack


    init(cog: Angle, hdt: Angle, twa: Angle) {
        self.cog = Angle(degrees: cog.degreesNormal())
        self.hdt = Angle(degrees: hdt.degreesNormal())
        self.twa = Angle(degrees: twa.degreesNormal())
        self.tack = self.twa.windDegreesAsTack()
    }
}

struct PredictionLinesView : View {
    let lines: PredictionLines

    var body: some View {
        GeometryReader { geometry in
            let x = geometry.drawCenterX()
            let y = geometry.drawCenterY()
            Path { path in
                let p = CGPoint(x: x, y: y)
                let pp = p.pointFromPoint(distance: geometry.size.height / 2, degrees: lines.cog.degrees)
                path.move(to: p)
                path.addLine(to: pp)

            }.stroke(.red)

            Path { path in
                let p = CGPoint(x: x, y: y)
                let pp = p.pointFromPoint(distance: geometry.size.height / 2, degrees: lines.hdt.degrees)
                path.move(to: p)
                path.addLine(to: pp)

            }.stroke(.green)
        }
    }
}

//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

struct PredictionLinesView : View {
    let tack: Tack

    var body: some View {
        GeometryReader { geometry in
            let x = geometry.drawCenterX(tack: tack)
            let y = geometry.drawCenterY()
            Path { path in
                let p = CGPoint(x: x, y: y)
                let pp = p.pointFromPoint(distance: geometry.size.height / 2, degrees: 315)
                path.move(to: p)
                path.addLine(to: pp)

            }.stroke(.red)

            Path { path in
                let p = CGPoint(x: x, y: y)
                let pp = p.pointFromPoint(distance: geometry.size.height / 2, degrees: 357)
                path.move(to: p)
                path.addLine(to: pp)

            }.stroke(.green)
        }
    }
}

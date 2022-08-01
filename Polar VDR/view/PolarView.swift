//
// Created by William Kamp on 7/30/22.
//

import SwiftUI

enum Tack {
    case port
    case starboard
}

struct PolarView: View {
    @Environment(\.colorScheme) var colorScheme
    let numRings: Int
    let tack: Tack

    init(
            numRings: Int = 4,
            tack: Tack = .port
    ) {
        self.numRings = numRings
        self.tack = tack
    }

    private func rotAngle() -> Angle {
        let angle: Angle
        switch tack {
        case .port:
            angle = Angle(degrees: -90.0)
        case .starboard:
            angle = Angle(degrees: 90.0)
        }
        return angle
    }

    private func drawCenterX(geo: GeometryProxy) -> CGFloat {
        switch tack {
        case .port:
            return 0.0 + padSzLg
        case .starboard:
            return geo.size.width - padSzLg
        }
    }

    private func drawCenterY(geo: GeometryProxy) -> CGFloat {
        geo.size.height / 2.0
    }

    private func ringColor() -> Color {
        switch (colorScheme) {
        case .light:
            return .black
        case .dark:
            return .white
        @unknown default:
            return .gray
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let dia = min(geometry.size.height, geometry.size.width) * 1.5
            let increment = dia / CGFloat(numRings)
            ZStack {
                ForEach((0...numRings), id: \.self) {
                    let n: CGFloat = CGFloat($0)
                    Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(rotAngle())
                            .stroke(ringColor())
                            .frame(width: dia - increment * n, height: dia - increment * n, alignment: .center)
                            .position(x: drawCenterX(geo: geometry), y: drawCenterY(geo: geometry))
                }
            }.background(.red)
        }
    }
}

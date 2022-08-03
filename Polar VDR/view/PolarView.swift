//
// Created by William Kamp on 7/30/22.
//

import SwiftUI

extension ColorScheme {
    func ringColor() -> Color {
        switch (self) {
        case .light:
            return .black
        case .dark:
            return .white
        @unknown default:
            return .gray
        }
    }
}

struct PolarView: View {
    @Environment(\.colorScheme) var colorScheme
    let numRings: Int
    let tack: Tack

    private func rotAngle() -> Angle {
        let angle: Angle
        switch tack {
        case .port, .unknown:
            angle = Angle(degrees: -90.0)
        case .starboard:
            angle = Angle(degrees: 90.0)
        }
        return angle
    }

    var body: some View {
        GeometryReader { geometry in
            let dia: CGFloat = min(geometry.size.height, geometry.size.width) * 1.5
            let increment: CGFloat = dia / CGFloat(numRings)
            let hullSize: CGFloat = (dia - increment * CGFloat(numRings - 1)) * 0.5
            let x = geometry.drawCenterX(tack: tack)
            let y = geometry.drawCenterY()

            ZStack {
                ForEach((0...numRings), id: \.self) {
                    let n: CGFloat = CGFloat($0)
                    let diameter = dia - increment * n
                    Text("\($0) kts")
                            .position(x: x, y: y + diameter / 2.0 - 5.0).font(.system(size: 8.0))
                    Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(rotAngle())
                            .stroke(colorScheme.ringColor())
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .position(x: x, y: y)
                }
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
                Image("hull").resizable()
                        .renderingMode(.template)
                        .colorMultiply(colorScheme.ringColor())
                        .aspectRatio(contentMode: .fit).frame(height: hullSize, alignment: .center).position(x: x, y: y)

            }
        }
    }
}

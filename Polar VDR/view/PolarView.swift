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
        tack: Tack = .starboard
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
            let dia: CGFloat = min(geometry.size.height, geometry.size.width) * 1.5
            let increment: CGFloat = dia / CGFloat(numRings)
            let hullSize: CGFloat = (dia - increment * CGFloat(numRings - 1)) * 0.5
            let x = drawCenterX(geo: geometry)
            let y = drawCenterY(geo: geometry)
//            var speed = 0...numRings

            ZStack {
                ForEach((0...numRings), id: \.self) {
                    let n: CGFloat = CGFloat($0)
                    let diameter = dia - increment * n
                    Text("\($0) kts")
                            .position(x: x, y: y + diameter / 2.0 - 5.0).font(.system(size: 8.0))
                    Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(rotAngle())
                            .stroke(ringColor())
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
                        .colorMultiply(ringColor())
                        .aspectRatio(contentMode: .fit).frame(height: hullSize, alignment: .center).position(x: x, y: y)

            }//.background(.red)
        }
    }
}

extension CGPoint {
    func pointFromPoint(distance: CGFloat, degrees: Double) -> CGPoint {
        let offsetDeg = degrees - 90
        let alpha = offsetDeg * Double.pi / 180.0
        var endPoint = CGPoint()
        endPoint.x = x + (distance * cos(alpha))
        endPoint.y = y + (distance * sin(alpha))
        return endPoint
    }
}

extension Int {
    func degreesToRadians() -> Double {
        Double(self) * Double.pi / 180.0
    }
}

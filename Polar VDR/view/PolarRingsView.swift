//
// Created by William Kamp on 7/30/22.
//

import SwiftUI

struct EntryPoint {
    let entry: PolarEntry
    let point: CGPoint
}

struct PolarRingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var global: Global

    var body: some View {
        let rings: Int = 5
        let maxStwFinal = Int(ceil(global.boat.polar.maxStw ?? 15))
        let ktsPerRing = maxStwFinal / rings
        let numRings = maxStwFinal / ktsPerRing

        GeometryReader { geometry in
            let dia: CGFloat = min(geometry.size.height, geometry.size.width)
            let increment: CGFloat = dia / CGFloat(numRings)
            let hullSize: CGFloat = (dia - increment * CGFloat(numRings - 1)) * 0.5
            let x = geometry.drawCenterX()
            let y = geometry.drawCenterY()
            let center = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)

            ZStack {
                // draw rings
                ForEach((0...numRings), id: \.self) {
                    let i: Int = $0
                    let diameter = increment * CGFloat(i)
                    if i > 0 {
                        Text("\($0 * ktsPerRing) kn")
                                .position(x: x, y: y + diameter / 2.0 + 8.0).font(.system(size: 12.0)).foregroundColor(colorScheme.twsColor())
                    }
                    Circle()
                            .stroke(colorScheme.twsColor())
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .position(x: x, y: y)
                }

                // draw hull
                Image("hull").resizable()
                        .renderingMode(.template)
                        .colorMultiply(colorScheme.defaultColor())
                        .aspectRatio(contentMode: .fit).frame(height: hullSize, alignment: .center).position(x: x, y: y)

                // draw polars
                if let tws = global.navTWS?.value {
                    if let entries = polarPoints(center: center, entries: global.boat.polar.entryForSpeed(tws: tws), increment: increment, ktsPerRing: ktsPerRing) {
                        Path { path in
                            if entries.count > 1 {
                                var e1 = entries[0].point
                                var e2 = entries[1].point
                                path.move(to: e1)
                                path.addLine(to: e2)
                                (2..<entries.count).forEach { i in
                                    let e3 = entries[i].point
                                    if let cp = controlPointForPoints(p1: e1, p2: e2, p3: e3, size: geometry.size) {
                                        path.addQuadCurve(to: e3, control: cp)
                                        e1 = cp
                                    } else {
                                        path.addLine(to: e3)
                                        e1 = e2
                                    }
                                    e2 = e3
                                }
                            }
                        }.stroke(colorScheme.defaultColor())
                        ForEach(0..<entries.count, id: \.self) { i in
                            Circle()
                                    .fill(colorScheme.defaultColor())
                                    .frame(width: 5, height: 5, alignment: .center)
                                    .position(entries[i].point)
                        }
                    }
                }
            }
        }
    }

    func point(center: CGPoint, entry: PolarEntry, pixelsPerKnot: CGFloat) -> CGPoint {
        center.project(distance: pixelsPerKnot * CGFloat(entry.stw), degrees: Double(entry.twa))
    }

    func polarPoints(center: CGPoint, entries: [PolarEntry]?, increment: CGFloat, ktsPerRing: Int) -> [EntryPoint]? {
        let pixelsPerKnot = increment / 2.0 / CGFloat(ktsPerRing)
        return entries?.map { each in
            EntryPoint(entry: each, point: point(center: center, entry: each, pixelsPerKnot: pixelsPerKnot))
        }
    }

    func controlPointForPoints(p1: CGPoint, p2: CGPoint, p3: CGPoint, size: CGSize) -> CGPoint? {
        let distance = CGPoint(x: 0, y: 0).distance(to: CGPoint(x: size.width, y: size.height))
        let m = p2.midPoint(to: p3)
        let angle = p2.angle(to: p3) + Angle(degrees: 90)
        let line = CGLine(start: m, end: m.project(distance: distance, degrees: angle.degreesNormal()))
        let angle2 = p1.angle(to: p2) + Angle(degrees: 180)
        let line2 = CGLine(start: p1, end: p1.project(distance: distance, degrees: angle2.degreesNormal()))
        return line.intersection(line: line2)
    }
}

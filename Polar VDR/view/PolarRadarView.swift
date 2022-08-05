//
// Created by William Kamp on 7/30/22.
//

import SwiftUI

struct PolarRadarView: View {
    @Environment(\.colorScheme) var colorScheme
    let polarData: PolarData
    let numRings: Int
    let ktsPerRing: Int
    let maxStwFinal: Int
    let tws: Float = 4.5 //todo: (WK)

    init(polarData: PolarData) {
        self.polarData = polarData
        var maxStw: Float? = nil
        polarData.data.forEach { entry in
            maxStw = max(maxStw ?? 0, entry.stw)
        }
        let rings: Int = 5
        self.maxStwFinal = Int(ceil(maxStw ?? 15))
        self.ktsPerRing = maxStwFinal / rings
        self.numRings = maxStwFinal / self.ktsPerRing
    }

    var body: some View {
        GeometryReader { geometry in
            let dia: CGFloat = min(geometry.size.height, geometry.size.width)
            let increment: CGFloat = dia / CGFloat(numRings)
            let hullSize: CGFloat = (dia - increment * CGFloat(numRings - 1)) * 0.5
            let x = geometry.drawCenterX()
            let y = geometry.drawCenterY()

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

                //todo: draw north arrow box

                // draw polars
                ForEach(polarData.entryForSpeed(tws: tws) ?? [], id: \.self) {
                    let data: PolarEntry = $0
                    Circle()
                            .fill(.red)
                            .frame(width: 5, height: 5, alignment: .center)
                            .position(point(geo: geometry, entry: data, increment: increment))
                }
                // draw hull
                Image("hull").resizable()
                        .renderingMode(.template)
                        .colorMultiply(colorScheme.defaultColor())
                        .aspectRatio(contentMode: .fit).frame(height: hullSize, alignment: .center).position(x: x, y: y)
            }
        }
    }

    func point(geo: GeometryProxy, entry: PolarEntry, increment: CGFloat) -> CGPoint {
        let center = CGPoint(x: geo.size.width / 2.0, y: geo.size.height / 2.0)
        let pixelsPerKnot = increment / 2.0 / CGFloat(ktsPerRing)
        return center.pointFromPoint(distance: pixelsPerKnot * CGFloat(entry.stw), degrees: Double(entry.twa))
    }
}

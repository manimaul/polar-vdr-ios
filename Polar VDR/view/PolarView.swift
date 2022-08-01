//
// Created by William Kamp on 7/30/22.
//

import SwiftUI

struct RadarRingsView: View {
    let numRings: Int
    let topSpace: CGFloat

    init(numRings: Int = 4, topSpace: CGFloat = 0.0) {
        self.numRings = numRings
        self.topSpace = topSpace
    }

    var body: some View {
        GeometryReader { geometry in
            let dia = min(geometry.size.height, geometry.size.width)
            let increment = dia / CGFloat(numRings)
            ZStack {
                ForEach((0...numRings), id: \.self) {
                    let n: CGFloat = CGFloat($0)
                    Circle()
                            .stroke(.black)
                            .frame(width: dia - increment * n, height: dia - increment * n, alignment: .center)
                }
            }.padding(.top, topSpace)
        }
    }
}

struct PolarView: View {
    var body: some View {
        ZStack {
            RadarRingsView(numRings: 6)
        }
    }
}



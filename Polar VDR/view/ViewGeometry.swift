//
// Created by William Kamp on 8/1/22.
//

import SwiftUI

extension View {
    func onSizeChangeBackground(_change: @escaping (CGSize) -> Void) -> Self {
        background(ViewGeometry())
                .onPreferenceChange(ViewSizeKey.self) {
                    _change($0)
                }
        return self
    }
}

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                    .preference(key: ViewSizeKey.self, value: geometry.size)
        }
    }
}

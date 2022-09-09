//
//  Polar_VDRApp.swift
//  Polar VDR
//
//  Created by William Kamp on 7/23/22.
//

import SwiftUI

@main
struct Polar_VDRApp: App {
    let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { t in
        globalTcpState.tick()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

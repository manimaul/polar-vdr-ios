//
//  ContentView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/23/22.
//

import SwiftUI

class Global: ObservableObject {
    @Published var boat: Boat = selectedBoat() {
        didSet {
            print("saving selected boat \(boat.name)")
            saveSelectedBoat(name: boat.name)
        }
    }
}

struct ContentView: View {
    @StateObject var global = Global()

    var body: some View {
        TabView {
            DashView().tabItem {
                Image(systemName: "speedometer")
                Text("Dash")
            }
            LogsView().tabItem {
                Image(systemName: "book")
                Text("Logs")
            }
            ChartView().tabItem {
                Image(systemName: "map")
                Text("Chart")
            }
            ConfigView().tabItem {
                Image(systemName: "wrench")
                Text("Config")
            }
        }.environmentObject(global)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

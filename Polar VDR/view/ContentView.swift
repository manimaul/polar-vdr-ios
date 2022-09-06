//
//  ContentView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/23/22.
//

import SwiftUI

struct NavDataEntry<T> {
    let data: T
    let time: Double
}

struct NavData {
    // speed through the water kts
    let stw: NavDataEntry<Double>? = NavDataEntry(data: 11.241, time: 0)

    // speed over ground kts
    let sog: NavDataEntry<Double>? = nil

    // apparent wind speed kts
    let aws: NavDataEntry<Double>? = nil

    // true wind speed
    let tws: NavDataEntry<Double>? = nil

    // true wind angle
    let twa: NavDataEntry<Angle>? = NavDataEntry(data: Angle(degrees: 90), time: 0)

    // apparent wind angle
    let awa: NavDataEntry<Angle>? = NavDataEntry(data: Angle(degrees: 82), time: 0)

    // true heading
    let hdg: NavDataEntry<Angle>? = NavDataEntry(data: Angle(degrees: 45), time: 0)
    let magnetic: Bool = true

    let cog: NavDataEntry<Angle>? = NavDataEntry(data: Angle(degrees: 30), time: 0)
}

class Global: ObservableObject {
    @Published var boat: Boat = selectedBoat() {
        didSet {
            print("saving selected boat \(boat.name)")
            saveSelectedBoat(name: boat.name)
        }
    }
    @Published var navData: NavData = NavData()
}

let globalState = Global()

struct ContentView: View {
    @StateObject var global = globalState

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

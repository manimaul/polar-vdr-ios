//
//  ContentView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/23/22.
//

import SwiftUI

struct LogsView: View {
    var body: some View {
        VStack {
            Text("All Logs")
        }
    }
}

struct DashView: View {
    var body: some View {
        VStack {
            Text("Dashboard")
        }
    }
}

struct ContentView: View {
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
            ConfigView().tabItem {
                Image(systemName: "wrench")
                Text("Config")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

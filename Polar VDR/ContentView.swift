//
//  ContentView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/23/22.
//

import SwiftUI

struct Config: View {
    var body: some View {
        VStack {
            Text("Config")
        }
    }
}

struct Logs: View {
    var body: some View {
        VStack {
            Text("All Logs")
        }
    }
}

struct Dash: View {
    var body: some View {
        VStack {
            Text("Dashboard")
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            Dash().tabItem {
                Image(systemName: "speedometer")
                Text("Dash")
            }
            Logs().tabItem {
                Image(systemName: "book")
                Text("Logs")
            }
            Config().tabItem {
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

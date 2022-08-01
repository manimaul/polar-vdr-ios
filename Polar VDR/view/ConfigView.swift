//
//  Config.swift
//  Polar VDR
//
//  Created by William Kamp on 7/24/22.
//

import SwiftUI

let userDefaults = UserDefaults.standard

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

var tcpNet: TcpNet? = nil

struct ConfigView: View {
    @State var hostName: String = userDefaults.string(forKey: "hostName") ?? ""
    @State var port: String = userDefaults.string(forKey: "port") ?? ""
    @State var sog: Bool = false
    @State var record: Bool = false
    @State var color: Color = .red

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Host", text: $hostName)
                            .keyboardType(.alphabet)
                    Text(":")
                    TextField("Port", text: $port)
                            .keyboardType(.decimalPad)
                }
                HStack {
                    Circle().fill(color).frame(width: 15, height: 15, alignment: .center)
                    Text("invalid")
                }
                //Toggle("Use SOG for STW", isOn: $sog)
            }
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button("Connect") {
                                hideKeyboard()
                                if let p = Int(port) {
                                    tcpNet = TcpNet(hostName: hostName, port: p)
                                }
                                userDefaults.set(hostName, forKey: "hostName")
                                userDefaults.set(port, forKey: "port")
                                tcpNet?.start()
                                record = true
                            }
                            Button("Record") {
                                tcpNet?.recording = true
                            }.disabled(!record)
                        }
                    }
                    .padding(.all)
        }
    }
}

//
//  Config.swift
//  Polar VDR
//
//  Created by William Kamp on 7/24/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

var tcpNet: TcpNet? = nil

struct ConfigView: View {
    @State var hostName: String = UserDefaults.standard.string(forKey: "hostName") ?? ""
    @State var port: String = UserDefaults.standard.string(forKey: "port") ?? ""
    @State var sog: Bool = false
    @State var record: Bool = false
    @State var color: Color = .red
    @State private var boat: String = selectedBoat().name

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Polar profile: ")
                    Picker("Strength", selection: $boat) {
                        ForEach(boatNames, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
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
            }.toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button("Connect") {
                                hideKeyboard()
                                if let p = Int(port) {
                                    tcpNet = TcpNet(hostName: hostName, port: p)
                                }
                                UserDefaults.standard.set(hostName, forKey: "hostName")
                                UserDefaults.standard.set(port, forKey: "port")
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

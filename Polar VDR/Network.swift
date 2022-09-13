//
//  Network.swift
//  Polar VDR
//
//  Created by William Kamp on 7/24/22.
//

import Foundation
import Network

struct TcpConnConfig {
    let host: String
    let port: Int
}

class TcpNet {
    private var connection: NWConnection? = nil
    private let records = Records()
    private var recording = false
    private let buffer = NmeaBuffer()
    private(set) var config: TcpConnConfig? = nil
    private(set) var state: NWConnection.State? = nil
    private(set) var validData: Bool = false

    func connect(hostName: String, port: Int) {
        let newConfig = TcpConnConfig(host: hostName, port: port)
        if newConfig.host != config?.host
                   && newConfig.port != config?.port
                   && newConfig.host.count > 0
        {
            let host = NWEndpoint.Host(hostName)
            if let port = NWEndpoint.Port("\(port)") {
                stop()
                connection = NWConnection(host: host, port: port, using: .tcp)
                connection?.stateUpdateHandler = didChange(state:)
                startReceive()
                connection?.start(queue: .main)
                print("connecting to \(newConfig.host):\(newConfig.port)")
                config = newConfig
            }
        }
    }

    func stop() {
        if let conn = connection {
            print("TCP connection stop")
            conn.cancel()
        }
        connection = nil
        config = nil
        state = nil
        globalTcpState.status = "disconnected"
        globalTcpState.color = .red
        globalTcpState.connected = false
    }

    private func didChange(state: NWConnection.State) {
        self.state = state
        switch state {
        case .setup:
            print("network is setup")
            globalTcpState.status = "setting up"
            globalTcpState.color = .red
            globalTcpState.connected = true
            break
        case .waiting(let error):
            print("network is waiting: \(error)")
            stop()
            break
        case .preparing:
            print("network is preparing")
            globalTcpState.status = "connecting"
            globalTcpState.color = .orange
            globalTcpState.connected = true
            break
        case .ready:
            print("network is setup")
            globalTcpState.status = "connected"
            globalTcpState.color = .yellow
            globalTcpState.connected = true
            break
        case .failed(let error):
            print("network failed, error: \(error)")
            stop()
        case .cancelled:
            print("network cancelled")
            stop()
        @unknown default:
            break
        }
    }

    private func startReceive() {
        connection?.receiveDiscontiguous(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isDone, error in
            self.buffer.append(data)
            if let error = error {
                print("did receive, error: \(error)")
                self.stop()
                return
            }
            if isDone {
                print("did receive, EOF")
                self.stop()
                return
            }
            self.startReceive()
        }
    }

    func send(line: String) {
        let data = Data("\(line)\r\n".utf8)
        connection?.send(content: data, completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                print("did send, error: \(error)")
                self.stop()
            } else {
                print("did send, data: \(data as NSData)")
            }
        })
    }
}

//
//  Network.swift
//  Polar VDR
//
//  Created by William Kamp on 7/24/22.
//

import Foundation
import Network

class TcpNet {

    let connection: NWConnection
    let records = Records()
    var recording = false

    init(hostName: String, port: Int) {
        let host = NWEndpoint.Host(hostName)
        let port = NWEndpoint.Port("\(port)")!
        connection = NWConnection(host: host, port: port, using: .tcp)
    }

    func start() {
        print("will start")
        connection.stateUpdateHandler = didChange(state:)
        startReceive()
        connection.start(queue: .main)
    }

    func stop() {
        connection.cancel()
        print("did stop")
    }

    private func didChange(state: NWConnection.State) {
        switch state {
        case .setup:
            break
        case .waiting(let error):
            print("is waiting: \(error)")
        case .preparing:
            break
        case .ready:
            break
        case .failed(let error):
            print("did fail, error: \(error)")
            stop()
        case .cancelled:
            print("was cancelled")
            stop()
        @unknown default:
            break
        }
    }

    private func startReceive() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isDone, error in
            if var nmea = NmeaParts(data: data) {
                if (self.recording && nmea.isValid) {
                    self.records.insert(nmea: nmea)
                }
            }
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
        connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                print("did send, error: \(error)")
                self.stop()
            } else {
                print("did send, data: \(data as NSData)")
            }
        })
    }
}

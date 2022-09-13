//
// Created by William Kamp on 9/12/22.
//

import Foundation

class NmeaBuffer {
    private let processor = NmeaProcessor()
    var buffer = [UInt8](repeating: 0, count: nmeaMaxLen)
    var cursor: Int = 0

    func append(_ data: DispatchData?) {
        guard let data = data else { return }
        for i in 0...data.count - 1 {
            let byte = data[i]
            if byte == nmeaBeginDollar || byte == nmeaBeginExclam {
                flush()
            }
            buffer[cursor] = byte
            if byte == nmeaReturn || byte == nmeaNewLine {
                flush()
            }
            cursor += 1
            if cursor >= nmeaMaxLen {
                flush()
            }
        }
    }

    func flush() {
        if cursor > 0 {
            if let parts = NmeaParts(data: Data(buffer[0..<cursor])) {
                processor.process(parts: parts)
            }
            cursor = 0
        }
    }
}

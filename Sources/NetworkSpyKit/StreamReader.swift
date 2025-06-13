//
//  StreamReader.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

final class StreamReader {

    enum Error: Swift.Error {
        case readFailed
    }

    private static let bufferSize = 1024

    static func readAllData(of stream: InputStream) throws -> Data {
        let buffer = createBuffer()

        defer {
            buffer.deallocate()
        }

        return try readAllData(of: stream, using: buffer)
    }

    private static func createBuffer() -> UnsafeMutablePointer<UInt8> {
        return UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    }

    static func readAllData(of stream: InputStream,
                            using buffer: UnsafeMutablePointer<UInt8>) throws -> Data {
        stream.open()

        defer {
            stream.close()
        }

        var data = Data()
        while stream.hasBytesAvailable {
            let readBytes = stream.read(buffer, maxLength: bufferSize)

            switch readBytes {
                case ..<0:
                    throw Error.readFailed
                case 0:
                    // End of stream
                   break
                default:
                    data.append(buffer, count: readBytes)
            }
        }

        return data
    }
}

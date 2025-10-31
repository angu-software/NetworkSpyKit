//
//  HTTPMessageParser.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

struct HTTPMessageParser {

    func components(from httpMessage: String) -> HTTPMessageComponents? {
        guard let startLine = StartLineParser().startLine(from: httpMessage)
        else {
            return nil
        }

        return HTTPMessageComponents(startLine: startLine)
    }
}

private struct StartLineParser {

    private let space = " "

    func startLine(from string: String) -> HTTPMessageComponents.StartLine? {
        guard let firstLine = string.components(separatedBy: .newlines).first
        else {
            return nil
        }

        let lineComponents = firstLine.components(separatedBy: space)

        if let statusLine = makeStatusLine(lineComponents: lineComponents) {
            return statusLine
        } else {
            return makeRequestLine(lineComponents: lineComponents)
        }
    }

    private func makeStatusLine(lineComponents: [String]) -> HTTPMessageComponents.StartLine? {
        guard let statusCode = lineComponents.compactMap({ Int($0) }).first
        else {
            return nil
        }

        guard let httpVersion =
                Int(lineComponents.first!) == nil ? lineComponents.first! : nil else {
            return nil
        }

        return .statusLine(
            httpVersion: httpVersion,
            statusCode: statusCode,
            reason: nil
        )
    }

    private func makeRequestLine(lineComponents: [String]) -> HTTPMessageComponents.StartLine? {
        guard lineComponents.count >= 2 else {
            return nil
        }

        let method = lineComponents[0]
        let absolutePath = lineComponents[1]

        guard let httpVersion = lineComponents.count == 3 ? lineComponents[2] : nil else {
            return nil
        }

        return .requestLine(
            method: method,
            absolutePath: absolutePath,
            httpVersion: httpVersion
        )
    }
}

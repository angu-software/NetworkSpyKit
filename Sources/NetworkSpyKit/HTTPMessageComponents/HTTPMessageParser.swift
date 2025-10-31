//
//  HTTPMessageParser.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

// none-strict mode
// defaults for required fileds

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

    func startLine(from string: String) -> HTTPMessageComponents.StartLine? {
        guard let startLineElements = makeLineElements(string: string) else {
            return nil
        }

        if let statusLine = makeStatusLine(lineElements: startLineElements) {
            return statusLine
        } else {
            return makeRequestLine(lineElements: startLineElements)
        }
    }

    // HTTPMessage start line has max three elements separated by spaces
    private func makeLineElements(string: String) -> [String]? {
        guard let firstLine = string.components(separatedBy: .newlines).first
        else {
            return nil
        }

        return firstLine.split(separator: " ", maxSplits: 2).map { "\($0)"}
    }

    private func makeRequestLine(lineElements: [String])
        -> HTTPMessageComponents.StartLine?
    {
        guard let method = lineElements.element(at: 0),
            let absolutePath = lineElements.element(at: 1),
            let httpVersion = lineElements.element(at: 2)
        else {
            return nil
        }

        return .requestLine(
            method: method,
            absolutePath: absolutePath,
            httpVersion: httpVersion
        )
    }

    private func makeStatusLine(lineElements: [String])
        -> HTTPMessageComponents.StartLine?
    {
        guard let httpVersion = lineElements.element(at: 0),
            let statusCode = makeStatusCode(string: lineElements.element(at: 1))
        else {
            return nil
        }

        let reasonPhrase = lineElements.element(at: 2) ?? ""

        return .statusLine(
            httpVersion: httpVersion,
            statusCode: statusCode,
            reason: reasonPhrase.isEmpty ? nil : reasonPhrase
        )
    }

    private func makeStatusCode(string: String?) -> Int? {
        guard let string else {
            return nil
        }

        return Int(string)
    }
}

extension Array {

    func element(at index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}

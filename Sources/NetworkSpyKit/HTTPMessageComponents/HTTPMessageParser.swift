//
//  HTTPMessageParser.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

// none-strict mode
// defaults for required fields

struct HTTPMessageParser {

    func components(from httpMessage: String) -> HTTPMessageComponents? {
        var messageLines = httpMessage.lines
        let startLine = messageLines.removeFirst()
        let fieldLines = messageLines

        guard let startLine = StartLineParser().startLine(from: startLine)
        else {
            return nil
        }

        var messageComponents = HTTPMessageComponents(startLine: startLine)
        messageComponents.headerFields = makeHeaderFields(fieldLines: fieldLines)

        return messageComponents
    }

    private func makeHeaderFields(fieldLines: [String]) -> [String: String]? {
        var headerFields: [String: String] = [:]
        for line in fieldLines {
            let fieldElements = line.split(separator: ":", maxSplits: 1).map { "\($0)" }
            guard let key = fieldElements.element(at: 0)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let value = fieldElements.element(at: 1)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                continue
            }

            headerFields[key] = value
        }

        return headerFields.isEmpty ? nil : headerFields
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

    private func firstLine(of string: String) -> String? {
        return string.components(separatedBy: .newlines).first
    }

    // HTTPMessage start line has max three elements separated by spaces
    private func makeLineElements(string: String) -> [String]? {
        guard let firstLine = firstLine(of: string)
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

extension String {

    var lines: [String] {
        return components(separatedBy: .newlines)
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

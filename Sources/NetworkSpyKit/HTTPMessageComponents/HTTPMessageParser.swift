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

    private let emptyLine = "\n\n"

    func components(from httpMessage: String) -> HTTPMessageComponents? {
        guard let messageParts = MessageParts(string: httpMessage),
              let startLine = makeStartLine(string: messageParts.startLine) else {
            return nil
        }

        var messageComponents = HTTPMessageComponents(startLine: startLine)
        messageComponents.headerFields = makeHeaderFields(fieldLines: messageParts.fieldLines)
        messageComponents.body = messageParts.body?.data(using: .utf8)

        return messageComponents
    }

    private func makeStartLine(string: String) -> HTTPMessageComponents.StartLine? {
        return StartLineParser().startLine(from: string)
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

struct MessageParts {

    let message: String
    let body: String?

    var startLine: String {
        var messageLines = messageLines
        return messageLines.removeFirst()
    }

    var fieldLines: [String] {
        var messageLines = messageLines
        _ = messageLines.removeFirst()
        return messageLines
    }

    private static let emptyLine = "\n\n"

    private var messageLines: [String] {
        return message.lines
    }

    init?(string: String) {
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        guard let messagePart = scanner.scanUpToString(Self.emptyLine) else {
            return nil
        }

        _ = scanner.scanString(Self.emptyLine)
        let bodyPart = scanner.string[scanner.currentIndex...]

        self.init(message: messagePart,
                  body: bodyPart.isEmpty ? nil : String(bodyPart))
    }

    private init(message: String,
                 body: String?) {
        self.message = message
        self.body = body
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

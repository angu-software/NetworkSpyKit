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
        guard let messageParts = MessageStringParts(string: httpMessage),
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

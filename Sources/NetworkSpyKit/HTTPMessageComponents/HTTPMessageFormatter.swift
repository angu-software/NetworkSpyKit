//
//  HTTPMessageFormatter.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

struct HTTPMessageFormatter {

    private let newLine = "\n"
    private var startLine = HTTPMessageComponents.StartLine()

    func string(from components: HTTPMessageComponents) -> String {
        return makeHTTPMessageFormat(components: components)
    }

    // ✅ HTTP-message = start-line CRLF *( field-line CRLF ) CRLF [ message-body ]
    func makeHTTPMessageFormat(components: HTTPMessageComponents) -> String {
        return [
            makeStartLine(components: components),
            makeFieldLines(components: components),
            makeMessageBody(components: components),
        ]
        .compactMap { $0 }
        .joined(separator: newLine)
    }

    private func makeStartLine(components: HTTPMessageComponents) -> String? {
        return components.startLine.format()
    }

    // ✅ field-line = field-name ":" OWS field-value OWS
    // ✅ field-name = <field-name, see [HTTP], Section 5.1>
    // ✅ field-value = <field-value, see [HTTP], Section 5.5>
    private func makeFieldLines(components: HTTPMessageComponents) -> String? {
        guard let headerFields = components.headerFields,
            headerFields.isEmpty == false
        else {
            return nil
        }

        return
            headerFields
            .map { "\($0.key): \($0.value)" }
            .sorted()
            .joined(separator: newLine)
    }

    // ✅ message-body = *OCTET
    private func makeMessageBody(components: HTTPMessageComponents) -> String? {
        guard let body = components.body,
            let bodyString = String(data: body, encoding: .utf8)
        else {
            return nil
        }

        return [
            newLine,
            bodyString,
        ]
        .joined()
    }
}

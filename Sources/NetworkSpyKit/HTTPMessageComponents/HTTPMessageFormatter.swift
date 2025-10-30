//
//  HTTPMessageFormatter.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

struct HTTPMessageFormatter {

    // request-line
    var method: String? {
        get {
            startLine.method
        }
        set {
            startLine.method = newValue
        }
    }

    var absolutePath: String? {
        get {
            startLine.absolutePath
        }

        set {
            startLine.absolutePath = newValue
        }
    }

    // status-line
    var statusCode: Int? {
        get {
            startLine.statusCode
        }
        set {
            startLine.statusCode = newValue
        }
    }

    var statusReason: String? {
        get {
            startLine.statusReason
        }
        set {
            startLine.statusReason = newValue
        }
    }

    var httpVersion: String? {
        get {
            startLine.httpVersion
        }
        set {
            startLine.httpVersion = newValue
        }
    }

    var headerFields: [String: String]?
    var body: Data?

    private let newLine = "\n"
    private var startLine = HTTPMessageComponents.StartLine()

    // TODO: rename to string(from:)
    // ✅ HTTP-message = start-line CRLF *( field-line CRLF ) CRLF [ message-body ]
    func httpMessageFormat() -> String {
        return [
            startLine.format(),
            fieldLines(),
            messageBody(),
        ]
        .compactMap { $0 }
        .joined(separator: newLine)
    }

    // ✅ field-line = field-name ":" OWS field-value OWS
    // ✅ field-name = <field-name, see [HTTP], Section 5.1>
    // ✅ field-value = <field-value, see [HTTP], Section 5.5>
    private func fieldLines() -> String? {
        guard let headerFields,
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
    private func messageBody() -> String? {
        guard let body,
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

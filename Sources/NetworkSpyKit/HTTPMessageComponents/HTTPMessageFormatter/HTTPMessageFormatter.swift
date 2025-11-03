//
//  HTTPMessageFormatter.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

struct HTTPMessageFormatter {

    private let space = " "
    private let newLine = "\n"

    /// - Note: Header fields are sorted in the formatted message
    func string(from components: HTTPMessageComponents) -> String {
        return makeHTTPMessageFormat(components: components)
    }

    // ✅ HTTP-message = start-line CRLF *( field-line CRLF ) CRLF [ message-body ]
    private func makeHTTPMessageFormat(components: HTTPMessageComponents)
        -> String
    {
        return [
            makeStartLine(components: components),
            makeFieldLines(components: components),
            makeMessageBody(components: components),
        ]
        .compactMap { $0 }
        .joined(separator: newLine)
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

    private func isStatusLine(components: HTTPMessageComponents) -> Bool {
        switch components.startLine {
        case .statusLine:
            return true
        case .requestLine:
            return false
        }
    }

    // ✅ start-line = request-line / status-line
    private func makeStartLine(components: HTTPMessageComponents) -> String? {
        if isStatusLine(components: components) {
            return makeStatusLine(components: components)
        }

        return makeRequestLine(components: components)
    }

    // ✅ request-line = method SP request-target SP HTTP-version
    private func makeRequestLine(components: HTTPMessageComponents) -> String? {
        return [
            makeMethodToken(components: components),
            makeRequestTarget(components: components),
            makeHTTPVersionToken(components: components),
        ]
        .compactMap { $0 }
        .joined(separator: space)
    }

    // request-target = origin-form / absolute-form / authority-form / asterisk-form
    // ✅ origin-form = absolute-path [ "?" query ]
    // ✅ absolute-path = <absolute-path, see [HTTP], Section 4.1>
    // ✅ query = <query, see [URI], Section 3.4>
    private func makeRequestTarget(components: HTTPMessageComponents) -> String?
    {
        guard let absolutePath = components.startLine.absolutePath else {
            return nil
        }

        return absolutePath.isEmpty ? "/" : absolutePath
    }

    // method = token
    private func makeMethodToken(components: HTTPMessageComponents) -> String? {
        return components.startLine.method?.uppercased()
    }

    // status-line = HTTP-version SP status-code SP [ reason-phrase ]
    private func makeStatusLine(components: HTTPMessageComponents) -> String? {
        return [
            makeHTTPVersionToken(components: components),
            makeStatusCodeToken(components: components),
            makeStatusReasonPhrase(components: components),
        ]
        .compactMap { $0 }
        .joined(separator: space)
    }

    // status-code = 3DIGIT
    private func makeStatusCodeToken(components: HTTPMessageComponents)
        -> String?
    {
        guard let statusCode = components.startLine.statusCode else {
            return nil
        }

        return "\(statusCode)"
    }

    // reason-phrase = 1*( HTAB / SP / VCHAR / obs-text )
    private func makeStatusReasonPhrase(components: HTTPMessageComponents)
        -> String?
    {
        return components.startLine.statusReason
    }

    // HTTP-version = HTTP-name "/" DIGIT "." DIGIT
    // HTTP-name = %x48.54.54.50 ; HTTP
    private func makeHTTPVersionToken(components: HTTPMessageComponents)
        -> String?
    {
        return components.startLine.httpVersion
    }
}

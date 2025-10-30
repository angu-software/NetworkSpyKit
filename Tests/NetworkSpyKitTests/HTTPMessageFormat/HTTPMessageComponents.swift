//
//  HTTPMessageComponents.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation
import Testing

struct HTTPMessageComponents {

    // https://www.rfc-editor.org/rfc/rfc9112.pdf
    // HTTP-message = HTTP-message = start-line CRLF *( field-line CRLF ) CRLF [ message-body ]

    // start-line = request-line / status-line
    // request-line = method SP request-target SP HTTP-version
    // method = token
    // request-target = origin-form / absolute-form / authority-form / asterisk-form
    // HTTP-version = HTTP-name "/" DIGIT "." DIGIT
    // HTTP-name = %x48.54.54.50 ; HTTP

    // field-line = field-name ":" OWS field-value OWS
    // field-name = <field-name, see [HTTP], Section 5.1>
    // field-value = <field-value, see [HTTP], Section 5.5>

    // message-body = *OCTET

    var url: URL?
    var headerFields: [String: String]?

    private let newLine = "\n"

    func httpMessageFormat() -> String {
        return [
            requestTarget(),
            fieldLines(),
        ]
        .compactMap { $0 }
        .joined(separator: newLine)
    }

    private func requestTarget() -> String? {
        // request-target = origin-form / absolute-form / authority-form / asterisk-form
        // origin-form = absolute-path [ "?" query ]
        // ✅ absolute-path = <absolute-path, see [HTTP], Section 4.1>
        // query = <query, see [URI], Section 3.4>
        guard let url else {
            return nil
        }

        return url.path
    }

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
}

struct HTTPMessageComponentsFormattingTests {

    private let url = URL(string: "https://www.rfc-editor.org/rfc/rfc9112.pdf")
    private let headerFields = [
        "User-Agent": "NetworkSpyKit/1.0",
        "Accept": "application/json",
        "Accept-Language": "en-US,en;q=0.9",
    ]

    @Test
    func givenNothing_itReturnsEmptyString() {
        let components = HTTPMessageComponents()

        #expect(components.httpMessageFormat().isEmpty)
    }

    // MARK: request-target: origin-form

    @Test
    func givenURL_itIncludesAbsolutePath() {
        var components = HTTPMessageComponents()
        components.url = url

        #expect(
            components.httpMessageFormat() == """
                /rfc/rfc9112.pdf
                """
        )
    }

    @Test
    func givenHeaderFields_itIncludesFieldLines() {
        var components = HTTPMessageComponents()
        components.url = url
        components.headerFields = headerFields

        #expect(
            components.httpMessageFormat() == """
                /rfc/rfc9112.pdf
                Accept-Language: en-US,en;q=0.9
                Accept: application/json
                User-Agent: NetworkSpyKit/1.0
                """
        )
    }
}

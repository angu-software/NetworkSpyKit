//
//  HTTPMessageComponents.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation
import Testing

struct HTTPMessageComponents {

    struct StartLine {

        enum RequestTargetForm {
            case origin
        }

        private let space = " "

        var requestTargetForm: RequestTargetForm = .origin

        // request-line
        var method: String?
        var url: URL?

        // status-line
        var statusCode: Int?
        var statusReason: String?

        var httpVersion: String?

        var isStatusLine: Bool {
            return statusCode != nil
        }

        // ✅ start-line = request-line / status-line
        func format() -> String? {
            if isStatusLine {
                return statusLine()
            }

            return requestLine()
        }

        // ✅ request-line = method SP request-target SP HTTP-version
        private func requestLine() -> String? {
            return [
                methodToken(),
                requestTarget(),
                httpVersionToken(),
            ]
            .compactMap { $0 }
            .joined(separator: space)
        }

        // request-target = origin-form / absolute-form / authority-form / asterisk-form
        // ✅ origin-form = absolute-path [ "?" query ]
        // ✅ absolute-path = <absolute-path, see [HTTP], Section 4.1>
        // ✅ query = <query, see [URI], Section 3.4>

        // absolute-form = absolute-URI
        // absolute-URI = <absolute-URI, see [URI], Section 4.3>

        // authority-form = uri-host ":" port
        // uri-host = <host, see [URI], Section 3.2.2>
        // port = <port, see [URI], Section 3.2.3>

        // asterisk-form = "*"
        private func requestTarget() -> String? {
            guard let url else {
                return nil
            }

            return url.path
        }

        // method = token
        private func methodToken() -> String? {

            guard let method else {
                return nil
            }

            return method.uppercased()
        }

        // status-line = HTTP-version SP status-code SP [ reason-phrase ]
        private func statusLine() -> String? {
            return [
                httpVersionToken(),
                statusCodeToken(),
                statusReasonPhrase(),
            ]
            .compactMap { $0 }
            .joined(separator: space)
        }

        // status-code = 3DIGIT
        private func statusCodeToken() -> String? {
            guard let statusCode else {
                return nil
            }

            return "\(statusCode)"
        }

        // reason-phrase = 1*( HTAB / SP / VCHAR / obs-text )
        private func statusReasonPhrase() -> String? {
            guard let statusReason else {
                return nil
            }

            return statusReason
        }

        // HTTP-version = HTTP-name "/" DIGIT "." DIGIT
        // HTTP-name = %x48.54.54.50 ; HTTP
        private func httpVersionToken() -> String? {
            guard let httpVersion else {
                return nil
            }

            return httpVersion
        }
    }

    // https://www.rfc-editor.org/rfc/rfc9112.pdf
    // request-target = origin-form / absolute-form / authority-form / asterisk-form

    // request-line
    var requestTargetForm: StartLine.RequestTargetForm {
        get {
            startLine.requestTargetForm
        }
        set {
            startLine.requestTargetForm = newValue
        }
    }

    var method: String? {
        get {
            startLine.method
        }
        set {
            startLine.method = newValue
        }
    }

    var url: URL? {
        get {
            startLine.url
        }
        set {
            startLine.url = newValue
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
    private var startLine = StartLine()

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
        var fields: [String] = []
        if let host = url?.host {
            fields.append("Host: \(host)")
        }

        if let headerFields {

            fields +=
                headerFields
                .map { "\($0.key): \($0.value)" }
        }

        guard fields.isEmpty == false else {
            return nil
        }

        return
            fields
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

struct HTTPMessageComponentsFormattingTests {

    private let httpVersion = "HTTP/1.1"
    private let method = "PosT"
    private let url = URL(string: "https://www.rfc-editor.org/rfc/rfc9112.pdf")

    private let statusCode = 404
    private let statusReason = "NOT FOUND"

    private let headerFields = [
        "User-Agent": "NetworkSpyKit/1.0",
        "Accept": "application/json",
        "Accept-Language": "en-US,en;q=0.9",
    ]
    private let body: Data? = #"{ "Hello World" }"#.data(using: .utf8)

    @Test
    func givenNothing_itReturnsEmptyString() {
        let components = HTTPMessageComponents()

        #expect(components.httpMessageFormat().isEmpty)
    }

    // MARK: - Request Message

    // must always contain Host: field

    // MARK: request-target: origin-form

    // / when no path specified

    @Test
    func requestMessage_originForm_givenURLWithPath_itIncludesAbsolutePathAndHost() {
        var components = HTTPMessageComponents()
        components.url = url

        #expect(
            components.httpMessageFormat() == """
                /rfc/rfc9112.pdf
                Host: www.rfc-editor.org
                """
        )
    }

    @Test
    func givenMethod_itIncludesMethod() async throws {
        var components = HTTPMessageComponents()
        components.method = method
        components.url = url

        #expect(
            components.httpMessageFormat() == """
                POST /rfc/rfc9112.pdf
                Host: www.rfc-editor.org
                """
        )
    }

    @Test
    func givenHTTPVersion_itIncludesHTTPVersion() async throws {
        var components = HTTPMessageComponents()
        components.method = method
        components.url = url
        components.httpVersion = httpVersion

        #expect(
            components.httpMessageFormat() == """
                POST /rfc/rfc9112.pdf HTTP/1.1
                Host: www.rfc-editor.org
                """
        )
    }

    // MARK: - Response Message

    @Test
    func responseMessage_givenStatusCode_itIncludesStatusCode() {
        var components = HTTPMessageComponents()
        components.statusCode = statusCode

        #expect(
            components.httpMessageFormat() == """
                404
                """
        )
    }

    @Test
    func responseMessage_givenHttpVersion_itIncludesHTTPVersion() {
        var components = HTTPMessageComponents()
        components.statusCode = statusCode
        components.httpVersion = httpVersion

        #expect(
            components.httpMessageFormat() == """
                HTTP/1.1 404
                """
        )
    }

    @Test
    func responseMessage_givenStatusReason_itIncludesStatusReason() {
        var components = HTTPMessageComponents()
        components.httpVersion = httpVersion
        components.statusCode = statusCode
        components.statusReason = statusReason

        #expect(
            components.httpMessageFormat() == """
                HTTP/1.1 404 NOT FOUND
                """
        )
    }

    // MARK: - Message type agnostic

    @Test
    func givenHeaderFields_itIncludesFieldLines() {
        var components = HTTPMessageComponents()
        components.method = method
        components.url = url
        components.headerFields = headerFields

        #expect(
            components.httpMessageFormat() == """
                POST /rfc/rfc9112.pdf
                Accept-Language: en-US,en;q=0.9
                Accept: application/json
                Host: www.rfc-editor.org
                User-Agent: NetworkSpyKit/1.0
                """
        )
    }

    @Test
    func givenBody_itIncludesMessageBody() {
        var components = HTTPMessageComponents()
        components.method = method
        components.url = url
        components.headerFields = headerFields
        components.body = body

        #expect(
            components.httpMessageFormat() == #"""
                POST /rfc/rfc9112.pdf
                Accept-Language: en-US,en;q=0.9
                Accept: application/json
                Host: www.rfc-editor.org
                User-Agent: NetworkSpyKit/1.0

                { "Hello World" }
                """#
        )
    }
}

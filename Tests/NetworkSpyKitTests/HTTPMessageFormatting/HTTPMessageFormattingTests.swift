//
//  HTTPMessageFormattingTests.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct HTTPMessageComponentsFormattingTests {

    @Test
    func givenRequestLine_itFormatsRequestMessage() {
        let components = makeComponents()

        #expect(
            format(components) == """
                POST /rfc/rfc9112.pdf HTTP/1.1
                """
        )
    }

    @Test
    func givenRequestLineWithEmptyPath_itFormatsRequestMessageWithRootPath() {
        let components = makeComponents(
            startLine: makeStartLine(
                method: "GET",
                absolutePath: ""
            )
        )

        #expect(
            format(components) == """
                GET / HTTP/1.1
                """
        )
    }

    @Test
    func givenStatusLine_itFormatsStatusMessage() {
        let components = makeComponents(
            startLine: makeStartLine(statusCode: 404)
        )

        #expect(
            format(components) == """
                HTTP/1.1 404
                """
        )
    }

    @Test
    func givenStatusLineWithReason_itFormatsStatusMessageWithReasonPhrase() {
        let components = makeComponents(
            startLine: makeStartLine(
                statusCode: 404,
                reasonPhrase: "NOT FOUND"
            )
        )

        #expect(
            format(components) == """
                HTTP/1.1 404 NOT FOUND
                """
        )
    }

    @Test
    func givenHeaderFields_itFormatsIncludingFieldLines() {
        let components = makeComponents(
            headerFields: [
                "User-Agent": "NetworkSpyKit/1.0",
                "Accept": "application/json",
                "Accept-Language": "en-US,en;q=0.9",
            ]
        )

        #expect(
            format(components) == """
                POST /rfc/rfc9112.pdf HTTP/1.1
                Accept-Language: en-US,en;q=0.9
                Accept: application/json
                User-Agent: NetworkSpyKit/1.0
                """
        )
    }

    @Test
    func givenBody_itFormatsIncludingMessageBody() {
        let components = makeComponents(
            body: #"{ "Hello World" }"#.data(using: .utf8)
        )

        #expect(
            format(components) == #"""
                POST /rfc/rfc9112.pdf HTTP/1.1

                { "Hello World" }
                """#
        )
    }

    // MARK: Test Support

    private func format(_ components: HTTPMessageComponents) -> String {
        let formatter = HTTPMessageFormatter()

        return formatter.string(from: components)
    }

    private func makeStartLine(
        method: String = "POST",
        absolutePath: String = "/rfc/rfc9112.pdf",
        httpVersion: String = "HTTP/1.1"
    ) -> HTTPMessageComponents.StartLine {
        return .requestLine(
            method: method,
            absolutePath: absolutePath,
            httpVersion: httpVersion
        )
    }

    private func makeStartLine(
        httpVersion: String = "HTTP/1.1",
        statusCode: Int,
        reasonPhrase: String? = nil
    ) -> HTTPMessageComponents.StartLine {
        return .statusLine(
            httpVersion: httpVersion,
            statusCode: statusCode,
            reason: reasonPhrase
        )
    }

    private func makeComponents(
        startLine: HTTPMessageComponents.StartLine? = nil,
        headerFields: [String: String]? = nil,
        body: Data? = nil
    ) -> HTTPMessageComponents {
        let startLine = startLine ?? makeStartLine()

        return HTTPMessageComponents(
            startLine: startLine,
            headerFields: headerFields,
            body: body
        )

    }
}

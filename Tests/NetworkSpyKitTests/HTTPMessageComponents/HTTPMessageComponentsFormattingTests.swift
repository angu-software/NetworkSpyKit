//
//  HTTPMessageComponents.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

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

    // MARK: request-target: origin-form

    @Test
    func requestMessage_originForm_givenURLWithoutPath_itIncludesRootPath() {
        var components = HTTPMessageComponents()
        components.url = URL(string: "https://www.rfc-editor.org")

        #expect(
            components.httpMessageFormat() == """
                /
                Host: www.rfc-editor.org
                """
        )
    }

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

//
//  HTTPMessageFormattingTests.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

// TODO: formatter for convenient creation of components
// ensures the header and target format are set correctly

struct HTTPMessageComponentsFormattingTests {

    private let httpVersion = "HTTP/1.1"
    private let method = "PosT"
    private let absolutePath = "/rfc/rfc9112.pdf"

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
        let components = makeComponents()

        #expect(format(components).isEmpty)
    }

    // MARK: - Request Message

    // MARK: request-target: origin-form

    @Test
    func requestMessage_givenEmptyAbsolutePath_itIncludesRootPath() {
        let components = makeComponents(
            absolutePath: ""
        )

        #expect(
            format(components) == """
                /
                """
        )
    }

    @Test
    func requestMessage_givenAbsolutePath_itIncludesAbsolutePath() {
        let components = makeComponents(
            absolutePath: absolutePath
        )

        #expect(
            format(components) == """
                /rfc/rfc9112.pdf
                """
        )
    }

    @Test
    func givenMethod_itIncludesMethod() async throws {
        let components = makeComponents(
            method: method,
            absolutePath: absolutePath
        )

        #expect(
            format(components) == """
                POST /rfc/rfc9112.pdf
                """
        )
    }

    @Test
    func givenHTTPVersion_itIncludesHTTPVersion() async throws {
        let components = makeComponents(
            method: method,
            absolutePath: absolutePath,
            httpVersion: httpVersion
        )

        #expect(
            format(components) == """
                POST /rfc/rfc9112.pdf HTTP/1.1
                """
        )
    }

    // MARK: - Response Message

    @Test
    func responseMessage_givenStatusCode_itIncludesStatusCode() {
        let components = makeComponents(
            statusCode: statusCode
        )

        #expect(
            format(components) == """
                404
                """
        )
    }

    @Test
    func responseMessage_givenHttpVersion_itIncludesHTTPVersion() {
        let components = makeComponents(
            httpVersion: httpVersion,
            statusCode: statusCode
        )

        #expect(
            format(components) == """
                HTTP/1.1 404
                """
        )
    }

    @Test
    func responseMessage_givenStatusReason_itIncludesStatusReason() {
        let components = makeComponents(
            httpVersion: httpVersion,
            statusCode: statusCode,
            statusReason: statusReason
        )

        #expect(
            format(components) == """
                HTTP/1.1 404 NOT FOUND
                """
        )
    }

    // MARK: - Message type agnostic

    @Test
    func givenHeaderFields_itIncludesFieldLines() {
        let components = makeComponents(
            method: method,
            absolutePath: absolutePath,
            headerFields: headerFields
        )

        #expect(
            format(components) == """
                POST /rfc/rfc9112.pdf
                Accept-Language: en-US,en;q=0.9
                Accept: application/json
                User-Agent: NetworkSpyKit/1.0
                """
        )
    }

    @Test
    func givenBody_itIncludesMessageBody() {
        let components = makeComponents(
            method: method,
            absolutePath: absolutePath,
            headerFields: headerFields,
            body: body
        )

        #expect(
            format(components) == #"""
                POST /rfc/rfc9112.pdf
                Accept-Language: en-US,en;q=0.9
                Accept: application/json
                User-Agent: NetworkSpyKit/1.0

                { "Hello World" }
                """#
        )
    }

    // MARK: Test Support

    private func format(_ components: HTTPMessageComponents) -> String {
        let formatter = HTTPMessageFormatter()

        return formatter.string(from: components)
    }

    private func makeComponents(
        method: String? = nil,
        absolutePath: String? = nil,
        httpVersion: String? = nil,
        statusCode: Int? = nil,
        statusReason: String? = nil,
        headerFields: [String: String]? = nil,
        body: Data? = nil
    ) -> HTTPMessageComponents {

        let startLine: HTTPMessageComponents.StartLine
        if let statusCode {
            startLine = .statusLine(
                httpVersion: httpVersion,
                statusCode: statusCode,
                reason: statusReason
            )
        } else {
            startLine = .requestLine(
                method: method,
                absolutePath: absolutePath,
                httpVersion: httpVersion
            )
        }

        return HTTPMessageComponents(
            startLine: startLine,
            headerFields: headerFields,
            body: body
        )

    }
}

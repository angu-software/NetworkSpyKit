//
//  HTTPMessageParserTests.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Testing

@testable import NetworkSpyKit

struct HTTPMessageParserTests {

    @Test
    func givenEmptyString_whenParsing_itReturnsNil()
        async throws
    {
        #expect(parse("") == nil)
    }

    // MARK: Request line

    @Test
    func givenRequestMessageWithMissingPath_whenParsing_itReturnsNil()
        async throws
    {
        let message = """
            POST
            """

        #expect(parse(message) == nil)
    }

    @Test
    func
        givenRequestMessage_whenParsing_itBuildsRequestLine()
        async throws
    {
        let message = """
            POST /hello/world?when=fr&who=all HTTP/1.1
            """

        #expect(
            parse(message)?.startLine
                == .requestLine(
                    method: "POST",
                    absolutePath: "/hello/world?when=fr&who=all",
                    httpVersion: "HTTP/1.1"
                )
        )
    }

    // MARK: Status line

    @Test
    func
        givenStatusMessage_whenParsing_itBuildsStatusLine()
        async throws
    {
        let message = """
            HTTP/1.1 404
            """

        #expect(
            parse(message)?.startLine
                == .statusLine(
                    httpVersion: "HTTP/1.1",
                    statusCode: 404,
                    reason: nil
                )
        )
    }

    @Test
    func
        givenStatusMessageWithReason_whenParsing_itBuildsStatusLineWithReasonPhrase()
        async throws
    {
        let message = """
            HTTP/1.1 404 NOT FOUND
            """

        #expect(
            parse(message)?.startLine
                == .statusLine(
                    httpVersion: "HTTP/1.1",
                    statusCode: 404,
                    reason: "NOT FOUND"
                )
        )
    }

    @Test
    func givenFields_whenParsing_itBuildsHeaderFields() async throws {
        let message = """
            HTTP/1.1 404 NOT FOUND
            Accept-Language: en-US,en;q=0.9
            Accept: application/json
            User-Agent: NetworkSpyKit/1.0
            """

        #expect(
            parse(message)?.headerFields == [
                "Accept-Language": "en-US,en;q=0.9",
                "Accept": "application/json",
                "User-Agent": "NetworkSpyKit/1.0",
            ]
        )
    }

    private func parse(_ message: String) -> HTTPMessageComponents? {
        let parser = HTTPMessageParser()

        return parser.components(from: message)
    }
}

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
        let parser = HTTPMessageParser()

        #expect(parser.components(from: "") == nil)
    }

    // MARK: Request line

    @Test
    func givenRequestMessageWithMissingPath_whenParsing_itReturnsNil()
        async throws
    {
        let message = """
            POST
            """

        let parser = HTTPMessageParser()

        #expect(parser.components(from: message) == nil)
    }

    @Test
    func
        givenRequestMessageWithMethodAndPath_whenParsing_itBuildsRequestLine()
        async throws
    {
        let message = """
            POST /hello/world?when=fr&who=all
            """

        let parser = HTTPMessageParser()

        #expect(
            parser.components(from: message)?.startLine
                == .requestLine(
                    method: "POST",
                    absolutePath: "/hello/world?when=fr&who=all",
                    httpVersion: nil
                )
        )
    }

    @Test
    func
        givenRequestMessageWithMethodPathAndHttpVersion_whenParsing_itBuildsFullRequestLine()
        async throws
    {
        let message = """
            POST /hello/world?when=fr&who=all HTTP/1.1
            """

        let parser = HTTPMessageParser()

        #expect(
            parser.components(from: message)?.startLine
                == .requestLine(
                    method: "POST",
                    absolutePath: "/hello/world?when=fr&who=all",
                    httpVersion: "HTTP/1.1"
                )
        )
    }

    // given httpVersion only -> nil
    // given httpVersion and method -> nil
    // given httpVersion and path -> nil
    // --> no method & path -> nil

    // MARK: Status line

    @Test
    func
        givenStatusCode_whenParsing_itBuildsStatusLine()
        async throws
    {
        let message = """
            404
            """

        let parser = HTTPMessageParser()

        #expect(
            parser.components(from: message)?.startLine
                == .statusLine(
                    httpVersion: nil,
                    statusCode: 404,
                    reason: nil
                )
        )
    }

    @Test
    func
        givenHTTPVersionAndStatusCode_whenParsing_itBuildsStatusLineWithHTTPVersion()
        async throws
    {
        let message = """
            HTTP/1.1 404
            """

        let parser = HTTPMessageParser()

        #expect(
            parser.components(from: message)?.startLine
                == .statusLine(
                    httpVersion: "HTTP/1.1",
                    statusCode: 404,
                    reason: nil
                )
        )
    }
}

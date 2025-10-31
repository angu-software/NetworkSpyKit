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

    @Test
    func givenRequestMessageWithoutPath_whenParsing_itReturnsNil()
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
        givenRequestMessageWithMethodAndPath_whenParsing_itReturnsRequestMessage()
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
        givenRequestMessageWithMethodPathAndHttpVersion_whenParsing_itRetunsFullRequestLine()
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

    // given origin form - URL (unless it is possible to create URL without host)
    // given invalid origin form -> nil
    // given absolute form -> url
}

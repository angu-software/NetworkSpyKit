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
    func givenRequestMessage_itParsesRequestStartLine()
        async throws
    {
        let message = """
            POST
            """

        let parser = HTTPMessageParser()

        #expect(
            parser.components(from: message)?.startLine
                == .requestLine(
                    method: "POST",
                    absolutePath: "",
                    httpVersion: nil
                )
        )
    }

    // empty string -> nil
    // path empty -> nil

    // given origin form - URL (unless it is possible to create URL without host)
    // given invalid origin form -> nil
    // given absolute form -> url
}

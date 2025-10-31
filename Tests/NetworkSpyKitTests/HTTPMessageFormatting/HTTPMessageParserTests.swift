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
    func givenRequestMessage_givenMethod_itParsesComponentsWithMethod() async throws {
        let message = """
            POST
            """

        let parser = HTTPMessageParser()

        #expect(parser.components(from: message)?.startLine.method == "POST")
    }

    // given origin form - URL (unless it is possible to create URL without host)
    // given invalid origin form -> nil
    // given absolute form -> url
}

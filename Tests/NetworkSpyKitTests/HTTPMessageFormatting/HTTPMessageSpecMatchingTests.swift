//
//  Test.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 04.11.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct HTTPMessageSpecMatchingTests {

    // Basic Equality tests: isEqual

    @Test
    func givenRequestWithURL_givenEqualHTTPMessage_whenMatching_itMatches() async throws {
        let request = makeRequest()

        #expect(
            request.isMatching("""
            POST /api/v1/users?limit=10&offset=20 HTTP/1.1
            Host: example.com
            Content-Type: application/json
            Authorization: Bearer 12345

            { "name": "Alice", "email": "alice@example.com" }
            """)
        )
    }

    // Matching
    // omit http version
    // omit header
    // omit body
    // omit query

    // NotMatching
    // omit Method
    // omit absolute path
    // no path
    // no method
    // spec has required header
    // spec has required body

    // MARK: Test Support

    private func makeRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: "https://example.com/api/v1/users?limit=10&offset=20")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json",
                                       "Authorization": "Bearer 12345"]
        request.httpBody = #"{ "name": "Alice", "email": "alice@example.com" }"#.data(using: .utf8)

        return request
    }
}

// ExpressibleByHTTPMessage
extension URLRequest {

    // isEqual vs isMatching vs isSatisfying
    // Find Operator
    // Find Emoji operator for fun 🤪
    func isMatching(_ spec: HTTPMessageSpec) -> Bool {
        let parser = HTTPMessageParser()

        let httpComponents = HTTPMessageComponents(urlRequest: self)
        let specComponents = parser.components(from: spec)

        return httpComponents == specComponents
    }
}

typealias HTTPMessageSpec = String

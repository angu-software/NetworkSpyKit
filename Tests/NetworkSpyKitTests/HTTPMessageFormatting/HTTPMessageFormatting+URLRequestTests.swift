//
//  HTTPMessageFormatting+URLRequestTests.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 03.11.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct HTTPMessageFormatting_URLRequestTests {

    @Test
    func givenURLRequest_itFormatsToHTTPMessageFormat() async throws {

        let messageFormat = format(try makeRequest())

        #expect(messageFormat == """
            POST /api/message?shout=false&tone=friendly HTTP/1.1
            Content-Type: application/json
            Host: say.hello.test
            
            { "message": Hello }
            """)
    }

    // MARK: Test Support

    private func makeRequest(sourceLocation: SourceLocation = #_sourceLocation) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "say.hello.test"
        urlComponents.path = "/api/message"
        urlComponents.queryItems = [.init(name: "shout", value: "false"),
                                    .init(name: "tone", value: "friendly")]

        let url = try #require(urlComponents.url, sourceLocation: sourceLocation)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.httpBody = #"{ "message": Hello }"#.data(using: .utf8)

        return request
    }

    private func format(_ urlRequest: URLRequest) -> String {
        let formatter = HTTPMessageFormatter()

        return formatter.string(from: urlRequest)
    }
}

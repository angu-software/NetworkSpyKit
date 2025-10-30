//
//  HTTPMessageFormatTests.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 29.10.25.
//

import Foundation
import Testing

struct HTTPMessageFormatTests {

    @Test
    func givenRequest_itBuildsBasicFormat() async throws {
        let request = makeRequest(string: "https://rfc-messages.com/api/whatever")

        #expect(request.httpMessageFormat() == """
            GET /api/whatever
            """)
    }

    @Test
    func givenRequest_whenSpecifyingAbsoluteForm_itIncludesHost() async throws {
        let request = makeRequest(string: "https://rfc-messages.com/api/whatever",
                                  headerFields: ["AnotherHeader": "AnotherHeaderValue"])

        #expect(request.httpMessageFormat(absoluteForm: true) == """
            GET /api/whatever
            Host: rfc-messages.com
            AnotherHeader: AnotherHeaderValue
            """)
    }

    @Test
    func givenRequestWithHeaderFields_itIncludesHeaderFields() async throws {
        let request = makeRequest(string: "https://rfc-messages.com/api/whatever",
                                  headerFields: ["SomeHeader": "SomeHeaderValue",
                                                 "AnotherHeader": "AnotherHeaderValue"])

        #expect(request.httpMessageFormat() == """
            GET /api/whatever
            AnotherHeader: AnotherHeaderValue
            SomeHeader: SomeHeaderValue
            """)
    }

    // TODO: absolute-form request target (RFC 9112 §3.2.1): includes Host as first

    // MARK: Test Support

    private func makeRequest(string: String,
                             headerFields: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: string)!)
        request.allHTTPHeaderFields = headerFields

        return request
    }
}

extension URLRequest {

    /// - Note: Header fields are sorted
    ///
    /// - Parameters:
    ///   - absoluteForm: Absolute-form request target (RFC 9112 §3.2.1)
    func httpMessageFormat(absoluteForm: Bool = false) -> String {
        return [httpMessageFormatStartLine,
                absoluteForm ? httpMessageFormatHost : nil,
                httpMessageFormatHeaderFields]
            .compactMap { $0 }
            .joined(separator: "\n")
    }

    private var httpMessageFormatStartLine: String {
        return [httpMessageFormatMethod,
                httpMessageFormatPath]
            .compactMap { $0 }
            .joined(separator: " ")
    }

    private var httpMessageFormatMethod: String? {
        return httpMethod
    }

    private var httpMessageFormatPath: String? {
        url?.path
    }

    private var httpMessageFormatHost: String? {
        guard let host = url?.host else {
            return nil
        }

        return "Host: \(host)"
    }

    private var httpMessageFormatHeaderFields: String? {
        return allHTTPHeaderFields?
            .map { "\($0.key): \($0.value)" }
            .sorted()
            .joined(separator: "\n")
    }
}

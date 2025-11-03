//
//  StubbedResponse.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension NetworkSpy {

    /// A simple value type used to define a mocked (stubbed) HTTP response returned by `NetworkSpy`.
    ///
    /// Use `StubbedResponse` to simulate server responses in tests without performing real network calls.
    /// You can specify the HTTP status code, response headers, and optional body data.
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code to return (e.g., 200, 404, 500).
    ///   - headers: A dictionary of HTTP header fields to include in the response. Defaults to an empty dictionary.
    ///   - data: Optional raw body data for the response (e.g., JSON-encoded payload). Defaults to `nil`.
    ///
    /// **Example**:
    ///
    ///   Create a 200 OK JSON response:
    ///   ```swift
    ///   let json = #"{"message":"ok"}"#.data(using: .utf8)
    ///   let response = NetworkSpy.StubbedResponse(
    ///       statusCode: 200,
    ///       headers: ["Content-Type": "application/json"],
    ///       data: json
    ///   )
    ///   ```
    public struct StubbedResponse: Equatable, Sendable {
        var statusCode: Int
        var headers: [String: String]
        var data: Data?

        public init(statusCode: Int,
                    headers: [String: String] = [:],
                    data: Data? = nil) {
            self.statusCode = statusCode
            self.headers = headers
            self.data = data
        }
    }
}

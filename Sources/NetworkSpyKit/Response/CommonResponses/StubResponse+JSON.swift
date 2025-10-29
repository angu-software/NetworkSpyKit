//
//  StubResponse+JSON.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 29.10.25.
//

import Foundation

/// A lightweight value type used by NetworkSpy to describe a preconfigured, stubbed HTTP response.
///
/// StubbedResponse lets you quickly define the essentials of a network reply without making a real request,
/// enabling deterministic tests and offline development. Typical usage is to create JSON responses with a
/// specific HTTP status code, headers, and body data.
///
/// Key characteristics:
/// - Immutable structure representing an HTTP response payload used by NetworkSpy
/// - Convenience initializers for JSON payloads (data or Encodable)
/// - Sensible defaults for common headers like Content-Type: application/json
///
/// Common use cases:
/// - Unit testing code paths for success, error, and edge-case server responses
/// - Snapshotting API contracts by encoding models into JSON
/// - Simulating server behavior for UI previews or offline development workflows
///
/// Thread safety:
/// - StubbedResponse is a value type and is safe to pass across threads
///
/// See also:
/// - json(statusCode:_:jsonFormattingOptions:) for encoding Encodable payloads into JSON
/// - json(statusCode:jsonData:) for supplying raw JSON data
/// - json(statusCode:jsonString:) for supplying a JSON string
///
/// Example:
/// - Creating a 200 OK JSON response from an Encodable model:
///   let response = NetworkSpy.StubbedResponse.json(200, model)
///
/// - Creating a 404 Not Found response with a JSON error body:
///   let response = NetworkSpy.StubbedResponse.json(statusCode: 404, jsonString: "{\"error\":\"Not found\"}")
///
/// Notes:
/// - Ensure your Encodable types encode deterministically when using .sortedKeys for stable test snapshots
/// - The default JSONEncoder formatting is [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
///
/// Availability:
/// - Designed for use in test targets and development tooling where network stubbing is desired
extension NetworkSpy.StubbedResponse {

    public static func json(statusCode: Int = 200,
                            _ encodable: any Encodable,
                            jsonFormattingOptions: JSONEncoder.OutputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]) -> Self {
        let encoder = JSONEncoder()
        encoder.outputFormatting = jsonFormattingOptions
        let jsonData = try! encoder.encode(encodable)

        return json(statusCode: statusCode, jsonData: jsonData)
    }

    public static func json(statusCode: Int = 200, jsonData: Data) -> Self {
        return Self(statusCode: statusCode,
                    headers: ["Content-Type": "application/json"],
                    data: jsonData)
    }

    public static func json(statusCode: Int = 200, jsonString: String) -> Self {
        return json(statusCode: statusCode,
                            jsonData: jsonString.data(using: .utf8)!)
    }
}

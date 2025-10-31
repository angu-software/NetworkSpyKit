//
//  HTTPMessageComponents.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

/// A lightweight formatter for HTTP/1.x messages that can represent both requests and responses,
/// following RFC 9112 (HTTP/1.1). This type focuses on producing a human-readable wire-format
/// string for an HTTP message, composed of a start-line, optional header fields, and an optional body.
///
/// Features:
/// - Supports formatting of request messages using the origin-form request-target (RFC 9112 §3.2.1),
///   i.e., an absolute path with an optional query component derived from a URL.
/// - Supports formatting of response messages with status code and optional reason phrase.
/// - Includes standard HTTP/1.x start-line construction and field-line formatting.
/// - Automatically adds a Host header based on the URL host when available.
/// - Emits a message body if provided (UTF-8 only), separated from headers by a blank line.
///
/// Usage:
/// - For requests, set `method`, `url`, and optionally `httpVersion`, `headerFields`, and `body`.
/// - For responses, set `statusCode`, and optionally `statusReason`, `httpVersion`, `headerFields`, and `body`.
/// - Call `httpMessageFormat()` to receive the formatted message string.
///
/// - Note:
///   - Only the origin-form of the request-target is supported for requests (no absolute-form,
///     authority-form, or asterisk-form).
///   - If the URL path is empty, a root path "/" is used to comply with the absolute-path requirement.
///   - The body is included only if it can be decoded as UTF-8. Binary bodies are not supported.
///   - Header fields are rendered in lexicographical order, with "Host" injected (if available) and
///     included in the same ordering.
///   - If no components are set, the formatted message is an empty string.
///
/// **Example (Request)**:
/// ```swift
///   var msg = HTTPMessageComponents()
///   msg.method = "GET"
///   msg.url = URL(string: "https://example.com/path?query=1")
///   msg.httpVersion = "HTTP/1.1"
///   msg.headerFields = [ "Accept": "application/json" ]
///   let formatted = msg.httpMessageFormat()
///
///   /*
///    * GET /path?query=1 HTTP/1.1
///    * Accept: application/json
///    * Host: example.com
///    */
/// ```
///
/// **Example (Response)**:
/// ```swift
///   var msg = HTTPMessageComponents()
///   msg.httpVersion = "HTTP/1.1"
///   msg.statusCode = 200
///   msg.statusReason = "OK"
///   msg.headerFields = [ "Content-Type": "application/json" ]
///   msg.body = Data(#"{ "ok": true }"#.utf8)
///   let formatted = msg.httpMessageFormat()
///
///   /*
///    * HTTP/1.1 200 OK
///    * Content-Type: application/json
///    *
///    * { "ok": true }
///    */
/// ```
struct HTTPMessageComponents: Equatable {
    let startLine: StartLine
    var headerFields: [String: String]?
    var body: Data?
}

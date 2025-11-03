//
//  Request.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

public typealias Request = URLRequest

extension URLRequest {

    /// Creates a new URLRequest with common HTTP configuration options.
    /// 
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - httpMethod: The HTTP method to use (e.g., "GET", "POST"). Defaults to "GET".
    ///   - allHTTPHeaderFields: A dictionary containing all the HTTP header fields for the request. Defaults to `nil`.
    ///   - httpBody: The HTTP body data to send with the request. Used only if `httpBodyStream` is `nil`. Defaults to `nil`.
    ///   - httpBodyStream: An input stream providing the HTTP body. If provided, it takes precedence over `httpBody`. Defaults to `nil`.
    ///
    /// - Discussion:
    ///   This initializer configures a URLRequest with the provided URL, method, headers,
    ///   and body. If both `httpBody` and `httpBodyStream` are provided, the request uses
    ///   `httpBodyStream` and ignores `httpBody`. This is useful for large payloads where
    ///   streaming is preferred over loading the entire body into memory.
    ///
    /// - SeeAlso:
    ///   `URLRequest`, `URLRequest.httpBody`, `URLRequest.httpBodyStream`, `URLRequest.resolvedHTTPBody()`
    public init(url: URL,
                httpMethod: String = "GET",
                allHTTPHeaderFields: [String: String]? = nil,
                httpBody: Data? = nil,
                httpBodyStream: InputStream? = nil) {
        self.init(url: url)
        self.httpMethod = httpMethod
        self.allHTTPHeaderFields = allHTTPHeaderFields

        if let httpBodyStream {
            self.httpBodyStream = httpBodyStream
        } else if let httpBody {
            self.httpBody = httpBody
        }
    }
}

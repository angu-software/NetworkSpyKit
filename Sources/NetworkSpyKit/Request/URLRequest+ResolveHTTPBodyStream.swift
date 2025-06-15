//
//  URLRequest+ResolveHTTPBodyStream.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension URLRequest {

    /// Returns the resolved HTTP body data of the request.
    ///
    /// This method first checks whether the `httpBody` is directly available and returns it if so.
    /// If not, it attempts to read the full contents of the `httpBodyStream`.
    ///
    /// This is particularly useful in **test environments** where requests are built by third-party
    /// libraries and the body is not directly accessible. By resolving the body, you can inspect
    /// the full payload during tests.
    ///
    /// - Note: This method reads the entire stream into memory. While this is acceptable in test
    /// scenarios (where payloads are expected to be small), it is **not intended for production use**
    /// or scenarios involving large request bodies.
    ///
    /// - Returns: The resolved body data, or `nil` if no body is present.
    public func resolvedHTTPBody() -> Data? {
        if let body = httpBody {
            return body
        }

        guard let stream = httpBodyStream else {
            return nil
        }

        return try? StreamReader.readAllData(of: stream)
    }
}

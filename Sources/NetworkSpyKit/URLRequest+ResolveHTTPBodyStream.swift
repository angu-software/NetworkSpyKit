//
//  URLRequest+ResolveHTTPBodyStream.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension URLRequest {

    func resolvedHTTPBody() -> Data? {
        if let body = httpBody {
            return body
        }

        guard let stream = httpBodyStream else {
            return nil
        }

        return try? StreamReader.readAllData(of: stream)
    }
}

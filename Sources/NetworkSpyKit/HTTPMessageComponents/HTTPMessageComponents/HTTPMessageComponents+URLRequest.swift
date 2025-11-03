//
//  HTTPMessageComponents+URLRequest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 03.11.25.
//

import Foundation

extension HTTPMessageComponents {

    /// - Note: `URLRequest.httpMethod`, `URLRequest.url` as well as the assigned `URL.host` are required for *RFC 9112*
    init?(urlRequest: URLRequest) {
        guard let method = urlRequest.httpMethod,
              let url = urlRequest.url,
              let host = url.host else {
            return nil
        }

        let absolutePath = [url.path,
                            url.query]
            .compactMap{ $0 }
            .joined(separator: "?")

        var headerFields = ["Host": host]
        headerFields.merge(urlRequest.allHTTPHeaderFields ?? [:], uniquingKeysWith: { existing, _ in return existing })

        self.init(startLine: .requestLine(method: method,
                                          absolutePath: absolutePath),
                  headerFields: headerFields,
                  body: urlRequest.resolvedHTTPBody())
    }
}

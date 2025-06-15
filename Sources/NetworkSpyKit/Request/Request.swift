//
//  Request.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

public typealias Request = URLRequest

extension URLRequest {

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

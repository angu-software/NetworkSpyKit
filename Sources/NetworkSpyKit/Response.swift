//
//  Response.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension NetworkSpy {

    public struct Response: Equatable {
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

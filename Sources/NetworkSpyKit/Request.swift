//
//  File.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

/// A Simplified representation of an URLRequest
public struct Request: Equatable {

    public let httpMethod: String
    public let url: URL
    public let headers: [String: String]
    public let data: Data?

    public init(httpMethod: String,
                url: URL,
                headers: [String: String],
                data: Data?) {
        self.httpMethod = httpMethod
        self.url = url
        self.headers = headers
        self.data = data
    }
}

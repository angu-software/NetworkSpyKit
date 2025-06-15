//
//  URLRequest+Double.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation

@testable import NetworkSpyKit

extension Request {

    static func fixture(url: URL = URL(string: "https://example.com")!,
                        httpMethod: String = "GET",
                        httpHeaderFields: [String: String] = [:],
                        httpBody: Data? = nil,
                        httpBodyStream: InputStream? = nil,
                        spyId: String? = nil) -> Self {
        var fixture = Self(url: url,
                           httpMethod: httpMethod,
                           allHTTPHeaderFields: httpHeaderFields,
                           httpBody: httpBody,
                           httpBodyStream: httpBodyStream)
        if let spyId {
            fixture.allHTTPHeaderFields?[NetworkSpy.headerKey] = spyId
        }

        return fixture
    }
}

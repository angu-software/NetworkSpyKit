//
//  URLRequest+Double.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation

@testable import NetworkSpyKit

extension URLRequest {

    static func fixture(url: URL = URL(string: "https://example.com")!,
                        httpMethod: String = "GET",
                        httpHeaderFields: [String: String] = [:],
                        httpBody: Data? = nil,
                        httpBodyStream: InputStream? = nil,
                        spyId: String? = nil) -> Self {
        var fixture = Self(url: url)
        fixture.httpMethod = httpMethod

        var allHeadersFields = httpHeaderFields
        if let spyId {
            allHeadersFields[NetworkSpy.headerKey] = spyId
        }

        fixture.allHTTPHeaderFields = allHeadersFields
        if let httpBody {
            fixture.httpBody = httpBody
        } else {
            fixture.httpBodyStream = httpBodyStream
        }

        return fixture
    }
}

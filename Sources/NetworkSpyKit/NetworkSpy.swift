//
//  NetworkSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

public final class NetworkSpy {

    public typealias Request = URLRequest

    public typealias ResponseProvder = (Request) -> Response

    public let sessionConfiguration: URLSessionConfiguration
    public var responseProvder: ResponseProvder

    static let headerKey = "X-NetworkSpy-ID"
    let id: String = UUID().uuidString

    public init(sessionConfiguration: URLSessionConfiguration,
                responseProvder: @escaping ResponseProvder) {
        self.sessionConfiguration = sessionConfiguration
        self.responseProvder = responseProvder

        var sessionHeaders = self.sessionConfiguration.httpAdditionalHeaders ?? [:]
        sessionHeaders[Self.headerKey] = self.id
        self.sessionConfiguration.httpAdditionalHeaders = sessionHeaders
    }
}

//
//  NetworkSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

public final class NetworkSpy {

    public typealias Request = URLRequest

    public typealias ResponseProvider = (Request) -> Response

    /// The `URLSessionConfiguration` associated with this spy.
    ///
    /// A copy of the injected `URLSessionConfiguration` instance during initialization
    public let sessionConfiguration: URLSessionConfiguration
    public var responseProvder: ResponseProvider

    static let headerKey = "X-NetworkSpy-ID"
    let id: String = UUID().uuidString
    
    public init(sessionConfiguration: URLSessionConfiguration,
                responseProvder: @escaping ResponseProvider) {
        self.sessionConfiguration = Self.copyConfiguration(sessionConfiguration)
        self.responseProvder = responseProvder

        setUp()
    }

    private static func copyConfiguration(_ configuration: URLSessionConfiguration) -> URLSessionConfiguration {
        return configuration.copy() as! URLSessionConfiguration
    }

    private func setUp() {
        bindConfigurationToSpy()
        installInterceptorOnConfiguration()
    }

    private func bindConfigurationToSpy() {
        var sessionHeaders = sessionConfiguration.httpAdditionalHeaders ?? [:]
        sessionHeaders[Self.headerKey] = id
        sessionConfiguration.httpAdditionalHeaders = sessionHeaders
    }

    private func installInterceptorOnConfiguration() {
        sessionConfiguration.protocolClasses = [InterceptorURLProtocol.self]
    }
}

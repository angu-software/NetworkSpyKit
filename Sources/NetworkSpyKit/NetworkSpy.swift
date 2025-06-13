//
//  NetworkSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

// TODO: Make setable response provider thread safe
public final class NetworkSpy: @unchecked Sendable {

    public typealias ResponseProvider = (Request) -> Response

    /// The `URLSessionConfiguration` associated with this spy.
    ///
    /// A copy of the injected `URLSessionConfiguration` instance during initialization
    public let sessionConfiguration: URLSessionConfiguration
    public var responseProvder: ResponseProvider

    static let headerKey = "X-NetworkSpy-ID"
    let id: String = UUID().uuidString

    private let spyRegistry: SpyRegistry = SpyRegistry.shared

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
        registerOnRegistry()
        bindConfigurationToSpy()
        installInterceptorOnConfiguration()
    }

    private func registerOnRegistry() {
        spyRegistry.register(self)
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

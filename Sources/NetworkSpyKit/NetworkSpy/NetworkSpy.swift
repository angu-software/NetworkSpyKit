//
//  NetworkSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

public final class NetworkSpy: Sendable {

    public typealias ResponseProvider = @Sendable (Request) throws -> Response

    /// The `URLSessionConfiguration` associated with this spy.
    ///
    /// A copy of the injected `URLSessionConfiguration` instance during initialization
    public let sessionConfiguration: URLSessionConfiguration

    static let headerKey = "X-NetworkSpy-ID"
    let id: String = UUID().uuidString
    let responseProvider: ResponseProvider

    private let spyRegistry: SpyRegistry

    // TODO: tell that the injected session is a "template"
    public convenience init(sessionConfiguration: URLSessionConfiguration,
                            responseProvider: @escaping ResponseProvider) {
        self.init(sessionConfiguration: sessionConfiguration,
                  responseProvider: responseProvider,
                  spyRegistry: .shared)
    }

    init(sessionConfiguration: URLSessionConfiguration,
                responseProvider: @escaping ResponseProvider,
                spyRegistry: SpyRegistry) {
        self.sessionConfiguration = Self.copyConfiguration(sessionConfiguration)
        self.responseProvider = responseProvider
        self.spyRegistry = spyRegistry

        setUp()
    }

    deinit {
        unregisterFromRegistry()
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

    private func unregisterFromRegistry() {
        spyRegistry.unregister(byId: id)
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

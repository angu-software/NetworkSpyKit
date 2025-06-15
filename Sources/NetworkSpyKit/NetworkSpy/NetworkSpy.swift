//
//  NetworkSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

public final class NetworkSpy: @unchecked Sendable {

    public typealias ResponseProvider = @Sendable (Request) throws -> StubbedResponse

    /// The `URLSessionConfiguration` associated with this spy.
    ///
    /// A copy of the injected `URLSessionConfiguration` instance during initialization
    public let sessionConfiguration: URLSessionConfiguration
    public var responseProvider: ResponseProvider {
        get {
            queue.sync {
                return self._responseProvider
            }
        }
        set {
            queue.async(flags: .barrier) {
                self._responseProvider = newValue
            }
        }
    }

    static let headerKey = "X-NetworkSpy-ID"
    let id: String = UUID().uuidString

    private let spyRegistry: SpyRegistry
    private let queue: DispatchQueue = DispatchQueue(label: "\(NetworkSpy.self)-\(UUID().uuidString)",
                                                     attributes: .concurrent)
    private var _responseProvider: ResponseProvider

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
        self._responseProvider = responseProvider
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

//
//  NetworkSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

/// A test utility for intercepting and stubbing HTTP requests made through `URLSession`.
///
/// `NetworkSpy` provides a customizable `URLSessionConfiguration` that redirects all network
/// traffic through a test interceptor, allowing you to inspect requests and return stubbed responses.
/// This is primarily intended for use in unit and integration tests.
public final class NetworkSpy: Sendable {

    /// A typealias for a closure that returns a stubbed response for a given request.
    ///
    /// You can assign a custom provider to simulate different network conditions or
    /// test specific behaviors. The provider is invoked for each intercepted request.
    public typealias ResponseProvider = @Sendable (Request) throws -> StubbedResponse

    /// The default response returned by the spy when no custom provider is set.
    ///
    /// Returns a 418 "I'm a teapot" response with JSON content.
    /// Useful as a placeholder in test environments.
    public static let defaultResponse: ResponseProvider = { _ in .teaPot }

    /// The `URLSessionConfiguration` associated with this spy.
    ///
    /// This configuration is a copy of the one provided during initialization,
    /// augmented with the required interceptor and identification headers.
    /// Use this to construct a `URLSession` that is intercepted by the spy.
    public let sessionConfiguration: URLSessionConfiguration

    /// The currently assigned response provider.
    ///
    /// Can be updated at runtime to dynamically change the stubbed response behavior.
    /// Access to this property is thread-safe.
    public var responseProvider: ResponseProvider {
        get {
            responseStore.value
        }
        set {
            responseStore.value = newValue
        }
    }

    public var recordedRequests: [Request] {
        return requestRecorder.recordedRequests
    }

    static let headerKey = "X-NetworkSpy-ID"
    let id: String = UUID().uuidString

    private let spyRegistry: SpyRegistry
    private let responseStore: SafeResponseStore
    private let requestRecorder: RequestRecorder

    /// Creates a new `NetworkSpy` with a given `URLSessionConfiguration` and optional response provider.
    ///
    /// The configuration is copied and modified internally to inject the required interceptor.
    /// Use the returned `sessionConfiguration` to create a `URLSession` that is monitored by the spy.
    ///
    /// - Parameters:
    ///   - sessionConfiguration: A template configuration. It will be copied and modified.
    ///   - responseProvider: A closure that returns a stubbed response for intercepted requests. Defaults to `.teaPot`.
    public convenience init(sessionConfiguration: URLSessionConfiguration,
                            responseProvider: @escaping ResponseProvider = defaultResponse) {
        self.init(sessionConfiguration: sessionConfiguration,
                  responseProvider: responseProvider,
                  spyRegistry: .shared)
    }

    init(sessionConfiguration: URLSessionConfiguration,
         responseProvider: @escaping ResponseProvider = defaultResponse,
         spyRegistry: SpyRegistry) {
        self.sessionConfiguration = Self.copyConfiguration(sessionConfiguration)
        self.responseStore = SafeResponseStore(value: responseProvider)
        self.spyRegistry = spyRegistry
        self.requestRecorder = RequestRecorder()

        setUp()
    }

    deinit {
        unregisterFromRegistry()
    }

    func record(_ request: URLRequest) {
        requestRecorder.record(request)
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

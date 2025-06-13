//
//  NetworkSpyTest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct NetworkSpyTest {

    private static let defaultResponseProvider: NetworkSpy.ResponseProvider = { _ in return .teaPot }

    @Test
    func should_bind_spy_to_sessionConfiguration() async throws {
        let spy = makeSpy()

        #expect(spy.sessionConfiguration.httpAdditionalHeaders?[NetworkSpy.headerKey] as? String == spy.id)
    }

    @Test
    func should_provide_copy_of_injected_sessionConfiguration() async throws {
        let injectedConfig = URLSessionConfiguration.default
        let spy = makeSpy(sessionConfiguration: injectedConfig)

        #expect(spy.sessionConfiguration !== injectedConfig)
    }

    @Test
    func should_install_InterceptorURLProtocol_on_sessionConfiguration() async throws {
        let spy = makeSpy()

        #expect(spy.sessionConfiguration.protocolClasses?.map { "\($0)" } == ["InterceptorURLProtocol"])
    }

    @Test
    func should_register_on_SpyRegistry() async throws {
        let spy = makeSpy()

        #expect(SpyRegistry.shared.spy(byId: spy.id) === spy)
    }

    @Test
    func should_unregister_on_SpyRegistry_when_deallocated() async throws {
        var spy: NetworkSpy? = makeSpy()
        let spyId = try #require(spy?.id)

        spy = nil

        #expect(SpyRegistry.shared.spy(byId: spyId) == nil)
    }

    private func makeSpy(sessionConfiguration: URLSessionConfiguration = .default,
                         _ responseProvider: @escaping NetworkSpy.ResponseProvider = defaultResponseProvider) -> NetworkSpy {
        return NetworkSpy(sessionConfiguration: sessionConfiguration,
                          responseProvider: responseProvider)
    }

    // TODO: Remove spy binding header from request before it is provided to the responseProvider
}

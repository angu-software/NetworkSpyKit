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

    private let spyRegistry: SpyRegistry
    private let spyBuilder: SpyBuilder

    init() {
        self.spyRegistry = SpyRegistry()
        self.spyBuilder = SpyBuilder(spyRegistry: spyRegistry)
    }

    @Test
    func should_bind_spy_to_sessionConfiguration() async throws {
        let spy = spyBuilder.build()

        #expect(spy.sessionConfiguration.httpAdditionalHeaders?[NetworkSpy.headerKey] as? String == spy.id)
    }

    @Test
    func should_provide_copy_of_injected_sessionConfiguration() async throws {
        let injectedConfig = spyBuilder.sessionConfiguration
        let spy = spyBuilder.build()

        #expect(spy.sessionConfiguration !== injectedConfig)
    }

    @Test
    func should_install_InterceptorURLProtocol_on_sessionConfiguration() async throws {
        let spy = spyBuilder.build()

        #expect(spy.sessionConfiguration.protocolClasses?.map { "\($0)" } == ["InterceptorURLProtocol"])
    }

    @Test
    func should_register_on_SpyRegistry() async throws {
        let spy = spyBuilder.build()

        #expect(spyRegistry.spy(byId: spy.id) === spy)
    }

    @Test
    func should_unregister_on_SpyRegistry_when_deallocated() async throws {
        var spy: NetworkSpy? = spyBuilder.build()
        let spyId = try #require(spy?.id)

        spy = nil

        #expect(spyRegistry.spy(byId: spyId) == nil)
    }

    @Test
    func should_remove_binding_header_from_request_when_provided_to_response_provider() async throws {
        let spy = spyBuilder.build()
        let box = ThreadSafeBox<URLRequest?>(value: nil)

        spy.responseProvider = { request in
            box.value = request
            return .teaPot
        }

        _ = try spy.response(for: .fixture(httpHeaderFields: ["SomeHeaderKey": "Value"],
                                           spyId: spy.id))

        let headers = try #require(box.value?.allHTTPHeaderFields)
        #expect(headers.keys.contains(NetworkSpy.headerKey) == false)
    }
}

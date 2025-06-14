//
//  InterceptorURLProtocol.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct InterceptorURLProtocolTests {

    private let clientSpy: ProtocolClientSpy
    private let spyRegistry: SpyRegistry
    private let spyBuilder: SpyBuilder

    init() {
        self.clientSpy = ProtocolClientSpy()
        self.spyRegistry = SpyRegistry()
        self.spyBuilder = SpyBuilder(spyRegistry: spyRegistry)

        //InterceptorURLProtocol.setSpyRegistry(spyRegistry)
    }

    @Test // TODO: More specific error cases (request with no spy, spy not found, response stub throws, http response could not be build)
    func should_tell_client_when_loading_failed() async throws {
        let interceptor = makeInterceptor(request: .fixture(spyId: nil))

        interceptor.startLoading()

        // TODO: explicit error check
        #expect((clientSpy.didFailLoadingWithError as? NSError)?.code == 0)
    }

    @Test
    func should_tell_client_when_loading_has_finished_after_error() async throws {
        let interceptor = makeInterceptor(request: .fixture(spyId: nil))

        interceptor.startLoading()

        #expect(clientSpy.didFinishLoading)
    }

    @Test
    func should_receive_response_for_spy_request() async throws {
        let spy = spyBuilder.build()

        let interceptor = makeInterceptor(request: .fixture(spyId: spy.id))

        interceptor.startLoading()

        #expect((clientSpy.didReceiveResponse as? HTTPURLResponse)?.statusCode == 418)
    }

    @Test
    func should_not_cache_responses() async throws {
        let spy = NetworkSpy(sessionConfiguration: .default,
                             responseProvider: { _ in .teaPot },
                             spyRegistry: spyRegistry)

        let interceptor = makeInterceptor(request: .fixture(spyId: spy.id))

        interceptor.startLoading()

        #expect(clientSpy.didReceiveResponseCachePolicy == .notAllowed)
    }

    // TODO: error when spy not found

    private func makeInterceptor(request: URLRequest) -> InterceptorURLProtocol {
        return InterceptorURLProtocol(request: .fixture(spyId: nil),
                                      cachedResponse: nil,
                                      client: clientSpy)
    }
}

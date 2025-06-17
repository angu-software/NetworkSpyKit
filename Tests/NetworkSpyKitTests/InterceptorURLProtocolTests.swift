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

    private typealias InterceptorError = InterceptorURLProtocol.Error

    private let spyRegistry: SpyRegistry
    private let spyBuilder: SpyBuilder
    private let clientSpy: ProtocolClientSpy
    private let interceptorBuilder: InterceptorBuilder

    init() {
        self.spyRegistry = SpyRegistry()
        self.spyBuilder = SpyBuilder(spyRegistry: spyRegistry)
        self.clientSpy = ProtocolClientSpy()
        self.interceptorBuilder = InterceptorBuilder(client: clientSpy,
                                                     spyRegistry: spyRegistry)
    }

    @Test
    func should_load_with_error_when_request_does_not_have_spy_assigned() async throws {
        interceptorBuilder.request = .fixture(spyId: nil)
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        #expect(clientSpy.didFailLoadingWithError as? InterceptorError == .spyNotFoundForRequest)
    }

    @Test
    func should_load_with_error_when_request_assigned_spy_not_found() async throws {
        interceptorBuilder.request = .fixture(spyId: "spy-id")
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        #expect(clientSpy.didFailLoadingWithError as? InterceptorError == .spyNotFoundForRequest)
    }

    @Test
    func should_load_with_error_thrown_from_spy_response_provider() async throws {
        spyBuilder.responseProvider = { _ in throw TestingError.somethingWentWrong }
        let spy = spyBuilder.build()
        interceptorBuilder.request = .fixture(spyId: spy.id)
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        #expect(clientSpy.didFailLoadingWithError as? TestingError == .somethingWentWrong)
    }

    @Test
    func should_load_with_error_when_request_is_not_valid() async throws {
        let spy = spyBuilder.build()
        interceptorBuilder.request = .fixture(spyId: spy.id)
        interceptorBuilder.request.url = nil
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        #expect(clientSpy.didFailLoadingWithError as? InterceptorError == .invalidRequestURLMissing)
    }

    @Test
    func should_tell_client_when_loading_has_finished_after_error() async throws {
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        try #require(clientSpy.didFailLoadingWithError != nil)
        #expect(clientSpy.didFinishLoading)
    }

    @Test
    func should_receive_response_for_spy_request() async throws {
        let spy = spyBuilder.build()

        interceptorBuilder.request = .fixture(spyId: spy.id)
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        #expect((clientSpy.didReceiveResponse as? HTTPURLResponse)?.statusCode == 418)
    }

    @Test
    func should_not_cache_responses() async throws {
        let spy = spyBuilder.build()

        interceptorBuilder.request = .fixture(spyId: spy.id)
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        #expect(clientSpy.didReceiveResponseCachePolicy == .notAllowed)
    }

    @Test
    func should_tell_client_when_data_was_loaded() async throws {
        let responseData = "Hello".data(using: .utf8)!
        let responseWithData = NetworkSpy.StubbedResponse(statusCode: 200, data: responseData)
        spyBuilder.responseProvider = { _ in return responseWithData }
        let spy = spyBuilder.build()

        interceptorBuilder.request = .fixture(spyId: spy.id)
        let interceptor = interceptorBuilder.build()

        interceptor.startLoading()

        #expect(clientSpy.didLoadData == responseData)
    }
}

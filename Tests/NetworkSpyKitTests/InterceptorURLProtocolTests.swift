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

    init() {
        self.clientSpy = ProtocolClientSpy()
    }

    @Test // TODO: More specific error cases (request with no spy, spy not found, response stub throws, http response could not be build)
    func should_tell_client_when_loading_failed() async throws {
        let urlRequest = URLRequest(url: URL(string: "http://example.com")!)

        let interceptor = InterceptorURLProtocol(request: urlRequest,
                                                 cachedResponse: nil,
                                                 client: clientSpy)

        interceptor.startLoading()

        // TODO: explicit error check
        #expect((clientSpy.didFailLoadingWithError as? NSError)?.code == 0)
    }

    @Test
    func should_tell_client_when_loading_has_finished_after_error() async throws {
        let clientSpy = ProtocolClientSpy()
        let urlRequest = URLRequest(url: URL(string: "http://example.com")!)

        let interceptor = InterceptorURLProtocol(request: urlRequest,
                                                 cachedResponse: nil,
                                                 client: clientSpy)

        interceptor.startLoading()

        #expect(clientSpy.didFinishLoading)
    }

    @Test func should_receive_response_for_spy_request() async throws {

    }

    // TODO: did receive response data for spy response
    // TODO: error when spy not found
    // TODO: Cache policy
}

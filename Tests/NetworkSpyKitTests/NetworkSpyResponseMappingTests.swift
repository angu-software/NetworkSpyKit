//
//  NetworkSpyResponseMappingTests.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 15.06.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct NetworkSpyResponseMappingTests {

    private let spyBuilder: SpyBuilder

    init() {
        self.spyBuilder = SpyBuilder(spyRegistry: SpyRegistry())
    }

    @Test
    func should_retrun_httpURLResponse_with_request_url() async throws {
        spyBuilder.responseProvider = { _ in return .teaPot }
        let spy = spyBuilder.build()
        let urlRequest = URLRequest.fixture(spyId: spy.id)

        let httpResponse = try spy.response(for: urlRequest).response

        #expect(httpResponse.url == urlRequest.url)
    }

    @Test
    func should_retrun_httpURLResponse_stubbed_status_code() async throws {
        spyBuilder.responseProvider = { _ in return NetworkSpy.Response(statusCode: 203) }
        let spy = spyBuilder.build()
        let urlRequest = URLRequest.fixture(spyId: spy.id)

        let httpResponse = try spy.response(for: urlRequest).response

        #expect(httpResponse.statusCode == 203)
    }

    @Test
    func should_retrun_httpURLResponse_stubbed_headers() async throws {
        let responseHeaders = ["X-Message": "Hello"]
        let stubbedResponse = NetworkSpy.Response(statusCode: 203, headers: responseHeaders)
        spyBuilder.responseProvider = { _ in return stubbedResponse }
        let spy = spyBuilder.build()
        let urlRequest = URLRequest.fixture(spyId: spy.id)

        let httpResponse = try spy.response(for: urlRequest).response

        #expect(httpResponse.allHeaderFields as? [String: String] == responseHeaders)
    }
}

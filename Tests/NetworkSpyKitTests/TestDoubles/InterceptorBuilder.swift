//
//  InterceptorBuilder.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation

@testable import NetworkSpyKit

final class InterceptorBuilder {

    let client: any URLProtocolClient

    var request: URLRequest
    var spyRegistry: SpyRegistry

    init(request: URLRequest = .fixture(spyId: nil),
         client: any URLProtocolClient,
         spyRegistry: SpyRegistry) {
        self.request = request
        self.client = client
        self.spyRegistry = spyRegistry
    }

    func build() -> InterceptorURLProtocol {
        let interceptor = InterceptorURLProtocol(request: request,
                                                 cachedResponse: nil,
                                                 client: client)

        interceptor.spyRegistry = spyRegistry

        return interceptor
    }
}

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

    init(request: URLRequest = .fixture(spyId: nil),
         client: any URLProtocolClient) {
        self.request = request
        self.client = client
    }

    func build() -> InterceptorURLProtocol {
        return InterceptorURLProtocol(request: request,
                                      cachedResponse: nil,
                                      client: client)
    }
}

//
//  InterceptorURLProtocol.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

final class InterceptorURLProtocol: URLProtocol {

    private let spyRegistry =  SpyRegistry.shared

    // MARK: - URLProtocol

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // TODO: canonicazor to sort query parameters for reliable comparison
        return request
    }

    override func startLoading() {
        client?.urlProtocol(self, didFailWithError: NSError(domain: "", code: 0, userInfo: nil))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // No-op
    }
}

//
//  ProtocolClientSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation

final class ProtocolClientSpy: NSObject, URLProtocolClient, @unchecked Sendable {

    private(set) var didReceiveResponse: URLResponse?
    private(set) var didReceiveResponseCachePolicy: URLCache.StoragePolicy?
    private(set) var didLoadData: Data?
    private(set) var didFailLoadingWithError: (any Error)?
    private(set) var didFinishLoading = false

    // MARK: - URLProtocolClient

    func urlProtocol(_ protocol: URLProtocol, didReceive response: URLResponse, cacheStoragePolicy policy: URLCache.StoragePolicy) {
        didReceiveResponse = response
        didReceiveResponseCachePolicy = policy
    }

    func urlProtocol(_ protocol: URLProtocol, didLoad data: Data) {
        didLoadData = data
    }

    func urlProtocol(_ protocol: URLProtocol, didFailWithError error: any Error) {
        didFailLoadingWithError = error
    }

    func urlProtocolDidFinishLoading(_ protocol: URLProtocol) {
        didFinishLoading = true
    }

    func urlProtocol(_ protocol: URLProtocol, wasRedirectedTo request: URLRequest, redirectResponse: URLResponse) {
        // No-op
    }

    func urlProtocol(_ protocol: URLProtocol, cachedResponseIsValid cachedResponse: CachedURLResponse) {
        // No-op
    }

    func urlProtocol(_ protocol: URLProtocol, didReceive challenge: URLAuthenticationChallenge) {
        // No-op
    }

    func urlProtocol(_ protocol: URLProtocol, didCancel challenge: URLAuthenticationChallenge) {
        // No-op
    }
}

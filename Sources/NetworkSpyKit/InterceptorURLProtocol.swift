//
//  InterceptorURLProtocol.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

final class InterceptorURLProtocol: URLProtocol {

    enum Error: Swift.Error {
        case spyNotFoundForRequest
        case invalidRequestURLMissing
    }

    var spyRegistry: SpyRegistry = .shared

    private func response(for request: URLRequest) throws -> (response: HTTPURLResponse, data: Data?) {
        let spy = try spy(for: request)
        return try spy.response(for: request)
    }

    private func spy(for request: URLRequest) throws -> NetworkSpy {
        guard let spy = spyRegistry.spy(for: request) else {
            throw Error.spyNotFoundForRequest
        }

        return spy
    }

    private func respond(with response: (response: HTTPURLResponse, data: Data?)) {
        respond(with: response.response)

        if let responseData = response.data {
            respond(with: responseData)
        }
    }

    private func respond(with responseData: Data) {
        client?.urlProtocol(self,
                            didLoad: responseData)
    }

    private func respond(with response: HTTPURLResponse) {
        client?.urlProtocol(self,
                            didReceive: response,
                            cacheStoragePolicy: .notAllowed)
    }

    private func respond(with error: any Swift.Error) {
        client?.urlProtocol(self, didFailWithError: error)
    }

    private func finishLoading() {
        client?.urlProtocolDidFinishLoading(self)
    }

    // MARK: - URLProtocol

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // TODO: canonicazor to sort query parameters for reliable comparison
        return request
    }
    
    override func startLoading() {
        do {
            respond(with: try response(for: request))
        } catch {
            respond(with: error)
        }

        finishLoading()
    }

    override func stopLoading() {
        // No-op
    }
}

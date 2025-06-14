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
        case couldNotCreateRequestForSpy
    }

    var spyRegistry: SpyRegistry = .shared

    private func spy(for request: URLRequest) throws -> NetworkSpy {
        guard let spy = spyRegistry.spy(for: request) else {
            throw Error.spyNotFoundForRequest
        }

        return spy
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
            let spy = try spy(for: request)
            let response = try spy.response(for: request)
            client?.urlProtocol(self,
                                didReceive: response,
                                cacheStoragePolicy: .notAllowed)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // No-op
    }
}

extension NetworkSpy {

    typealias Error = InterceptorURLProtocol.Error

    func response(for urlRequest: URLRequest) throws -> HTTPURLResponse {
        guard let request = Request(urlRequest: urlRequest) else {
            throw Error.couldNotCreateRequestForSpy
        }

        let response = try response(for: request)

        return HTTPURLResponse(url: urlRequest.url!,
                               statusCode: 418,
                               httpVersion: nil,
                               headerFields: nil)!
    }

    private func response(for request: Request) throws -> Response {
        return try responseProvider(request)
    }
}

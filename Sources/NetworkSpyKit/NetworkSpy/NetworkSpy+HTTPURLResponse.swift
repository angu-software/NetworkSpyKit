//
//  NetworkSpy+URLRequest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 15.06.25.
//

import Foundation

extension NetworkSpy {

    typealias Error = InterceptorURLProtocol.Error

    func response(for urlRequest: URLRequest) throws -> HTTPURLResponse {
        guard let request = Request(urlRequest: urlRequest) else {
            throw Error.couldNotCreateRequestForSpy
        }

        let response = try response(for: request)

        return HTTPURLResponse(url: urlRequest.url!,
                               statusCode: response.statusCode,
                               httpVersion: nil,
                               headerFields: response.headers)!
    }

    private func response(for request: Request) throws -> Response {
        return try responseProvider(request)
    }
}

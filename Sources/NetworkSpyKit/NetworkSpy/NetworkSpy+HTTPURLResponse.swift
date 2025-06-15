//
//  NetworkSpy+URLRequest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 15.06.25.
//

import Foundation

extension NetworkSpy {

    typealias Error = InterceptorURLProtocol.Error

    func response(for urlRequest: URLRequest) throws -> (response: HTTPURLResponse, data: Data?) {
        guard let request = Request(urlRequest: urlRequest) else {
            throw Error.couldNotCreateRequestForSpy
        }

        let response = try response(for: request)

        return (makeHTTPURLResponse(requestURL: urlRequest.url,
                                    stubbedResponse: response),
                response.data)
    }

    private func response(for request: Request) throws -> Response {
        return try responseProvider(request)
    }

    private func makeHTTPURLResponse(requestURL: URL?, stubbedResponse: Response) -> HTTPURLResponse {
        guard let requestURL,
              let httpResponse = HTTPURLResponse(url: requestURL,
                                                 statusCode: stubbedResponse.statusCode,
                                                 httpVersion: nil,
                                                 headerFields: stubbedResponse.headers) else {
            // We expect HTTPURLResponse.init to actually never fail.
            // We could not come up with parameters combination that will fail the init.
            fatalError("Unexpected failure creating HTTPURLResponse – Invalid parameters for HTTPURLResponse")
        }

        return httpResponse
    }
}

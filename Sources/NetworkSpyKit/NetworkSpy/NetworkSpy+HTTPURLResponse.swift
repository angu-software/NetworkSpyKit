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
        guard urlRequest.url != nil else {
            throw Error.invalidRequestURLMissing
        }

        let stubbedResponse = try responseProvider(urlRequest)

        return (makeHTTPURLResponse(requestURL: urlRequest.url,
                                    stubbedResponse: stubbedResponse),
                stubbedResponse.data)
    }

    private func makeHTTPURLResponse(requestURL: URL?, stubbedResponse: StubbedResponse) -> HTTPURLResponse {
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

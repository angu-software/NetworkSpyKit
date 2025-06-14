//
//  NetworkClientFake.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

import NetworkSpyKit

final class NetworkClientFake {

    private let session: URLSession

    init(sessionConfiguration: URLSessionConfiguration) {
        self.session = URLSession(configuration: sessionConfiguration)
    }

    func sendRequest(_ request: URLRequest = .fixture()) async throws -> NetworkSpy.Response {
        let (data, urlResponse) =  try await session.data(for: request)

        let httpURLResponse = urlResponse as! HTTPURLResponse

        return NetworkSpy.Response(statusCode: httpURLResponse.statusCode,
                                   headers: httpURLResponse.allHeaderFields as! [String: String],
                                   data: data)
    }
}

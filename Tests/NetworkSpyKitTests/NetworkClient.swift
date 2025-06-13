//
//  NetworkClient.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

@testable import NetworkSpyKit

final class NetworkClient {

    private let session: URLSession

    init(sessionConfiguration: URLSessionConfiguration) {
        self.session = URLSession(configuration: sessionConfiguration)
    }

    func sendRequest() async throws -> NetworkSpy.Response {
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpMethod = "GET"

        let (data, urlResponse) =  try await session.data(for: request)

        let httpURLResponse = urlResponse as! HTTPURLResponse

        return NetworkSpy.Response(statusCode: httpURLResponse.statusCode,
                                   headers: httpURLResponse.allHeaderFields as! [String: String],
                                   data: data)
    }
}

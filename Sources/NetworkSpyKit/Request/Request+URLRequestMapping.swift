//
//  Request+URLRequestMapping.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension Request {

    init?(urlRequest: URLRequest) {
        guard let url = urlRequest.url else {
            return nil
        }

        self.init(httpMethod: urlRequest.httpMethod ?? "GET",
                  url: url,
                  headers: urlRequest.allHTTPHeaderFields ?? [:],
                  bodyData: urlRequest.resolvedHTTPBody())
    }
}



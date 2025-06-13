//
//  Request+URLRequestMapping.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension Request {

    init?(urlRequest: URLRequest) {
        guard let url = urlRequest.url,
              let httpMethod = urlRequest.httpMethod else {
            return nil
        }

        self.init(httpMethod: httpMethod,
                  url: url,
                  headers: urlRequest.allHTTPHeaderFields ?? [:],
                  bodyData: urlRequest.httpBody)
    }
}

//
//  HTTPMessageFormatter+URLRequest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 03.11.25.
//

import Foundation

extension HTTPMessageFormatter {

    func string(from urlRequest: URLRequest) -> String {
        guard let messageComponents = HTTPMessageComponents(urlRequest: urlRequest) else {
            return ""
        }

        return string(from: messageComponents)
    }
}

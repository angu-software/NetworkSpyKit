//
//  Response.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension NetworkSpy {

    struct Response: Equatable {
        var statusCode: Int
        var headers: [String: String]
        var data: Data?
    }
}

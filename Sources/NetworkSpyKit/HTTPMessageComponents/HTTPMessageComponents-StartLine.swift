//
//  StartLine.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

extension HTTPMessageComponents {

    // TODO: require HTTPVersion but use default value, move closer to RFC conformance.
    // omitting http version is convenience when matching in tests later
    enum StartLine: Equatable {
        case requestLine(method: String, absolutePath: String, httpVersion: String = "HTTP/1.1")
        case statusLine(httpVersion: String = "HTTP/1.1", statusCode: Int, reason: String?)
    }
}

extension HTTPMessageComponents.StartLine {

    var method: String? {
        switch self {
        case .requestLine(let method, _, _):
            return method
        default:
            return nil
        }
    }

    var absolutePath: String? {
        switch self {
        case .requestLine(_, let absolutePath, _):
            return absolutePath
        default:
            return nil
        }
    }

    var httpVersion: String? {
        switch self {
        case .requestLine(_, _, let httpVersion):
            return httpVersion
        case .statusLine(let httpVersion, _, _):
            return httpVersion
        }
    }

    var statusCode: Int? {
        switch self {
        case .statusLine(_, let statusCode, _):
            return statusCode
        default:
            return nil
        }
    }

    var statusReason: String? {
        switch self {
        case .statusLine(_, _, let statusReason):
            return statusReason
        default:
            return nil
        }
    }
}

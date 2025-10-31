//
//  StartLine.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

extension HTTPMessageComponents {

    struct StartLine {

        // request-line
        var method: String?
        var absolutePath: String?

        // status-line
        var statusCode: Int?
        var statusReason: String?

        var httpVersion: String?
    }
}

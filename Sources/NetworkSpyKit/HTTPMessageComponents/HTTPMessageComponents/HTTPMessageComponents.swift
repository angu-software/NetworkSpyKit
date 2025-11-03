//
//  HTTPMessageComponents.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

struct HTTPMessageComponents: Equatable {
    let startLine: StartLine
    var headerFields: [String: String]?
    var body: Data?
}

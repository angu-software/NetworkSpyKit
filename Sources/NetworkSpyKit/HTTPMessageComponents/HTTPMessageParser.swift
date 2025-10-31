//
//  HTTPMessageParser.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

struct HTTPMessageParser {

    func components(from httpMessage: String) -> HTTPMessageComponents? {
        let components = HTTPMessageComponents(startLine: .requestLine(method: httpMessage, absolutePath: "", httpVersion: nil))

        return components
    }
}

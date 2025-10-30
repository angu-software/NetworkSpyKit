//
//  HTTPMessageParser.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

struct HTTPMessageParser {

    func components(from httpMessage: String) -> HTTPMessageComponents? {
        var components = HTTPMessageComponents()
        components.method = httpMessage

        return components
    }
}

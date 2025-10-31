//
//  HTTPMessageParser.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

struct HTTPMessageParser {

    private let space = " "

    func components(from httpMessage: String) -> HTTPMessageComponents? {
        let components = httpMessage.components(separatedBy: space)
        guard components.count >= 2 else {
            return nil
        }

        var httpVersion: String?
        if components.count == 3 {
            httpVersion = components[2]
        }

        return HTTPMessageComponents(startLine: .requestLine(method: components[0],
                                                             absolutePath: components[1],
                                                             httpVersion: httpVersion))
    }
}

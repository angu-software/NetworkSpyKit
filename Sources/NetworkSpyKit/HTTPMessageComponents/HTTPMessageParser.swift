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
        guard components.count == 2 else {
            return nil
        }

        return HTTPMessageComponents(startLine: .requestLine(method: httpMessage, absolutePath: "", httpVersion: nil))
    }
}
